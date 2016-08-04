feature 'Url redirects' do

  context 'user clicks link' do

    let!(:webpage) { webpage = FactoryGirl.create(:webpage) }

    before do
      visit "/url?w=#{webpage.id}"
    end

    scenario 'it adds 1 click to the webpage\'s clicks column' do
      expect(Webpage.get_by_id(webpage.id).clicks).to eq 1
    end

    scenario 'it redirects to the webpage' do
      expect(page.current_url).to eq(webpage.url)
    end
  end

end
