# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :suscripcion_tema do
    temas nil
    usuarios nil
  end
  factory :suscripcion_otro_tema do
  	tema_id 1
  	usuario_id 1
  end
end
