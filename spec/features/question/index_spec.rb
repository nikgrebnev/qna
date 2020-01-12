require 'rails_helper'

feature 'Show all questions', %q{
  In order to show answers
  As an user
} do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 10, user: user) }

  scenario 'Index questions' do
    visit questions_path

    questions.each do |question|
      expect(page).to have_content question.title
    end
  end

end