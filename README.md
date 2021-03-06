[![Build Status](https://travis-ci.org/lumoslabs/campystrano.png)](https://travis-ci.org/lumoslabs/campystrano)

Campystrano
===========

This project rocks and uses MIT-LICENSE.

Campystrano adds Campfire deploy hooks into the Capistrano deploy process.

Installation
------------

Add the following to your Gemfile:
```
gem 'campystrano'
```

In your `config/deploy.rb` file, add the following:
```
  require 'campystrano'
  set :campfire_settings do
    {
      subdomain: mysubdomain,
      room: myroom,
      token: ENV['CAMPFIRE_TOKEN']
    }
  end
```

The ```:campfire_settings``` block must return a hash containing your Campfire account credentials. The ```:subdomain``` and ```:room``` are required. You must also set either a ```:token``` or a ```:username```/```:password``` pair.

Configuration
-------------

You can configure the emoji that bookends your deploy messages by adding the following to `config/deploy.rb`
```
set :campfire_emoji, ':neckbeard:'
```

TODO
----
1. Add hooks for deploy failures and rollbacks
2. Add support for custom hooks
