# https://www.googleapis.com/books/v1/volumes?q=#{insertText}&callback=handleResponse

#dependencies
require 'httparty'
require 'colorize'
load 'uitools.rb'
load 'api.rb'

class Book
  include UiTools
  include ApiTools

  #initialization
  def initialize
    @reading_list = [
      {
        id: 5,
        authors: "JK Rowling",
        title: "Harry Potter",
        publisher: "Somebody who own the rights >.>"
      }
    ]
    @username = getName
  end

  #action methods
  def getName
    print("What is your name? ")
    return gets.chomp
  end

  def start
    puts "Welcome to your library, #{@username.green}!"
    show_main_menu()
  end

  #move record to reading list
  def move_to_reading_list(records)
    selected = gets.chomp
    @reading_list.unshift(records[selected.to_i])
    navigation("L")
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

end

book = Book.new
book.start
