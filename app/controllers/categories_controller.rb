# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :only_admin
  before_action :set_category, only: %i[show edit update destroy]
  before_action :set_start_time, only: %i[show edit update]

  # GET /categories
  # GET /categories.json
  def index
    @categories = Category.all.order(race_id: :desc).page(params[:page])
  end

  # GET /categories/1
  # GET /categories/1.json
  def show; end

  # GET /categories/new
  def new
    @category = Category.new
  end

  # GET /categories/1/edit
  def edit; end

  # POST /categories
  # POST /categories.json
  def create
    @category = Category.new(category_params)

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
        format.json { render :show, status: :created, location: @category }
      else
        format.html { render :new }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /categories/1
  # PATCH/PUT /categories/1.json
  def update
    respond_to do |format|
      # update start times
      unsafe_params = params[:category]
      if unsafe_params['started_at(1i)'].present?
        start_time = DateTime.new(
          unsafe_params['started_at(1i)'].to_i,
          unsafe_params['started_at(2i)'].to_i,
          unsafe_params['started_at(3i)'].to_i,
          unsafe_params['started_at(4i)'].to_i,
          unsafe_params['started_at(5i)'].to_i,
          unsafe_params['started_at(6i)'].to_i,
        )
        if start_time != @start_time
          @category.race_results.update_all(started_at: start_time)
        end
      end
      ###
      if @category.update(category_params)
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { render :show, status: :ok, location: @category }
      else
        format.html { render :edit }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category.destroy
    respond_to do |format|
      format.html { redirect_to categories_url, notice: 'Category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def set_start_time
      finished_race_result = @category.race_results.where(status: 3).take
      @start_time = (finished_race_result && finished_race_result.started_at) ||
        @category.race.started_at
    end

    def category_params
      params.require(:category).permit(
        :name, :category, :race_id, :track_length, :track_elevation,
        :track_descent
      )
    end
end
