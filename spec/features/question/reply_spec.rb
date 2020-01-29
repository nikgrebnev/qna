require 'rails_helper'

feature 'reply question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given(:question) { create(:question, user: author) }

  describe 'Authenticated user' do
    background do
      log_in(user)

      visit question_path(question)
    end

    scenario 'reply question from registered user', js: true do
      fill_in 'Answer', with: 'Test answer'
      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
      end
    end

    scenario 'reply question with attached files', js: true do
      fill_in 'Answer', with: 'Test answer'

      attach_file 'File', ["#{Rails.root}/spec/spec_helper.rb", "#{Rails.root}/spec/rails_helper.rb"]
      click_on 'Reply'

      expect(page).to have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end

    scenario 'check invalid body', js: true do
      click_on 'Reply'
      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'reply question from unregistered user' do
    visit question_path(question)
    expect(page).to_not have_button, 'Reply'
  end
end



