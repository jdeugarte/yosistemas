# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :usuario do
    nombre "Pedro"
    apellido "Pedregal"
    contrasenia "password"
    correo "email@email.com"
  end
end
