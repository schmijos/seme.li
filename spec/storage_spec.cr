require "spec"
require "../src/storage"

describe Storage do
  after_each do
    File.delete("./data/test.db")
  end

  describe "#put" do
    it "adds an entry to the database" do
      storage = Storage.new("test")
      storage.size.should eq 0
      storage.put("BEEF1337", Time.utc.to_unix + 5)
      storage.size.should eq 1
    end
  end

  describe "#consume" do
    it "can consume something" do
      storage = Storage.new("test")
      id = storage.put("BEEF1337", Time.utc.to_unix + 5)
      storage.consume(id).should eq "BEEF1337"
      storage.size.should eq 0
    end

    it "can NOT consume expired" do
      storage = Storage.new("test")
      id = storage.put("BEEF1337", Time.utc.to_unix - 1)
      storage.consume(id).should eq nil
      storage.size.should eq 0
    end

    it "can NOT consume expiring" do
      storage = Storage.new("test")
      id = storage.put("BEEF1337", Time.utc.to_unix + 0)
      storage.consume(id).should eq nil
      storage.size.should eq 0
    end

    it "can NOT consume non-existing" do
      storage = Storage.new("test")
      storage.put("BEEF1337", Time.utc.to_unix + 5)
      storage.consume("BLUBEDI").should eq nil
      storage.size.should eq 1
    end
  end

  describe "#cut" do
    it "deletes old records" do
      storage = Storage.new("test")
      storage.put("BEEF1337", Time.utc.to_unix - 1)
      storage.put("BEEF1337", Time.utc.to_unix + 5)

      storage.size.should eq 2
      storage.cut
      storage.size.should eq 1
    end
  end

  describe "#size" do
    it "counts" do
      storage = Storage.new("test")
      storage.size.should eq 0
      storage.put("BEEF1337", Time.utc.to_unix + 5)
      storage.size.should eq 1
    end
  end
end
