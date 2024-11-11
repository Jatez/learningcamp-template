class RecipesController < ApplicationController
  def index
    @recipes = Recipe.all
  end

  def new
    @recipe = Recipe.new
  end

  def create
    service = RecipeGeneratorService.new(params[:recipe][:ingredients], current_user.id)
    generated_recipe = service.call

    @recipe = Recipe.new(
      name: generated_recipe['name'],
      description: generated_recipe['content'],
      ingredients: params[:recipe][:ingredients],
      user: current_user
    )

    if @recipe.save
      redirect_to @recipe, notice: 'Recipe was successfully created using AI.'
    else
      render :new, alert: 'There was an error creating the recipe.'
    end
  end

  def show
    @recipe = Recipe.find(params[:id])
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipes_path, notice: 'Recipe was successfully deleted.'
  end

  private

  def recipe_params
    params.require(:recipe).permit(:name, :description, :ingredients)
  end
end