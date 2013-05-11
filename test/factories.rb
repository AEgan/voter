FactoryGirl.define do

	factory :competitor do
		name "Michael Dougherty"
		description "The most feared teacher at the prep"
		wins 0
		times_played 0
		elo 1200
	end

	factory :user do
		first_name "Alex"
		last_name "Egan"
		email "alex@example.com"
		role "admin"
		password "secret"
		password_confirmation "secret"
		active true
	end
	
end