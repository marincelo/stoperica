class RacesController < ApplicationController
  before_action :set_race, only: [:show, :embed, :edit, :update, :destroy, :assign_positions]
  before_action :sort_results, only: [:show, :embed]
  before_action :check_race_result, only: [:show]
  before_action :only_admin, only: [:new, :edit, :destroy, :assign_positions]

  # GET /races
  # GET /races.json
  def index
    @races = Race.all.order(date: :desc)
  end

  # GET /races/1
  # GET /races/1.json
  def show
    @is_admin = user_signed_in? && current_user.admin?
    if @is_admin && @race.pool
      @start_numbers = @race.pool.start_numbers.sort_by{|sn| [sn.value.to_i]}.collect{|sn| [sn.value, sn.value]}
    else
      @start_numbers = []
    end
    respond_to do |format|
      format.html { render :show }
      format.json do
        render json: @race, include: json_includes
      end
      format.csv { send_data @race.to_csv }
    end
  end

  def embed; end

  def get_live
    race = Race.where.not(started_at: nil).where(ended_at: nil).first
    render json: race
  end

  # GET /races/new
  def new
    @race = Race.new
  end

  # GET /races/1/edit
  def edit; end

  # POST /races
  # POST /races.json
  def create
    @race = Race.new(race_params)

    respond_to do |format|
      if @race.save
        format.html { redirect_to @race, notice: 'Race was successfully created.' }
        format.json { render :show, status: :created, location: @race }
      else
        format.html { render :new }
        format.json { render json: @race.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /races/1
  # PATCH/PUT /races/1.json
  def update
    @race.update!(race_params)
    if params[:started_at].present? && @race.started_at.nil?
      @race.started_at = Time.at(params[:started_at].to_i / 1000)
    end
    @race.ended_at = Time.at(params[:ended_at].to_i / 1000) if params[:ended_at].present?
    @race.save!

    if params[:ended_at].present? && @race.ended_at
      @race.assign_positions
      @race.assign_points if @race.league&.xczld?
    end

    if params[:started_at].present? && params[:categories].present?
      start_time = Time.at(params[:started_at].to_i / 1000)
      @race.race_results.where(category_id: params[:categories]).update(started_at: start_time)
      @race.update!(ended_at: nil)
    end

    respond_to do |format|
      format.html { redirect_to @race, notice: 'Race was successfully updated.' }
      format.json { render :show, status: :ok, location: @race }
    end
  end

  # DELETE /races/1
  # DELETE /races/1.json
  def destroy
    @race.destroy
    respond_to do |format|
      format.html { redirect_to races_url, notice: 'Race was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign_positions
    @race.assign_positions if @race.league&.xczld?
    @race.assign_points
    redirect_to @race
  end

  private

  def set_race
    if action_name == 'show'
      @race = Race
        .eager_load(:league, :categories, race_results: [{ racer: :club }, :start_number])
        .select(Race.attribute_names - ['email_body'])
        .find(params[:id])
    else
      @race = Race.find(params[:id])
    end
  end

  def race_params
    params.require(:race).permit(
      :name, :date, :laps, :easy_laps, :description_url, :send_email,
      :registration_threshold, :categories, :email_body, :lock_race_results,
      :uci_display, :race_type, :pool_id, :league_id
    )
  end

  def check_race_result
    # TODO rijesi ovo groblje
    has_race_result = current_user&.racer&.races&.include?(@race)
    @racer_has_race_result = has_race_result
    if has_race_result
      @race_result = current_user.racer.race_results.where(race: @race).first
    end
  end

  def sort_results
    if @race.penjanje?
      fallback = @race.race_results.count
      @sorted_results = @race.race_results.where.not(position: nil).order(:position)
      rest = @race.race_results.where(position: nil)
      rest = rest.sort_by do |r|
        [
          r.climbs.dig('final', 'position') || fallback,
          r.climbs.dig('q', 'position') || fallback,
          r.climbs.dig('q2', 'position') || fallback,
          r.climbs.dig('q1', 'position') || fallback
        ]
      end
      @sorted_results += rest
      @race.sorted_results = @sorted_results
    else
      @sorted_results = {}
      @race.categories.each do |category|
        category_results = @race.race_results.where(category: category)
        if @race.started_at.nil?
          @sorted_results[category] = category_results.order(created_at: :desc)
        else
          @sorted_results[category] = category_results.where.not(position: nil).order(:position) +
            category_results.where(position: nil).order(status: :desc)
        end
      end
    end
  end

  def json_includes
    [
      { sorted_results: race_result_includes },
      { race_results: race_result_includes },
      categories: { methods: [:started?, :started_at] },
    ]
  end

  def race_result_includes
    personal_fields = [:email, :phone_number, :year_of_birth, :gender, :address,
      :zip_code, :town, :day_of_birth, :month_of_birth, :shirt_size]
    personal_fields = [] if current_user&.admin?
    {
      include: [
        { racer: { include: :club, except: personal_fields } },
        :category,
        :start_number
      ],
      methods: [:finish_time]
    }
  end
end
