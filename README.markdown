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

## Optional fields

```ruby
#t.string    :single_access_token, :null => false  # optional, see Authlogic::Session::Params
#t.string    :perishable_token,    :null => false  # optional, see Authlogic::Session::Perishability

# magic fields (all optional, see Authlogic::Session::MagicColumns)
t.integer   :login_count,          :null => false, :default => 0
t.integer   :failed_login_count,   :null => false, :default => 0
t.datetime  :last_request_at
t.datetime  :current_login_at
t.datetime  :last_login_at
t.string    :current_login_ip
t.string    :last_login_ip
```

In addition, we'll create some indices.

```ruby
add_index :users, ["login"], :name => "index_users_on_login", :unique => true
add_index :users, ["email"], :name => "index_users_on_email", :unique => true
add_index :users, ["persistence_token"], :name => "index_users_on_persistence_token", :unique => true
```

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

## Creating our first user

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

Note that the length validations accept the usual length validation options.
