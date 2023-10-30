# Semel Secure Message

Visit [seme.li](https://seme.li) to share expiring secrets once.
Encryption and decryption is done exclusively in the browser.
No secret reaches the server.

_Semper Semel Simplex!_

## Run your own

This is a _12factor_ app using the Apt and Crystal Heroku buildpacks.
Installation is as easy as clicking this button. 

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

> **Warning**
> Be aware though that you'll
[loose your SQLite database often](https://devcenter.heroku.com/articles/dynos#ephemeral-filesystem)
if you use Heroku. You may want to hook into a Postgres database
or use [Dokku with a volume](https://dokku.com/docs/advanced-usage/persistent-storage/)
on your own server.
Sticking to a SQLite database also means that you can run on 1 "dyno" only.

## Development

Install required prerequisites:

* Crystal >=1.1
* SQLite3
* [mkcert](https://github.com/FiloSottile/mkcert)

Then run those convenient scripts from the project root:

```sh
bin/setup
bin/check
bin/run
```

## FAQ

* **Why is there no file upload support?**

  File upload capabilities would increase demands for the backend and complexity in general.
  The idea is rather that you encrypt a file and send it through an insecure channel.
  You would then only share the encryption key via [seme.li](https://seme.li).
  
  If you really want file upload support, you can add it yourself.
  Have a look at [this PR](https://github.com/schmijos/seme.li/pull/3).

  Alternatively you can use one of the more bloated alternatives
  out there like [wormhole.app](https://wormhole.app/) or [transferly.swiss](https://www.transferly.swiss/).

## Contributing

1. Fork it (<https://github.com/schmijos/seme.li>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

2021-2023 Copyright by Josua Schmid, published under the AGPL license
