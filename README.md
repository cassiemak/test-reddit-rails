# Testing
### TDD (Testing-driven Development)
TDD is a software development process. Test-driven development offers more than just simple validation of correctness, but can also drive the design of a program. By focusing on the test cases first, one must imagine how the functionality is used by clients (in the first case, the test cases). So, the programmer is concerned with the interface before the implementation. This benefit is complementary to Design by Contract as it approaches code through test cases rather than through mathematical assertions or preconceptions.

The process roughly has the following cycle:

1. The developer writes an automated test case that defines the desired function / improvement
2. The developer produces the minimum amount of code to pass the test
3. The developer will refactor the new code to great standards
4. Run all tests to make sure nothing fails
5. Deploy to production server

Repeat!

Notes:
- Keep the test unit small. There are several benefits:
- When tests fail, it will be easier to track down the problem and debug
- Small test cases are self-documenting tests = better readability and rapid understandability

### BDD (Behaviour-driven Development)

### Rspec
A Behaviour Driven Development Framework for Ruby.
- http://rspec.info/
- https://relishapp.com/rspec

### Install Rspec
In Gemfile, add:
```ruby
group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
end
```

Then, in Terminal, do:
```terminal
bundle install
```

Initialize the spec/ directory, in Terminal, do:
```terminal
rails generate rspec:install
```

### How to run tests
In Terminal, run:
```terminal
rake spec
```

Be default, it will run all specs in the spec directory.

If you want to run specific specs, for example, controller specs, you can do, in Terminal:
```terminal
rake spec:controllers
```

### Before we start
Go to Github and Clone Test-Reddit-Rails project in https://github.com/HK-WDI-November-2014/test-reddit-rails. We will be using this repo to learn rspec.

### Feature Specs
Feature specs, a kind of acceptance test, are high-level tests that walk through your entire application ensuring that each of the components work together. They’re written from the perspective of a user clicking around the application and filling in forms. 

- Use RSpec and Capybara, which allow you to write tests that can interact with the web page
- https://github.com/jnicklas/capybara

### Controller Specs
Controller specs are used to test multiple paths through a controller. They usually run faster than feature specs.

In Terminal, do:
```terminal
rails g rspec:controller posts
```

```ruby
require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

RSpec.describe PostsController, :type => :controller do
  describe "GET index" do
    it "assigns @teams" do

      # Create a user
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoo")

      # Make 20 posts
      for i in 1..20
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com", :created_at => Time.now - i * 2.minutes)
      end

      expect(user.posts.count).to eq(20)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end
end
```

### Model Specs
Model specs test validations, classes and methods. It sometimes interacts with the database in the test environment.

In Terminal, do:
```terminal
rails g rspec:model post
```

```ruby
require 'rails_helper'

RSpec.describe Post, :type => :model do
  context "trying to make 2 posts within 1 minute" do
    it "should raise error" do
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoo")
      user.posts.create!(:title => "foobar", :url => "http://www.foobar.com")
      expect{
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com")
        }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "trying to make more than 20 posts per user" do
    it "should raise error" do
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoo")

      # Make 20 posts
      for i in 1..21
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com", :created_at => Time.now - i * 2.minutes)
      end

      # Make 21th post
      expect{
        user.posts.create!(:title => "foobar", :url => "http://www.foobar.com")
        }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
```

### View Specs
View specs are used to test the conditional display of information in templates.

In Terminal, do:
```terminal
rails g rspec:view posts
```

Create `index.html.erb_spec.rb` inside `spec/views/posts`

```ruby
require "rails_helper"
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
DatabaseCleaner.clean

RSpec.describe "posts/index" do

  context "with 2 posts" do
    user = User.create!(:email => "foo@bar.com", :password => "foobarfoo")

    before(:each) do
      assign(:posts, [
        user.posts.create!(:title => "Yahoo", :url => "http://www.yahoo.com", :created_at => Time.now - 3.minutes),
        user.posts.create!(:title => "Google", :url => "http://www.google.com")
      ])
    end

    it "displays both posts" do
      render

      expect(rendered).to match /Yahoo/
      expect(rendered).to match /Google/
      expect(rendered).not_to match /Microsoft/
    end
  end
end
```

### FactoryGirl
Sometimes, you need to set up database records in a way to test different scenarios.

