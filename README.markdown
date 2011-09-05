# Authlogic example

My own authlogic playground, with Rails 3 info from [this post](http://www.dixis.com/?p=352), plus bits of other functionality/explanation.

# Add authlogic and its generators to our ```Gemfile```

```ruby
gem 'authlogic'
gem 'rails3-generators'
```

Run ```bundle install``` as usual.

# Create an authlogic session

```sh
rails g authlogic:session UserSession
```

This creates an empty ```UserSession``` model that derives from ```Authlogic::Session::Base```.

# Create (or update) a user model

We'll assume our user model is named ```User``` (creative!). If we already have one, we can add a bunch of fields to it via a migration, otherwise we'll create a new one. 

## Required fields

```ruby
t.string    :login,                :null => false
t.string    :email,                :null => false
t.string    :crypted_password,     :null => false
t.string    :password_salt,        :null => false
t.string    :persistence_token,    :null => false
```

There are a number of optional fields. See the [user migration file](https://github.com/davelnewton/auth_logic_example/blob/master/db/migrate/20110904214100_create_users.rb) or read the actual docs for further info.

# Make our user model authentic

```ruby
class User < ActiveRecord::Base
  acts_as_authentic
end
```

## Configure authlogic

Pass a block to ```acts_as_authentic``` to [configure authlogic parameters](http://rdoc.info/github/binarylogic/authlogic/master/Authlogic/ActsAsAuthentic/Password/Config). For example, during testing, I disabled password confirmation to make things easier.

```ruby
acts_as_authentic do |c|
  c.require_password_confirmation = false
end
```

# Routes and controllers and views, oh my!

More discussion of the code below lives at the link at the top of the readme; I copied it largely verbatim.

* [routes](https://raw.github.com/davelnewton/auth_logic_example/master/config/routes.rb) (login, logout, home page)
* [application controller](https://github.com/davelnewton/auth_logic_example/blob/master/app/controllers/application_controller.rb) (helpers)
* [session controller](https://github.com/davelnewton/auth_logic_example/blob/master/app/controllers/user_sessions_controller.rb) (login, logout)
* [home controller](https://github.com/davelnewton/auth_logic_example/blob/master/app/controllers/home_controller.rb) (index page, ```before_filter``` to require login)
* [session views](https://github.com/davelnewton/auth_logic_example/tree/master/app/views/user_sessions) (Login form)

# Create a user

We'll use ```rails console``` to create our first user.

```ruby
pry(main)> User.create(:login => 'login1', :password => 'login1', :email => 'foo@bar.baz').save!
```

By default, authlogic requires an email address, and validates the password length.

Configure the validations in the ```acts_as_authentic``` block as detailed above. The docs list the defaults, but we can also spelunk using [Pry](https://github.com/pry/pry) and see for ourselves.

```ruby
pry(main)> cd User
pry(#<Class:0x1041dcc20>):1> validates_length_of_password_field_options
=> {:minimum=>4, :if=>:require_password?}
pry(#<Class:0x1041dcc20>):1> validates_format_of_email_field_options
=> {:with=>/^[A-Z0-9_\.%\+\-']+@(?:[A-Z0-9\-]+\.)+(?:[A-Z]{2,4}|museum|travel)$/i, :message=>"should look like an email address."}
pry(#<Class:0x1041dcc20>):1> validates_length_of_email_field_options
=> {:maximum=>100}
```

The length validations accepts the usual length validation hash options.
