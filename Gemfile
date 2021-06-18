# frozen_string_literal: true

source 'https://rubygems.org'
ruby '2.5.1'

gem 'jquery-rails', '~> 4.4'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'rails', '>= 5.0'
gem 'sass-rails', '~> 5.0'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'

gem 'jbuilder', '~> 2.5'
gem 'turbolinks', '~> 5'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Auth
gem 'devise', '~> 4.7.1'

# Frontend
gem 'haml', '~> 5.0.4'
gem 'kaminari'
gem 'material_design_lite-rails'
gem 'react-flux-rails'
gem 'react-rails'
gem 'recaptcha', require: 'recaptcha/rails'
gem 'sprockets-es6'

gem 'countries', require: 'countries/global'
gem 'country_select', require: 'country_select_without_sort_alphabetical'
gem 'faker', git: 'https://github.com/stympy/faker.git', branch: 'master'

# For excel exports..
gem 'axlsx'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rubocop', require: false
end

group :development do
  gem 'bullet'
  gem 'solargraph'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
