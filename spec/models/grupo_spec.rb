require 'spec_helper'

describe Grupo do
  it "tiene  un factory o construtor valido" do
    expect(FactoryGirl.build(:grupo)).to be_valid
  end

  it "no es valido si no tiene un nombre de grupo" do
    grupo = FactoryGirl.build(:grupo, nombre: nil)
    expect(grupo).to have(1).errors_on(:nombre)
    expect(grupo).to_not be_valid 
  end
  
  
end
