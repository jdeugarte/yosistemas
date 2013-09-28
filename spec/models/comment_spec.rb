require 'spec_helper'

describe Comment do
  it "tiene un factory o construtor valido" do
    expect(FactoryGirl.build(:comment)).to be_valid
  end

  it "no es valido si no tiene comentario" do
    comentario = FactoryGirl.build(:comment, body: nil)
    expect(comentario).to have(1).errors_on(:body)
    expect(comentario).to_not be_valid 
  end
end
