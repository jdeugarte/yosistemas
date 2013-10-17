class Tema < ActiveRecord::Base
  has_many :comments
  has_many :suscripcion_temas
  belongs_to :usuario
  belongs_to :grupo
  validates :titulo, :cuerpo, :presence => { :message => " es requerido" }
  
  def correspondeATitulo(titulo)
    parametros = titulo.split(' ')
    
    parametros.each do |parametro|
       if self.titulo.downcase.include?(parametro.downcase)
         return true
       end
    end
    false
  end

  after_create do
    if(self.grupo==nil)
      grupo = Grupo.find(1)
      self.grupo = grupo
      self.save
    
    end

  end
end
