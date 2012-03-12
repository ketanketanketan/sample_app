namespace :db do
  
  desc "Fill databse with sample data"
  
  task :populate => :environment do
    
    Rake::Task['db:reset'].invoke
    
    admin = User.create!(   :name => "Example User",
                            :email => "example@railstutorial.org",
                            :password => "foobar",
                            :password_confirmation => "foobar")
    admin.toggle!(:admin)
    
    ketan = User.create!(   :name => "Ketan Patel",
                            :email => "str8ketan@gmail.com",
                            :password => "foobar",
                            :password_confirmation => "foobar")
    ketan.toggle!(:admin)
    
    98.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password = "password"
      User.create!( :name => name,
                    :email => email,
                    :password => password,
                    :password_confirmation => password)
    end
    
    50.times do 
      User.all(:limit => 6).each do |user|
        user.microposts.create!(:content => Faker::Lorem.sentence(5))
      end
    end
    
  end

end