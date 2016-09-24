# :mag: varys
A search engine built in Ruby and Sinatra, using a PostgreSQL database.

## Features
### 4-Tier Ranking
* Search results are initially ranked based on how often all or part of the query string occurs within the title and description fields of the database rows.
* Results where the URL is the homepage of the website are then given a higher ranking, as it is thought that the user will find what they're looking for somewhere on that website.
* Webpages that have many nodes in their URL are ranked lower, as they are deemed more specific - not necessarily towards the query.
* Lastly, results are ordered by their popularity. Every click on a result is recorded and this helps to push more reputable webpages up the rankings.

### Widgets
Helpful widgets have been implemented to provide the user with a more convenient experience. If a user enters weather then they're given their local weather alongside the results. Wikipedia and Tfl service updates have also been implemented at this time. The code is modular, so it is easy to add further widgets.

## Pipeline
- Faster/more efficient querying of the database.
- Include results for ranking that only partially match the query string.
- Further abstraction of responsibilities, especially within the Webpage model.
- Only show 10 pages at a time.
- Convert backend to search API and create a frontend application with ReactJS to render search results and widgets.
