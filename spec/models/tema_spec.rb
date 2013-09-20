require 'spec_helper'

describe Tema do
  it "deberia poder guardarse" do
    Tema.create!(titulo: "titulo", cuerpo: "no importa").should be_persisted
  	expect(Tema).to have(1).record
  end

  it "no deberia poder guardarse un titulo vacio" do
   tema =Tema.create(titulo: "", cuerpo: "no importa")
   tema.titulo == ""
   expect(Tema).to have(0).records
  end
end
