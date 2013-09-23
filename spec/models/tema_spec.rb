require 'spec_helper'

describe Tema do
  it "tiene  un factory o construtor valido" do
    expect(FactoryGirl.build(:tema)).to be_valid
  end

  it "no es valido si no tiene titulo" do
    tema = FactoryGirl.build(:tema, titulo: nil)
    expect(tema).to have(1).errors_on(:titulo)
    expect(tema).to_not be_valid 
  end
end


