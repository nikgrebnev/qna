require 'rails_helper'

feature 'delete question', %q{
} do

  given(:user) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }

  scenario 'delete from author' do
    log_in(author)
    visit question_path(question)

    expect(page).to have_link 'Delete'
    click_on 'Delete'

    expect(page).to have_content 'Deleted successfully'
    expect(page).to_not have_content question.title
  end


  scenario 'check delete button from another user' do
    log_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  scenario 'check delete button from unlogged user' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end

  describe 'Attaches' do
    background do
      log_in(author)
      visit questions_path
      click_on 'Ask question'

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'test body'

      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Ask'
    end

    scenario 'delete attaches from author' do
      within('.question-attaches') do
        expect(page).to have_link('Delete')
        click_on 'Delete'
        expect(page).to_not have_link('Delete')
      end
    end

    scenario 'delete attaches from other user' do
      log_out
      log_in(user)
      visit question_path(question)

      within('.question-attaches') do
        expect(page).to_not have_link('Delete')
      end
    end
  end

  describe 'Attachments' do
    given!(:question_attached) { create(:question, :with_file, user: author) }

    scenario 'delete attaches from author' do
      log_in(author)
      visit question_path(question_attached)

      save_and_open_page
      within('.question-attaches') do
        expect(page).to have_link('Delete')
        click_on 'Delete'
        expect(page).to_not have_link('Delete')
      end
    end

    scenario 'delete attaches from other user' do
      log_in(user)
      visit question_path(question_attached)

      within('.question-attaches') do
        expect(page).to_not have_link('Delete')
      end
    end
  end


end