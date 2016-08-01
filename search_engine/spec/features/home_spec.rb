feature 'Home page' do

  before do
    visit '/'
  end

  it { expect(page.title).to eq('Varys') }

  it 'has a search box' do
    expect(page).to have_selector("input[id='search_query']")
  end

  it 'has a search button' do
    expect(page).to have_selector("input[type='submit'][name='search']")
  end

  it 'takes you to results page when you click search' do
    fill_in :search_query, with: 'news'
    click_button :search
    expect(current_path).to eq('/results')
    expect(page).to have_selector('input[value="news"]')
  end
end
