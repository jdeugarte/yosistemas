# Read about factories at https://github.com/thoughtbot/factory_girl
require 'digest/md5'

FactoryGirl.define do
  factory :usuario do
    nombre "Pedro"
    apellido "Pedregal"
    contrasenia "password"
    correo "email@email.com"
    rol "Docente"
    activa true
  end

  factory :other_user, class: Usuario do
    nombre "Pedro"
    apellido "Pedregal"
    contrasenia "password2"
    correo "email2@email.com"
    rol "Docente"
    activa true
  end
end