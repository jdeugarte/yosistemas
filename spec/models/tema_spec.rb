require 'spec_helper'

describe Tema do
  it "es valido si tiene titulo" do
    tema = Tema.new(
      titulo: 'Hola',
      cuerpo: 'Primer tema')
    # tema.should be_valid
    expect(tema).to be_valid #mismo que anterior, siguiendo la nueva notacion de rspec
  end

  it "no es valido si no tiene titulo" do
    tema = Tema.new(titulo: nil)
    expect(tema).to have(1).errors_on(:titulo)
    expect(tema).to_not be_valid #redundante, pero sirve para mostrar esta opcion
  end

  it "no deberia poder guardarse un titulo vacio" do
   tema =Tema.create(titulo: "", cuerpo: "Segundo tema")
   tema.titulo == ""
   expect(Tema).to have(0).records
  end
end
