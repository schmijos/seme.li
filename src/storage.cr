require "uuid"
require "sqlite3"

class Storage
  @db : DB::Database

  def initialize(scope : String)
    @db = DB.open("sqlite3:///tmp/#{scope}.db")
    migrate
  end

  def finalize
    @db.close
  end

  def put(ciphertext : String, expires_at : Int64) : String
    id = UUID.random.to_s
    @db.exec "INSERT INTO secrets (id, ciphertext, expires_at) VALUES(?, ?, ?)", id, ciphertext, expires_at
    id
  end

  def consume(id : String) : String?
    ciphertext = @db.query_one?(
      "SELECT ciphertext FROM secrets WHERE id = ? AND expires_at > ?",
      id,
      Time.utc.to_unix,
      as: String
    )

    @db.exec "DELETE FROM secrets WHERE id = ?", id
    ciphertext
  end

  def cut
    @db.exec "DELETE FROM secrets WHERE expires_at <= ?", Time.utc.to_unix
  end

  def size
    @db.scalar("SELECT COUNT(1) FROM secrets").as(Int64)
  end

  private def migrate
    @db.exec "CREATE TABLE IF NOT EXISTS secrets (
                id TEXT PRIMARY KEY,
                ciphertext TEXT NOT NULL,
                expires_at INTEGER NOT NULL
             )"
  end
end
