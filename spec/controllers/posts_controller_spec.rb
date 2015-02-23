require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe PostsController, :type => :controller do
  describe "GET index" do
    it "assigns @teams" do
      DatabaseCleaner.clean

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
