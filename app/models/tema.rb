class Tema < ActiveRecord::Base
  has_many :comments
  validates :titulo, :presence => true
  
  def buscarTitulo(parametros, array)
    parametros = params[:titulo].split(' ')
    parametros.each do |parametro|
      if self.titulo.downcase.include?(parametro.downcase)
        @temas.push(self)
        break
      end
    end
  end
end
