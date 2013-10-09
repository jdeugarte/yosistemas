# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grupo do
    nombre "MyString"
    descripcion "MyText"
    estado false
    llave "MyString"
  end
end
