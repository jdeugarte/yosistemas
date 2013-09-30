class Tema < ActiveRecord::Base
  has_many :comments
  belongs_to :usuario 
  validates :titulo, :presence => { :message => " es requerido" }
  
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
