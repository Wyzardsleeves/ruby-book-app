module UiTools

  #Generates a UI chain as a method while taking in headings and messages
  def ui_generate_chain(unit, message = "")
    num = 40
    newNum = num - message.length/2
    chain = ""
    newNum.times do chain += unit end
    if message.length > 0
      exportMessage = chain + " " + message + " " + chain
    else
      exportMessage = chain + unit + unit + unit + chain
    end
    exportMessage
  end

  def show_main_menu
    #Main Menu UI
    puts "\n" + ui_generate_chain("=", "Book API (powered by Google)")
    puts "(S) = New Search, (L) = Show reading_list, (E) = Exit"
    puts ui_generate_chain("-") + "\n"
    print "Please choose an action from the menu: "

    #go to submenu method
    option = gets.chomp
    navigation(option.upcase)
  end

  def show_search_menu
    puts "\n\n" + ui_generate_chain("=", "New Search")
    print "Type in a book's title to search: "
    #go to submenu method
    get_books
  end

  def show_reading_list
    puts "\n\n" + ui_generate_chain("=", "#{@username.green}'s Reading List")
    display_reading_list()
    puts "\n\n" + ui_generate_chain("=", "End of Reading List")
    puts "(M) = Main Menu, (S) = New Search, (E) = Exit"
    puts ui_generate_chain("-") + "\n"
    print "Please choose an action from the menu: "

    option = gets.chomp
    navigation(option.upcase)
  end

  def display_search_results(records)
    puts ui_generate_chain("=", "Search Results")
    puts ui_generate_chain("=", "Type a number 0-4 to add that book to your reading list") + "\n"
    records.each do |record|
      puts ui_generate_chain("_")
      puts "#{record.dig(:id)} - #{record.dig(:title)}, written by #{record.dig(:authors)}"
      puts ui_generate_chain("-")
      puts "Published by #{record.dig(:publisher)}"
    end
    puts "\n== Type a number 0-4 to add that book to your reading list ======"
  end

  def display_reading_list
    @reading_list.each do |book|
      puts ui_generate_chain("_")
      puts "#{book.dig(:title)}, written by #{book.dig(:authors)}"
      puts ui_generate_chain("-")
      puts "Published by #{book.dig(:publisher)}"
    end
    puts ui_generate_chain("_") +"\n"
  end

end
