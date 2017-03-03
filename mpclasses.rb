require 'tty-prompt'

class Recipe

  def initialize()
  end

  # loop function to add a new recipe to the database
  def new_recipe(recipe_name, ingredients, methods)
      new_recipe_file(recipe_name, ingredients, methods)
  end

  # create a new .txt file with recipe details
  def new_recipe_file(recipe_name, ingredients, methods)
    filename = "./recipes/#{recipe_name}.txt"
    target = open(filename, 'w+')
    new_file = File.new(filename, "w+")
    new_file
    target.write("#{recipe_name}")
    target.write("\n")
    target.write("#{ingredients}")
    target.write("\n")
    target.write("#{methods}")
    target.close
  end

  def self.show_recipe(filename)
    puts IO.readlines("#{filename}")[0]
    line = IO.readlines("#{filename}")[1]
    ingredients = eval(line)
    ingredients.each do |ingredients|
      puts "#{ingredients[:item]} x #{ingredients[:qty]}"
    end
    line = IO.readlines("#{filename}")[2]
    methods = eval(line)
    methods.each do |method|
      puts "#{method}"
    end
  end

end

class Planner

@prompt = TTY::Prompt.new

  def initialize()
  end

  def new_planner_file(name, recipes)
    filename = "./mealplans/#{name}.txt"
    target = open(filename, 'w+')
    new_file = File.new(filename, "w+")
    new_file
    target.write("#{recipes}")
    target.close
  end

  # pull ingredients list and qty from recipe
  def get_ingredients_from_recipes(recipe_list)
    puts "yay"
    shopping_list = []
    recipe_list.each do |recipes|
      filename = "./recipes/#{recipes}.txt"
      line = IO.readlines("#{filename}")[1]
      ingredients = eval(line)
      ingredients.each do |ingredients|
        puts "#{ingredients[:item]} x #{ingredients[:qty]}"
      end
    end
  end

  def self.show_plans(selector)
    filename = "./mealplans/#{selector}.txt"
    line = IO.readlines(filename)[0]
    list = eval(line)
    recipe_list = []
    list.each do |meal|
      recipe_list << meal
      puts "#{meal}"
    end
    selection = @prompt.yes?("Print ingredients list?")
      if selection
        Planner.new.get_ingredients_from_recipes(recipe_list)
      else
        main_menu
      end
  end

end
