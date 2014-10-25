class Tarea < ActiveRecord::Base
  belongs_to :usuario
  belongs_to :grupo
  has_many :archivo_adjuntos
  has_many :notificacion_grupos
  has_many :tarea_comentarios
  validates :titulo, :presence => { :message => " es requerido" }
  validates :descripcion, :presence => { :message => " es requerida" }
  validates :fecha_entrega, :presence => { :message => " es requerida" }
  validates :hora_entrega, :presence => { :message => " es requerida" }
  delegate :nombre_usuario, :to => :usuario, :prefix => true
  
  def self.buscar_tarea(id)
        tarea=nil
        begin
          tarea = Tarea.find(id)
          rescue ActiveRecord::RecordNotFound
        end
      return tarea
  end

  def tarea_caducada
    fecha_actual=Date.new(Date.today().year, Date.today().month,Date.today().day)
    hora_actual=Time.new(hora_entrega.year, hora_entrega.month, hora_entrega.day, Time.now().hour, Time.now().min, Time.now().sec, "-00:00")
    if( (fecha_entrega <=> fecha_actual) == -1)
      return true
    elsif((fecha_entrega === fecha_actual) && ((hora_entrega<=>hora_actual)==-1))
      return true
    end
    return false
  end

   def self.searchByDescriptionTarea(keyWords)
    keyWords = keyWords.downcase
      initialResult = Tarea.where('descripcion LIKE ?', '%'+keyWords+'%')
      deepResult = Tarea.deepSearchOfDescriptionTarea(keyWords)
      finalRes  = (initialResult+deepResult).uniq
      finalRes
  end

  def self.deepSearchOfDescriptionTarea(keyWords)
    keyWordArray = keyWords.split
    keyWordArray = Tarea.deleteIrrelevantWords(keyWordArray)
    keyWordArray.uniq!
    results=[]
    keyWordArray.each do |word|
      results<<Tarea.where('descripcion LIKE ?', '%'+word+'%')
    end
    finalResArray = results.flatten.uniq
    finalResArray
  end

  def self.searchBytitleTarea(keyWords)
    keyWords = keyWords.downcase
    initialResult = Tarea.where('titulo LIKE ?', '%'+keyWords+'%')
    deepResult = Tarea.deepSearchOfDescriptionTarea(keyWords)
    finalRes  = (initialResult+deepResult).uniq
    finalRes
  end

  def self.deepSearchOftitleTarea(keyWords)
    keyWordArray = keyWords.split
    keyWordArray = Tarea.deleteIrrelevantWords(keyWordArray)
    keyWordArray.uniq!
    results=[]
    keyWordArray.each do |word|
      results<<Tarea.where('titulo LIKE ?', '%'+word+'%')
    end
    finalResArray = results.flatten.uniq
    finalResArray
  end

  def self.allResultsSearchsTarea(keyWords)
    rTitle = searchBytitleTarea(keyWords)
    rDescription = searchByDescriptionTarea(keyWords)
    allResults = (rTitle+rDescription).uniq
  end
  
  def self.deleteIrrelevantWords(keyWordArray)
    res = keyWordArray - ["de", "a", "la", "el","los","en","al", "con", "que","por", "si","es","son"]
    i=0
    while(i<res.length)
      if(res[i].length<=3)
        res.delete_at(i)
      end
      i+=1
    end
    res
  end
end
