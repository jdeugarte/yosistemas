# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usuario do
    nombre "MyString"
    apellido "MyString"
    contrasenia "MyString"
    correo "MyString"
  end
end
