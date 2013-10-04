# Read about factories at https://github.com/thoughtbot/factory_girl
require 'digest/md5'

FactoryGirl.define do
  factory :usuario do
    nombre "Pedro"
    apellido "Pedregal"
    contrasenia "password"
    correo "email@email.com"
    activa true
  end
end
