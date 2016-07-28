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
end
