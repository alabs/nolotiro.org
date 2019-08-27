# nolotiro.org

[![Build Status][Travis Badge]][Travis URL]
[![Dependency Status][Gemnasium Badge]][Gemnasium URL]
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Falabs%2Fnolotiro.org.svg?type=shield)](https://app.fossa.io/projects/git%2Bgithub.com%2Falabs%2Fnolotiro.org?ref=badge_shield)

This is the next revision of nolotiro.org (v3), this time in [Ruby On Rails].

* Ruby: 2.5
* Rails: 5.1
* PostgreSQL: 9.6

## Automatic Installation

You need to install [VirtualBox] and [Vagrant]. Then from the root directory of
the project, execute

```
vagrant up
 ```

When finished, you need to log in to the virtual machine with the command

```
vagrant ssh
```

Finally you should start the application server

```
cd /vagrant
bin/rails s -b 0.0.0.0
```

Now you can access the web application at this URL

```
http://localhost:3000
```

## Manual Installation

Check out the script in `bin/bootstrap.sh` - that's the same that Vagrant uses.

## Test setup

Running `bin/rake` will run all the tests, that should always pass on a freshly
downloaded copy a nolotiro's master.

## More information

For obtaining geographic information we use [Yahoo YQL].

For IP GeoLocation we use [GeoLite2] City. The database is bundled with this
repo in compressed format. To extract the database, run

```
bin/rake max_mind:extract
```

You can also, grab the latest version of the DB from MaxMind by running

```
bin/rake max_mind:update
```

For delayed tasks, we use Sidekiq, that uses Redis. For caching, we use Redis.

```
sudo apt-get install redis-server
bundle exec sidekiq
```

## Development environment magic

For the emails we recommend using mailcatcher. This doesn't send external emails
during development, and you can see them in a nice web interface. The SMTP port
is already configured.

```
gem install mailcatcher
mailcatcher
open http://localhost:1080
```

Happy hacking!

## i18n

For the localization and translation interface we use [LocaleApp].

## API

### v1

Example URLs:

```
https://beta.nolotiro.org/api/v1/woeid/list
https://beta.nolotiro.org/api/v1/woeid/766273/give
https://beta.nolotiro.org/api/v1/woeid/766273/give?page=2
https://beta.nolotiro.org/api/v1/ad/153735
```

## 3rd Party

* Core based on [Ruby On Rails].
* Geographical data is mantained in-app, and it started as a modified copy of
  the [Yahoo Geoplanet] DB, which originally released as CC BY 3.0 US, then
  taken down, but still available in archive.org.
* [jQuery] for Javascript.
* [GeoLite2] data API by MaxMind to auto detect user location.
* Logo by Silvestre Herrera under GPL License.

[Gemnasium Badge]: https://gemnasium.com/alabs/nolotiro.org.svg
[Gemnasium URL]: https://gemnasium.com/alabs/nolotiro.org
[GeoLite2]: https://dev.maxmind.com/geoip/geoip2/geolite2
[jQuery]: https://jquery.com
[Ruby on Rails]: http://rubyonrails.org
[Travis Badge]: https://travis-ci.org/alabs/nolotiro.org.svg?branch=master
[Travis URL]: https://travis-ci.org/alabs/nolotiro.org
[Vagrant]: https://www.vagrantup.com/
[Virtualbox]: https://www.virtualbox.org/
[Yahoo Geoplanet]: https://archive.org/details/geoplanet_data_7.10.0.zip


## License
[![FOSSA Status](https://app.fossa.io/api/projects/git%2Bgithub.com%2Falabs%2Fnolotiro.org.svg?type=large)](https://app.fossa.io/projects/git%2Bgithub.com%2Falabs%2Fnolotiro.org?ref=badge_large)