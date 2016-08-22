require 'rails_helper'

RSpec.describe "racers/new", type: :view do
  before(:each) do
    assign(:racer, Racer.new(
      :first_name => "MyString",
      :last_name => "MyString",
      :year_of_birth => 1,
      :gender => 1,
      :email => "MyString",
      :phone_number => "MyString",
      :start_number => 1
    ))
  end

  it "renders new racer form" do
    render

    assert_select "form[action=?][method=?]", racers_path, "post" do

      assert_select "input#racer_first_name[name=?]", "racer[first_name]"

      assert_select "input#racer_last_name[name=?]", "racer[last_name]"

      assert_select "input#racer_year_of_birth[name=?]", "racer[year_of_birth]"

      assert_select "input#racer_gender[name=?]", "racer[gender]"

      assert_select "input#racer_email[name=?]", "racer[email]"

      assert_select "input#racer_phone_number[name=?]", "racer[phone_number]"

      assert_select "input#racer_start_number[name=?]", "racer[start_number]"
    end
  end
end
