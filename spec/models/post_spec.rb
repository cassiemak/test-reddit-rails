require 'rails_helper'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation

RSpec.describe Post, :type => :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "trying to make 2 posts within 1 minute" do 
    it "should raise an error" do
      DatabaseCleaner.clean 

      #create a user
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoobar")
      #create one post
      user.posts.create!(:title => "foobar", :url => "http://foobar.com")

      #create another post immediatley after (which is within 1 min)
      expect{
        user.posts.create!(:title => "foobar2", :url => "http://foobar2.com")
        }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "trying to make more than 20posts" do
    it "should raise error" do
      DatabaseCleaner.clean 

      #create a user
      user = User.create!(:email => "foo@bar.com", :password => "foobarfoobar")

      #create 20 posts
      # for i in 1..20
      (1..20).each do |i|
        user.posts.create!(:title => "foobar" , :url => "http://foobar.com", :created_at => Time.now - i * 2.minutes)
      end

      #create 21st post and expect an error
      expect{
      user.posts.create!(:title => "foobar2", :url => "http://foobar2.com")
      }.to raise_error(ActiveRecord::RecordInvalid)
    
    end
  end
end
