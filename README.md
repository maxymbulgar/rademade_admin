rademade_admin
========

[![Gem Version](http://img.shields.io/gem/v/rademade_admin.svg)][gem]
[![Build Status](https://travis-ci.org/Rademade/rademade_admin.svg?branch=master)](https://travis-ci.org/Rademade/rademade_admin)
[![Coverage Status](https://coveralls.io/repos/Rademade/rademade_admin/badge.png)][coveralls]
[![Code Climate](http://img.shields.io/codeclimate/github/Rademade/rademade_admin.svg)][codeclimate]
[![PullReview stats](https://www.pullreview.com/github/Rademade/rademade_admin/badges/master.svg?)](https://www.pullreview.com/github/Rademade/rademade_admin/reviews/master)



**Best rails admin panel!**


How to use it
--------------

1) Add `gem 'rademade_admin', :github => 'rademade/rademade_admin'` to Gemfile

2) Mount rails engine at routing.rb `mount RademadeAdmin::Engine => '/rademade_admin`

3) Create `User` model  and other needed models
```ruby
# encoding: utf-8
require 'digest/sha1'

class User
  include Mongoid::Document
  include RademadeAdmin::UserModule

  field :first_name, :type => String
  field :email, :type => String
  field :encrypted_password, :type => String
  field :admin, :type => Boolean, :default => false

  def self.get_by_email(email)
    self.where(:email => email).first
  end

  def password=(password)
    self[:encrypted_password] = encrypt_password(password) unless password.blank?
  end

  def valid_password?(password)
    self[:encrypted_password] == encrypt_password(password)
  end

  def to_s
    email
  end

  private

  def encrypt_password(password)
    Digest::SHA1.hexdigest(password)
  end

end
```


4) Add rademade_admin initializer `initializers/rademade_admin.rb`
```ruby
RademadeAdmin::Configuration.configure do
  admin_model User
end
```

5) Create admin controller. Example `app/controllers/rademade_admin/users_controller.rb`
```ruby
class RademadeAdmin::UsersController < RademadeAdmin::ModelController

  #You can leave controller absolutely empty!
  
  options do
    list do
      email
    end
    form do
      first_name
      email
      password :hint => 'Or leave it empty'
    end
  end

end
```

6) Add `admin_resources` to `routers.rb`
```ruby
namespace :rademade_admin, :path => 'admin' do
  admin_resources :users
end
```

7) Install assets with bower `rake rademade_admin:bower:install`

8) Start rails `rails s`

**Good luck :)**
