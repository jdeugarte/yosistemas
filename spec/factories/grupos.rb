# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :grupo do
    nombre "Grupo de prueba"
    descripcion "grupo para specs"
    estado false
    llave "qwerty"
  end
end
