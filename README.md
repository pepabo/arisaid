Arisaid
=======

Arisaid is a configuration tool by YAML for Slack.

[![ruby gem](https://img.shields.io/gem/v/arisaid.svg?style=flat-square)][gem]
[![Travis](https://img.shields.io/travis/pepabo/arisaid.svg?style=flat-square)][travis]

[gem]: https://rubygems.org/gems/arisaid
[travis]: https://travis-ci.org/pepabo/arisaid

Installation
------------

Install it yourself as:

```sh
$ gem install arisaid
```

Usage
-----

Command examples:

```
$ arisaid show usergroups -t [SLACK_TEAM] -p [SLACK_TOKEN] > usergroups.yml
$ cat usergroups.yml | arisaid apply usergroups -t [SLACK_TEAM] -p [SLACK_TOKEN]
$ arisaid save users
```

Development
-----------

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

Contributing
------------

Bug reports and pull requests are welcome on GitHub at https://github.com/pepabo/arisaid.

License
-------

The MIT License (MIT)

Copyright (c) 2015 GMO Pepabo, Inc.
