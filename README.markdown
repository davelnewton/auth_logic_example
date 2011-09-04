# Authlogic example

My own authlogic playground.

# Add authlogic and its generators to ```Gemfile```

```ruby
gem 'authlogic'
gem 'rails3-generators'
```

Run ```bundle install``` as usual.

# Create the authlogic session

The instructions provided in the [authlogic example](https://github.com/binarylogic/authlogic_example) are not correct for Rails 3. [This post](http://www.dixis.com/?p=352) provided more information.

```sh
rails g authlogic:session UserSession
```

This creates an empty ```UserSession``` model that derives from ```Authlogic::Session::Base```.

## Create the user model (if haven't already)
