require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:gist_link) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:test_link) { 'https://ya.ru' }
  given(:test_links) { {'Github' => 'https://github.com',
                        'Search engine' => 'https://ya.ru' } }

  describe 'Add links' do
    background do
      log_in(user)
      visit question_path(question)

      fill_in 'Answer', with: 'Test answer'
    end

    scenario 'User adds link when asks answer', js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'Yandex'
      fill_in 'Url', with: test_link

      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'Test answer'
        expect(page).to have_link 'Yandex', href: test_link
      end
    end

    scenario 'User adds link with Gist', js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'Test gist'
      fill_in 'Url', with: gist_link

      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_link 'Test gist', href: gist_link
        expect(page).to have_content "puts 'Hello, world!\""
      end
    end

    scenario 'User adds links when asks answer', js: true do
      test_links.each do |name, link|
        click_on 'Add link'
        within all('.link-block').last do
          fill_in 'Link name', with: name
          fill_in 'Url', with: link
        end
      end

      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        test_links.each do |name, link|
          expect(page).to have_link name, href: link
        end
      end
    end
  end
end