# https://www.googleapis.com/books/v1/volumes?q=#{insertText}&callback=handleResponse

#dependencies
require 'httparty'
require 'colorize'

class Book
  #initialization
  def initialize
    @reading_list = [
      {
        id: 5,
        author: "JK Rowling",
        title: "Harry Potter",
        publisher: "Somebody who own the rights >.>"
      }
    ]
    @username = getName
  end

  def start
    welcome()
  end

  #action methods
  def getName
    print("What is your name? ")
    return gets.chomp
  end

  def welcome
    puts "Welcome to your library, #{@username.green}!"
    show_main_menu()
  end

  #navigation between menus
  def navigation(input)
    if input == "S"
      #Go to new Search
      show_search_menu()
    elsif input == "L"
      #Go to reading_list
      show_reading_list()
    elsif input == "M"
      #Go to reading_list
      show_main_menu()
    elsif input == "E"
      #Go to reading_list
      puts "Thanks for your time!!"
      exit
    else
      puts "Invalid entry! Try something else.".red
      show_main_menu()
    end
  end

  def show_main_menu
    #Main Menu UI
    puts "\n============ Book API (powered by Google) =============="
    puts "(S) = New Search, (L) = Show reading_list, (E) = Exit"
    puts "--------------------------------------------------------\n"
    print "Please choose an action from the menu: "

    #go to submenu method
    option = gets.chomp
    navigation(option.upcase)
  end

  def show_search_menu
    puts "\n\n=================== New Search ========================="
    print "Type in a book's title to search: "
    #go to submenu method
    get_books
  end

  def show_reading_list
    puts "\n\n============ #{@username.green}'s Reading List ==============="
    display_reading_list()
    puts "\n\n================ End of Reading List ==================="

    puts "(M) = Main Menu, (S) = New Search, (E) = Exit"
    puts "--------------------------------------------------------\n"
    print "Please choose an action from the menu: "

    option = gets.chomp
    navigation(option.upcase)
  end

  def get_books
    results = []
    counter = 0
    search = gets.chomp
    puts "Searching! This may take a sec....."
    response = HTTParty.get("https://www.googleapis.com/books/v1/volumes?q=#{search}")
    if response.key?("items")
      items = response.fetch("items").first(5)
      items.each do |res|
        #check if publisher exist (some books are without this key)
        if res.fetch("volumeInfo").key?("publisher")
          publisher = res.fetch("volumeInfo").fetch("publisher")
        else
          publisher = "NO PUBLISHER"
        end
        #check for author
        if res.fetch("volumeInfo").key?("authors")
          author = res.fetch("volumeInfo").fetch("authors")[0]
        else
          author = "NO AUTHOR"
        end
        results.push(
          {
            id: counter,
            author: author,
            title: res.fetch("volumeInfo").fetch("title"),
            publisher: publisher
          }
        )
        counter += 1
      end
      display_search_results(results)


      move_to_reading_list(results)
    elsif !response.key?("items")
      print "Try a new Query! That one returns nothing. ".red
      get_books
    end
    navigation("L")
  end

  #Move record to reading list
  def move_to_reading_list(records)
    selected = gets.chomp
    @reading_list.unshift(records[selected.to_i])
  end

  def display_search_results(records)
    puts "================== Search Results ======================"
    puts "== Type a number 0-4 to add that book to your reading list ======\n"
    records.each do |record|
      puts "______________________________________"
      puts "#{record.fetch(:id)} - #{record.fetch(:title)}, written by #{record.fetch(:author)}"
      puts "--------------------------------------"
      puts "Published by #{record.fetch(:publisher)}"
    end
    puts "\n== Type a number 0-4 to add that book to your reading list ======"
  end

  def display_reading_list
    @reading_list.each do |book|
      puts "______________________________________"
      puts "#{book.fetch(:title)}, written by #{book.fetch(:author)}"
      puts "--------------------------------------"
      puts "Published by #{book.fetch(:publisher)}"
    end
    puts "______________________________________\n"
  end
end

book = Book.new
book.start
