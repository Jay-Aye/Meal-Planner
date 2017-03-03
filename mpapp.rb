require 'tty-prompt'

require_relative 'mpclasses.rb'

@prompt = TTY::Prompt.new

# clear function to clean up user interface of menu
def clear
  system 'clear'
end

# main menu with branches to recipes and meal planner
def main_menu
  clear
  puts "*" * 30
  puts "\tMain Menu"
  puts '*' * 30
  selector = @prompt.select("Select from below") do |menu|
    menu.choice 'Recipes'
    menu.choice 'Meal Planner'
    menu.choice 'Exit'
  end

  case selector
    when 'Recipes'
      recipes_menu
    when 'Meal Planner'
      planner_menu
    when 'Exit'
      abort("Thanks for using the Meal Planner!  Happy eating!")
  end
end

# recipes menu with branches to avilable recipes,
# new recipe and main menu
def recipes_menu
  clear
  puts '*' * 30
  puts "\tRecipes"
  puts '*' * 30
  selector = @prompt.select("Select from below") do |menu|
    menu.choice 'Add new recipe'
    menu.choice 'Show available recipes'
    menu.choice 'Main menu'
  end

  case selector
    when 'Show available recipes'
      availablerecipes_menu
    when 'Add new recipe'
      ask_questions
    when 'Main menu'
      main_menu
  end
end

# planner menu with braches to availble meal plans,
# new meal plan and main menu
def planner_menu
  clear
  puts '*' * 30
  puts "\tMeal Planner"
  puts '*' * 30
  selector = @prompt.select("Select from below") do |menu|
    menu.choice 'Show available meal plans'
    menu.choice 'Create new weekly meal plan'
    menu.choice 'Main menu'
  end

  case selector
    when 'Show available meal plans'
      mealplans_menu
    when 'Create new weekly meal plan'
      new_plan
    when 'Main menu'
      main_menu
  end
end

def new_plan
  filenames = Dir["./recipes/*.txt"]
  recipes_list = []

  filenames.each do |name|
    names = File.basename(name, ".*")
    recipes_list << names
  end

  name = @prompt.ask('Choose a name for your meal plan')
  selector = @prompt.multi_select("Pick your recipes", recipes_list)
  Planner.new.new_planner_file(name, selector)
  main_menu
end

def mealplans_menu
  filenames = Dir["./mealplans/*.txt"]

  plan_list = []
  list = []

  filenames.each do |name|
    names = File.basename(name, ".*")
    plan_list << names
  end

  selector = @prompt.select("See plans", plan_list )
  Planner.show_plans(selector)
end



def availablerecipes_menu
  filenames = Dir["./recipes/*.txt"]

  recipes_list = []

  filenames.each do |name|
    names = File.basename(name, ".*")
    recipes_list << names
  end

  selector = @prompt.select("See recipe", recipes_list )
  filename = "./recipes/#{selector}.txt"
  Recipe.show_recipe(filename)
  selector = @prompt.yes?('Back to main menu?')
    if selector == 'y'
      main_menu
    else
      recipes_menu
    end
end

def new_recipe_menu
  ask_questions
  recipes_menu
end

# get user input for new recipe
def ask_questions
  ingredients = []
  methods = []

  recipe_name = @prompt.ask('What is the name of the recipe?')

  loop do
    ask_ingredient = @prompt.collect do
      key(:item).ask('Ingredient?')
      key(:qty).ask('number of | grams | mills?')
    end
    ingredients << ask_ingredient
  unless @prompt.yes?('Add another ingredient?')
    break
  end
  end

  loop do
    ask_method = @prompt.ask('Add cooking steps')
    methods << ask_method
  unless @prompt.yes?('Add another step?')
    break
  end
  end

  Recipe.new.new_recipe(recipe_name, ingredients, methods)
      recipes_menu
end

main_menu
