# encoding: utf-8

FactoryGirl.define do
  
  factory :user_level do 
    position             "admin"
    user_id              1
  end
  
  factory :user do 
 
    name                  "Test User"
    login                 'testuser'
    email                 "test@test.com"
    password              "password1"
    password_confirmation {password}
    status                "active"
    last_updated_by_id    1

    #user_levels
    #after(:build) do |user|
    #  user.user_levels << FactoryGirl.build(:user_level, :user => user)
    #end
  end

  factory :session do
    session_id             'afdbdd11'
    data                   'blablabla'    
  end
 
  factory :sys_log do    
    log_date                '2012-2-2'
    user_name               'blabla'
    user_id                 1
    user_ip                 '1.2.3.4'
    action_logged           'create a new user in FactoryGirl'
  end
  
end



