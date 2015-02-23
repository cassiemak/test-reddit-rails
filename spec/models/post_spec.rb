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
