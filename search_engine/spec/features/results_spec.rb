feature 'Results page' do
  scenario 'displays no results if query string empty' do
    result = FactoryGirl.create(:webpage)

    visit '/results?q='

    expect(page).not_to have_content(result.title)
  end

  scenario 'displays a result' do
    result = FactoryGirl.create(:webpage)

    visit '/results?q=news'

    expect(page).to have_content(result.title)
    expect(page).to have_content(result.description)
    expect(page).to have_content(result.url)
  end

  scenario 'only displays the relevant news result' do
    result_1 = FactoryGirl.create(:webpage)
    result_2 = FactoryGirl.create(:webpage, title: 'Fox',
                                            description: 'Foxes are furry',
                                            url: 'http://foxes.com')

    visit '/results?q=news'

    expect(page).to have_content(result_1.title)
    expect(page).to have_content(result_1.description)
    expect(page).to have_content(result_1.url)

    expect(page).not_to have_content(result_2.title)
    expect(page).not_to have_content(result_2.description)
    expect(page).not_to have_content(result_2.url)
  end

  scenario 'returns result when given partial url' do
    result_1 = FactoryGirl.create(:webpage)

    visit '/results?q=portsmouth.co.uk'

    expect(page).to have_content(result_1.url)
  end

  scenario 'can handle multiple word queries' do
    result_1 = FactoryGirl.create(:webpage)

    visit '/results?q=portsmouth+news'

    expect(page).to have_content(result_1.url)
  end

  scenario 'it highlights query string matches' do
    result_1 = FactoryGirl.create(:webpage)

    visit '/results?q=portsmouth+news'

    id = result_1.id

    within "article#result_#{id}" do
      within "span#result_#{id}_title" do
        expect(page).to have_selector('span', text: 'Portsmouth', exact: true)
      end

      within "span#result_#{id}_url" do
        expect(page).to have_selector('span', text: 'portsmouth', exact: true)
      end

      within "span#result_#{id}_description" do
        expect(page).to have_selector('span', text: 'Portsmouth', exact: true)
      end
    end
  end

  context 'dealing with pages' do
    before do
      results = []

      15.times do
        results << FactoryGirl.create(:webpage)
      end
    end

    scenario 'it only shows 10 results on first page' do
      visit '/results?q=portsmouth+news'

      10.times do |i|
        id = i + 8
        expect(page).to have_css("article#result_#{id}")
      end

      expect(page).not_to have_css("article#result_18")
    end

    scenario 'it displays more results on page two' do
      visit '/results?q=portsmouth+news&start=10'

      5.times do |i|
        id = i + 33
        expect(page).to have_css("article#result_#{id}")
      end

      expect(page).not_to have_css("article#result_32")
    end

    scenario 'it links to the next 10 results' do
      visit '/results?q=portsmouth+news'

      puts page.html

      within 'div#pages' do
        click_link '2'
      end

      expect(current_path).to eq '/results?q=portsmouth+news&start=10'
    end
  end
end
