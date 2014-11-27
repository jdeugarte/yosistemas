class Cuestionario < ActiveRecord::Base
  has_and_belongs_to_many :grupos
  belongs_to :usuario
  has_many :preguntas, :dependent => :destroy
  accepts_nested_attributes_for :preguntas, :reject_if => lambda{ |a| a[:texto].blank? }, :allow_destroy => true
  
  serialize :grupos_pertenecen,Array
  def esta_cerrado_cuestionario?(fecha_limite, hora_limite)
    fecha_actual=Date.new(Date.today().year, Date.today().month,Date.today().day)
    hora_actual=Time.new(hora_limite.year, hora_limite.month, hora_limite.day, Time.now().hour, Time.now().min, Time.now().sec, "-00:00")
    if( (fecha_limite <=> fecha_actual) == -1)
      return true
    elsif((fecha_limite === fecha_actual) && ((hora_limite<=>hora_actual)==-1))
      return true
    end
    return false
  end

end
