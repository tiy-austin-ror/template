# Setup steps for a rails project
#
ruby_version = ask("What is your ruby version? ")
insert_into_file "Gemfile", "ruby '#{ruby_version}'", after: "source 'https://rubygems.org'\n"

rake("db:create")
gem 'faker'
gem 'kaminari'
gem 'bcrypt'

gem_group :production do
  gem 'puma'
  gem 'rails_12factor'
end

if yes?("Using Bootstrap?")
  gem 'bootstrap-sass', '~> 3.3.5'
else
  if yes?("Using Materialize?")
    gem 'materialize-sass'
  end
end

file 'Procfile', "web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}"

run 'mv README.rdoc README.md'
inside('app/assets/stylesheets') do
  run "mv application.css application.scss"
end

after_bundle do
  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit of TIY Rails Generator v0.1.0' }
end

