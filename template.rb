# Setup steps for a rails project

VERSION = '0.1.1'

ruby_version = '2.3.0'
insert_into_file "Gemfile", "ruby '#{ruby_version}'", after: "source 'https://rubygems.org'\n"
insert_into_file "Gemfile", "  gem 'pry-rails'\n", after: "gem 'byebug'\n"

if yes?("Using Bootstrap?")
  gem 'bootstrap-sass', '~> 3.3.5'
else
  if yes?("Using Materialize?")
    gem 'materialize-sass'
    insert_into_file "app/assets/javascripts/application.js", "//= require materialize-sprockets\n", after: "//= require turbolinks\n"

  end
end

gem 'faker'
gem 'kaminari'
gem 'bcrypt'
gem 'react-rails', '~> 1.6.0'

gem_group :production do
  gem 'puma'
  gem 'rails_12factor'
end


file 'Procfile', "web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}"

run 'mv README.rdoc README.md'

inside('app/assets/stylesheets') do
  run "mv application.css application.scss"
end

rake("db:create")

after_bundle do
  run "rails g react:install"
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit of TIY Rails Generator v#{VERSION}' }
end
