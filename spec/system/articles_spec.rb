require "rails_helper"

RSpec.describe "Articles", type: :system do
  it "allows the user to create an article" do
    visit root_path

    click_on "New Post"

    fill_in "Title", with: "New Article"
    fill_in "Body", with: "A new post."

    click_on "Create Article"

    expect(page).to have_text("New Article")
  end
end
