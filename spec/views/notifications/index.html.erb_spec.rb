require 'spec_helper'

describe "notifications/index" do
  before(:each) do
    assign(:notifications, [
      stub_model(Notification,
        :title => "Title",
        :description => "Description",
        :tipo => 1,
        :seen => false,
        :de_usuario_id => 2,
        :para_usuario_id => 3
      ),
      stub_model(Notification,
        :title => "Title",
        :description => "Description",
        :tipo => 1,
        :seen => false,
        :de_usuario_id => 2,
        :para_usuario_id => 3
      )
    ])
  end

  it "renders a list of notifications" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end
