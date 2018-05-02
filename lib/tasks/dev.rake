namespace :dev do
  task fake_user: :environment do
    User.destroy_all

    User.create(name:"admin", email: "admin@example.com", password: "12345678", role: "admin")
    puts "Default admin created! ( email: admin@example.com, password: 12345678 )"

    20.times do |i|
      name = FFaker::Name::first_name
      file = File.open("#{Rails.root}/public/avatar/user#{i+1}.jpg")

      user = User.new(
        name: name,
        email: "#{name}@email.com",
        password: "000000",
        intro: FFaker::Lorem::sentence,
        avatar: file
      )

      user.save!
    end
    puts "have created #{User.count} fake users"
  end

  task fake_post: :environment do 
    Post.destroy_all
    authority_list = ["all", "friend", "myself"]

    300.times do |i|
      Post.create!(
        title: FFaker::Lorem.sentence,
        content: FFaker::Lorem.paragraph,
        user: User.all.sample,
        authority: authority_list.sample
      )
    end

    Post.all.each do |post|
      post.categories << Category.all.sample(3)
    end

    puts "have created #{Post.count} post data"
  end

  # task fake_categories_posts: :environment do
  #   CategoriesPosts.destroy_all

  #   Post.all.each do |post|
  #     for i in 1..rand(1..4)
  #       CategoriesPosts.create!(
  #         post: post,
  #         category: Category.all.sample
  #       )
  #     end
  #   end

  #   puts "have created #{Categoryship.count} categoryship data" 
  # end

  task fake_reply: :environment do
    Reply.destroy_all

    500.times do

      post = Post.all.sample
      user = User.all.sample

      Reply.create!(
        comment: FFaker::Lorem.sentence,
        post: post,
        user: user
      )

      View.create(
        post: post,
        user: user
      )
    end

    puts "have created  #{Reply.count} reply data"
    puts "have created  #{View.count} view data"
  end

  task fake_favorite: :environment do
    Favorite.destroy_all

    50.times do
      Favorite.create(
        user: User.all.sample,
        post: Post.all.sample
      )
    end
    puts "have created fake favorites"
    puts "now you have #{Favorite.count} favorite data"
  end

  # task fake_views: :environment do
  #   View.destroy_all

  #   50.times do
  #     View.create!(
  #       user: User.all.sample,
  #       post: Post.all.sample
  #     )
  #   end
  #   puts "have created fake Views"
  #   puts "now you have #{View.count} View data"
  # end

  task fake_friendship: :environment do
    Friendship.destroy_all
    
    User.first(20).each do |i|
      for j in i.id + 1..20
        Friendship.create(
          user_id: i.id,
          friend_id: j,
          status: "friend"
        )
      end
    end

    puts "have created fake followships"
    puts "now you have #{Friendship.count} friend data"
  end

  task fake_all: :environment do
    #Rake::Task['db:drop'].execute
    Rake::Task['db:migrate'].execute
    Rake::Task['db:seed'].execute
    Rake::Task['dev:fake_user'].execute
    Rake::Task['dev:fake_post'].execute
    # Rake::Task['dev:fake_categories_posts'].execute
    Rake::Task['dev:fake_reply'].execute
    Rake::Task['dev:fake_favorite'].execute
    Rake::Task['dev:fake_friendship'].execute
    # Rake::Task['dev:test'].execute
  end

end