feature 'Results page' do

  context 'user enters a search query' do

    let!(:result) { FactoryGirl.create(:webpage) }

    scenario 'displays no results if query string empty' do
      visit '/results?q='

      expect(page).not_to have_content(result.title)
    end

    scenario 'displays a result' do
      visit '/results?q=news'

      expect(page).to have_content(result.title)
      expect(page).to have_content(result.description)
      expect(page).to have_content(result.url)
    end

    scenario 'only displays the relevant news result' do
      result_2 = FactoryGirl.create(:webpage, title: 'Fox',
      description: 'Foxes are furry',
      url: 'http://foxes.com')

      visit '/results?q=news'

      expect(page).to have_content(result.title)
      expect(page).to have_content(result.description)
      expect(page).to have_content(result.url)

      expect(page).not_to have_content(result_2.title)
      expect(page).not_to have_content(result_2.description)
      expect(page).not_to have_content(result_2.url)
    end

    xscenario 'returns result when given partial url' do
      visit '/results?q=portsmouth.co.uk'

      expect(page).to have_content(result.url)
    end

    scenario 'can handle multiple word queries' do
      visit '/results?q=portsmouth+news'

      expect(page).to have_content(result.url)
    end

    scenario 'it highlights query string matches' do
      visit '/results?q=portsmouth+news'

      id = result.id

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

    scenario 'it has one result' do
      visit '/results?q=portsmouth+news'

      expect(page).to have_content('1 result')
    end

    scenario 'it two results' do
      FactoryGirl.create(:webpage)

      visit '/results?q=portsmouth+news'

      expect(page).to have_content('2 results')
    end

    scenario 'result has link to url controller' do
      visit '/results?q=portsmouth+news'

      expect(page).to have_link(result.title, href: "/url?w=#{result.id}")
    end
  end

  xcontext 'dealing with pages' do

    let(:results) { [] }

    before do
      15.times do
        results << FactoryGirl.create(:webpage)
      end
    end

    xscenario 'it only shows 10 results on first page' do
      visit '/results?q=portsmouth+news'

      id = 0

      10.times do |i|
        id = results.first.id + i
        expect(page).to have_css("article#result_#{id}")
      end

      expect(page).not_to have_css("article#result_#{id + 1}")
    end

    xscenario 'it displays more results on page two' do
      visit '/results?q=portsmouth+news&start=10'

      id = 0

      5.times do |i|
        id = results.first.id + i + 10
        expect(page).to have_css("article#result_#{id}")
      end

      expect(page).not_to have_css("article#result_#{id + 1}")
    end

    scenario 'it links to the next 10 results' do
      visit '/results?q=portsmouth+news'

      within 'div#pages' do
        click_link '2'
      end

      expect(current_path).to eq '/results'
      expect(page).to have_css("article#result_#{results.last.id}")
      expect(page).not_to have_css("article#result_#{results.first.id}")
    end
  end
end
