class RecipesController < ApplicationController
  before_action :authorize
  
  def index
    render json: User.find_by(id: session[:user_id]).recipes, include: :user, status: :created
  end

  def create
    recipe = User.find_by(id: session[:user_id]).recipes.create(recipe_params)
    if recipe.valid?
      render json: recipe, include: :user, status: :created
    else
      render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authorize
    return render json: { errors: [] }, status: :unauthorized unless session.include? :user_id
  end

  def recipe_params
    params.permit(:title, :instructions, :minutes_to_complete)
  end
end
