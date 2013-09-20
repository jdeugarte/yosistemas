require 'spec_helper'

describe Tema do
  it "deberia poder guardarse un tema" do
    Tema.create!(titulo: "titulo", cuerpo: "no importa").should be_persisted
  end

  it "no deberia poder guardarse un tema con un titulo vacio" do
   Tema.create!(titulo: "", cuerpo: "no importa").should not_be_persisted
  end
end
