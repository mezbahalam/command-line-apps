require 'thor'

RECIPES = [
    {
        title:    "Ratatouille",
        cooking_time: "60 min",
        ingredients: %w(potatoes carrots pappers onions zucchini tomatoes)
    },
    {
        title:    "Mac & Cheese",
        cooking_time: "20 min",
        ingredients: %w( macarroni cheese mustard milk)
    },
    {
        title:    "Caesar Salad",
        cooking_time: "10 min",
        ingredients: %w(chicken lettuce croutons eggs)
    }
]


class Recipes < Thor
  desc "add", "Adds a new recipe."
  option :title, required: true, aliases: "-t"
  option :cooking_time, required: true, aliases: "-c"
  option :description, required: true, aliases: "-d"
  def add # app.rb recipes add --title="" --time="" --description=""
    recipe = {
      title: options[:title],
      cooking_time: options[:cooking_time],
      description: options[:description]
    }

    RECIPES << recipe

    RECIPES.each do |recipe|
      puts recipe[:title]
    end
  end

  desc "list [KEYWORD] [OPTIONS]", "Lists all recipes. If a keyword is given, it filters the list based off it."
  option :format # required: true # default option will remove required option
  option :show_time, type: :boolean, default: true #--show-time --no-show-time

  def list keyword=nil
    recipes = RECIPES
    recipes_to_be_listed = if keyword.nil?
                             recipes
                           else recipes.select { |recipe| recipe[:title].downcase.include? keyword.downcase }
                           end

    recipes_to_be_listed.each do |recipe|
      if options[:format].nil?
        print_default recipe
      else options[:format] == "oneline"
        print_oneline recipe
      end
    end
  end

  private

  def print_default recipe
    puts "______________"
    puts "Recipe: #{recipe[:title]}"
    puts "It takes: #{recipe[:cooking_time]} to cook."
    puts "The ingredients are: #{recipe[:ingredients].join(", ")}"
    puts ""
  end

  def print_oneline recipe
    if options[:show_time]
      time = "(#{recipe[:cooking_time]})"
    else
      time = ""
    end
    puts %Q{ #{recipe[:title]} #{time}}
  end
end

class App < Thor
  desc 'hello WORD', "Prints 'Hello WORD' to the screen"
  def hello word
    puts "Hello, #{word}"
  end

  desc "recipes", "Manages recipes"
  subcommand "recipes", Recipes #app.rb recipes add


end

App.start ARGV