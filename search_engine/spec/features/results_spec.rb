feature 'Results page' do
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
        expect(page).to have_selector('span', text: 'Portsmouth')
      end

      within "span#result_#{id}_url" do
        expect(page).to have_selector('span', text: 'portsmouth')
      end

      within "span#result_#{id}_description" do
        expect(page).to have_selector('span', text: 'Portsmouth')
      end
    end
  end
end
