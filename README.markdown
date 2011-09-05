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

We'll assume we're going to use user model named ```User``` (creative!). If we already have one, we can add a bunch of fields to it via a migration. Otherwise we can just create a new one. 

## Required fields

```ruby
t.string    :login,                :null => false
t.string    :email,                :null => false
t.string    :crypted_password,     :null => false
t.string    :password_salt,        :null => false
t.string    :persistence_token,    :null => false
```

There are also a number of optional fields. See the [user migration file](https://github.com/davelnewton/auth_logic_example/blob/master/db/migrate/20110904214100_create_users.rb) for more info (or just read the original docs! ;)

# Make our user model authentic

```ruby
class User < ActiveRecord::Base
  acts_as_authentic
end
```

## Configuring authlogic

We can also [configure various authlogic parameters](http://rdoc.info/github/binarylogic/authlogic/master/Authlogic/ActsAsAuthentic/Password/Config) using the ```acts_as_authentic``` method by giving it a block. For example, during testing, I disabled the password confirmation when I created a user in the rails console, just to make things easier.

```ruby
acts_as_authentic do |c|
  c.require_password_confirmation = false
end
```

# Bunches of stuff

This code is discussed more fully at the link given at the top of this readme; here's a short list of the stuff to make it all work.

* [routes](https://raw.github.com/davelnewton/auth_logic_example/master/config/routes.rb) (login, logout, home page)
* [application controller](https://github.com/davelnewton/auth_logic_example/blob/master/app/controllers/application_controller.rb) (helpers)
* [session controller](https://github.com/davelnewton/auth_logic_example/blob/master/app/controllers/user_sessions_controller.rb) (login, logout)
* [home controller](https://github.com/davelnewton/auth_logic_example/blob/master/app/controllers/home_controller.rb) (index page, ```before_filter``` to require login)
* [session views](https://github.com/davelnewton/auth_logic_example/tree/master/app/views/user_sessions) (Login form)

# Creating our first user

We'll do this manually, in ```rails c``` (the console). Since we configured away the confirmation password, all we need is to provide a login ID, an email, and a password.

```ruby
pry(main)> User.create(:login => 'login1', :password => 'login1', :email => 'foo@bar.baz').save!
```

By default, authlogic requires an email address, and validates the password length. How can we change the required length? By using a configuration option as described above. The documentation lists the default, but let's use [Pry](https://github.com/pry/pry) to do a little spelunking.

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
