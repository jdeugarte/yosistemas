# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :notification do
    title "MyString"
    description "MyString"
    reference_date "2014-10-27"
    tipo 1
    seen false
    de_usuario_id 1
    para_usuario_id 1
  end
end
