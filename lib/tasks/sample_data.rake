namespace :db do
	desc "Fill databases with sample data"
	task populate :environment do
		User.create!(	name: "Example user",
						email: "exammple@railstutorial",
						password: "foobar",
						password_confirmation: "foobar")
		99.times do |n|
			name = Faker::Name.name
			email = "example-#{n+1}@railstutorial.org"
			password = "password"
			User.create!(	name: name,
							email: email,
							password: password,
							password_confirmation: password)	
		end
	end
end