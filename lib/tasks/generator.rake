require 'faker'
require 'database_cleaner'

class Fakeout

  MODELS = %w(UserGroup EvaluationType User Credential Klass Subject Student Teacher)

  def build_user
    {
        name:       Faker::Name.first_name,
        surname:    Faker::Name.last_name,
        user_group: pick_random(UserGroup)
    }
  end

  def build_klass
    {
        name: @word_spool.pop || random_letters(15),
        detail: Faker::Lorem.sentence(5)
    }
  end

  def build_subject
    { name: @word_spool.pop || random_letters(15) }
  end

  def build_usergroup; end
  def build_evaluationtype; end
  def build_credential; end
  def build_student; end
  def build_teacher; end

  def pre_fake
    %w[Admin Teacher Student].each { |g| UserGroup.create! name: g }
    %w[Written Oral Practical].each { |t| EvaluationType.create! name: t }

    @word_spool = Faker::Lorem.words(size).uniq
  end

  def post_fake
    User.all.each { |u| Credential.create! username: "user#{u.id}", password: 'password', user: u }
    User.all.each do |u|
      rand(1..5).times do
        if u.user_group.name == 'Student'
          Student.create user: u, klass: pick_random(Klass)
        elsif u.user_group.name == 'Teacher'
          Teacher.create user: u, klass: pick_random(Klass), subject: pick_random(Subject)
        end
      end
    end
  end

  def tiny
    5
  end

  def small
    25+rand(50)
  end

  def medium
    250+rand(250)
  end

  def large
    1000+rand(500)
  end

  def size(model = nil)
    send(@size)
  end

  def initialize(size)
    @size = size
  end

  def fakeout
    puts "Faking it ... (#{size})"
    Fakeout.disable_mailers

    pre_fake

    MODELS.each do |model|
      unless respond_to?("build_#{model.downcase}")
        puts "  * #{model.pluralize}: **warning** I couldn't find a build_#{model.downcase} method"
        next
      end

      print "  * #{model.pluralize}: "
      1.upto(send(:size, model)) do
        attributes = send("build_#{model.downcase}")
        model.constantize.create!(attributes) if attributes && !attributes.empty?
      end

      puts "#{model.constantize.count(:all)}"
    end

    post_fake

    puts "Done, I Faked it!"
  end

  def self.clean
    puts "Cleaning all ..."

    Fakeout.disable_mailers
    #%w[ db:drop db:create db:migrate ].each { |t| Rake::Task[t].execute }
    DatabaseCleaner.clean_with :truncation
  end

  # by default, all mailings are disabled on faking out
  def self.disable_mailers
    ActionMailer::Base.perform_deliveries = false
  end


  private
  # pick a random model from the db, done this way to avoid differences in mySQL rand() and postgres random()
  def pick_random(model, optional = false)
    return nil if optional && (rand(2) > 0)
    ids = ActiveRecord::Base.connection.select_all("SELECT id FROM #{model.to_s.tableize}")
    model.find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end

  # useful for prepending to a string for getting a more unique string
  def random_letters(length = 2)
    Array.new(length) { (rand(122-97) + 97).chr }.join
  end

  # pick a random number of tags up to max_tags, from an array of words, join the result with seperator
  def random_tag_list(tags, max_tags = 5, seperator = ',')
    start = rand(tags.length)
    return '' if start < 1
    tags[start..(start+rand(max_tags))].join(seperator)
  end

  # fake a time from: time ago + 1-8770 (a year) hours after
  def fake_time_from(time_ago = 1.year.ago)
    time_ago+(rand(8770)).hours
  end
end


# the tasks, hook to class above - use like so;
# rake fakeout:clean
# rake fakeout:small
# rake fakeout:medium RAILS_ENV=bananas
#.. etc.
namespace :fakeout do

  desc "clean away all data"
  task :clean => :environment do
    Fakeout.clean
  end

  desc "fake out a tiny dataset"
  task :tiny, [:no_prompt] => :clean do
    Fakeout.new(:tiny).fakeout
  end

  desc "fake out a small dataset"
  task :small, [:no_prompt] => :clean do
    Fakeout.new(:small).fakeout
  end

  desc "fake out a medium dataset"
  task :medium, [:no_prompt] => :clean do
    Fakeout.new(:medium).fakeout
  end

  desc "fake out a large dataset"
  task :large, [:no_prompt] => :clean do
    Fakeout.new(:large).fakeout
  end
end
