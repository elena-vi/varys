feature 'Home page' do

  before do
    visit '/'
  end

  it { expect(page.title).to eq('Varys') }

  it 'has a search box' do
    expect(page).to have_selector("input[id='search_query']")
  end

  it 'has a search button' do
    expect(page).to have_selector("input[type='submit'][value='search']")
  end
end
