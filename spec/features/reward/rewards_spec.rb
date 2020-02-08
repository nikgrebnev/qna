require 'rails_helper'

feature 'rewards rights', %q{
} do

  given!(:user) { create(:user) }
  given!(:user1) { create(:user) }
  given!(:question_author) { create(:user) }
  given!(:answer_author) { create(:user) }
  given!(:question) { create(:question, user: question_author) }
  given!(:answer) { create(:answer, question: question, user: answer_author) }
  given!(:reward) { create(:reward, question: question, user: answer_author )}
  given!(:reward1) { create(:reward, :file2, question: question, user: user1 )}
  given!(:reward2) { create(:reward, :file3, question: question, user: nil )}

  scenario 'author of answer can see reward in rewards list', js: true do
    log_in(answer_author)

    visit rewards_path

    expect(page).to have_content question.title
    expect(page).to have_content reward.name
    expect(page).to have_css("img[src*='test1.jpg']")
    expect(page).to_not have_content reward1.name
    expect(page).to_not have_css("img[src*='test2.jpg']")
    expect(page).to_not have_content reward2.name
    expect(page).to_not have_css("img[src*='test3.jpg']")
  end

  scenario 'not author of answer can not see reward in rewards list', js: true do
    log_in(user)

    visit rewards_path

    expect(page).to_not have_content question.title
    expect(page).to_not have_content reward.name
    expect(page).to_not have_css("img[src*='test1.jpg']")
  end

  scenario 'guest can not see reward in rewards list', js: true do
    visit rewards_path

    expect(page).to_not have_content question.title
    expect(page).to_not have_content reward.name
    expect(page).to_not have_css("img[src*='test1.jpg']")
  end
end


