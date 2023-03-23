class RecipeFoodsController < ApplicationController
  before_action :set_recipe_food, only: %i[show edit update destroy]

  # GET /recipe_foods or /recipe_foods.json
  def index
    @recipe_foods = RecipeFood.all
  end

  # GET /recipe_foods/1 or /recipe_foods/1.json
  def show; end

  # GET /recipe_foods/new
  def new
    @foods = Food.all
    @recipe_id = params[:recipe_id]
    @recipe = Recipe.find(params[:recipe_id])

    @recipe_food = RecipeFood.new
  end

  # GET /recipe_foods/1/edit
  def edit
    @recipe = Recipe.find(params[:recipe_id])
    @recipe_food = RecipeFood.find_by(id: params[:id])
  end

  # POST /recipe_foods or /recipe_foods.json
  def create
    @foods = Food.all
    @recipe_id = params[:recipe_id]
    @recipe = Recipe.find(params[:recipe_id])

    @recipe_food = RecipeFood.new(recipe_food_params)

    unless @recipe.recipe_foods.find_by(food_id: recipe_food_params[:food_id]).nil?
      redirect_to recipe_url(@recipe), alert: 'Such ingredient for this recipe already exists!'
      return
    end

    respond_to do |format|
      if @recipe_food.save
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe food was successfully created.' }
        format.json { render :show, status: :created, location: @recipe_food }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @recipe_food.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /recipe_foods/1 or /recipe_foods/1.json
  def update
    @recipe_food = RecipeFood.find(params[:id])
    @recipe_id = params[:recipe_id]
    @recipe = Recipe.find(@recipe_id)

    respond_to do |format|
      if @recipe_food.update(edit_recipe_food_params)
        format.html { redirect_to recipe_url(@recipe), notice: 'Recipe food was successfully updated.' }
        format.json { render :show, status: :ok, location: @recipe_food }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @recipe_food.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /recipe_foods/1 or /recipe_foods/1.json
  def destroy
    @recipe_food.destroy

    respond_to do |format|
      format.html { redirect_to recipe_url, notice: 'Recipe food was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_recipe_food
    @recipe_food = RecipeFood.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def recipe_food_params
    params.require(:recipe_food).permit(:recipe_id, :food_id, :quantity)
  end

  def edit_recipe_food_params
    params.require(:recipe_food).permit(:quantity)
  end
end
