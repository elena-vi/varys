feature 'widgets' do
  context 'serving up widgets' do

    scenario 'doesn\'t show a wikipedia page if one not found' do
      visit '/widgets?q=tesla'

      expect(page).not_to have_css("div#widget")
      expect(page).not_to have_link('Wikipedia', href: 'https://en.wikipedia.org/wiki/Tesla_Motors')
    end

    scenario 'does show a wikipedia page if one found' do
      visit '/widgets?q=tesla%20motors'

      within "div#widget" do
        expect(page).to have_content('Tesla Motors')
        expect(page).to have_link('Wikipedia', href: 'https://en.wikipedia.org/wiki/Tesla_Motors')
      end
    end

    scenario 'shows tube service if "tube" entered into search bar' do
      visit '/widgets?q=tube'

      expect(page).to have_css("div#widget")
      expect(page).to have_content('Piccadilly')
    end
  end
end
