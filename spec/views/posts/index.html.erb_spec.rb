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