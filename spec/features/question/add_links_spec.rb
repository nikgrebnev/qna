require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c' }
  given(:test_links) { {'My gist' => 'https://gist.github.com/vkurennov/743f9367caa1039874af5a2244e1b44c',
                        'Search engine' => 'https://ya.ru' } }

  describe 'Add links' do
    background do
      log_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'User adds link when asks question', js: true do
      click_on 'Add link'

      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      expect(page).to have_link 'My gist', href: gist_url
    end

    scenario 'User adds links when asks question', js: true do
      test_links.each do |name, link|
        click_on 'Add link'
        within all('.link-block').last do
          fill_in 'Link name', with: name
          fill_in 'Url', with: link
        end
      end

      click_on 'Ask'

      test_links.each do |name, link|
        expect(page).to have_link name, href: link
      end
    end
  end
end