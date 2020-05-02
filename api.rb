module ApiTools
    def get_books
      results = []
      counter = 0
      search = gets.chomp
      puts "Searching! This may take a sec....."
      response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{search}")
      items = response.dig("items").first(5)
      items.each do |res|
        #check if publisher exist (some books are without this key)
        if res.dig("volumeInfo").key?("publisher")
          publisher = res.dig("volumeInfo", "publisher")
        else
          publisher = "NO PUBLISHER"
        end
        #check for authors
        if res.dig("volumeInfo").key?("authors")
          authors = ""
          res.dig("volumeInfo", "authors").each_with_index{|name, index| if index == 0 then authors += name else authors += ", #{name}" end}
        else
          authors = "NO AUTHORS"
        end
        results.push(
          {
            id: counter,
            authors: authors,
            title: res.dig("volumeInfo", "title"),
            publisher: publisher
          }
        )
        counter += 1
      end
      display_search_results(results)
      move_to_reading_list(results)
      rescue
      puts "Try a new Query! That one returns nothing. ".red
      print "New Query: "
      get_books
    end
end
