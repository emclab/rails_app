# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sys_action_on_table do
    action "MyString"
    table_name "MyString"
  end
end
