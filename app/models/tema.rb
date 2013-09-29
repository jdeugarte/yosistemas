class Tema < ActiveRecord::Base
  has_many :comments
  belongs_to :usuario
  validates :titulo, :presence => true
  
  def correspondeATitulo(titulo)
    parametros = titulo.split(' ')
    
    parametros.each do |parametro|
       if self.titulo.downcase.include?(parametro.downcase)
         return true
       end
    end
    false
  end
end
