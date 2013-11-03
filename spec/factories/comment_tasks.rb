# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment_task do
    tarea nil
    usuario nil
    body "MyText"
  end
end
