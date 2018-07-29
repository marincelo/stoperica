class CheckpointsController < ApplicationController
  # "READERID"=>"1",
  # "STAGEID"=>"1",
  # "STARTNUMBER"=>"25",
  # "TIME"=>"29.07.2018 20:19:14.36753 %2B02:00",
  # "RACEID"=>1
  def create
    race = Race.find(params[:RACEID])
    start_number = StartNumber.find_by(race: race, value: params[:STARTNUMBER])
    start_number = StartNumber.find_by(value: params[:STARTNUMBER]) if start_number.nil?
    race_result = RaceResult.find_by(race: race, start_number: start_number)

    time = DateTime.strptime(params[:TIME], '%d.%m.%Y %H:%M:%S.%L %:z')

    checkpoint = Checkpoint.create!(
      race_result: race_result,
      time: time,
      stage_id: params[:STAGEID],
      reader_id: params[:READERID])

    data = {
      checkpoint: checkpoint,
      racer_name: race_result.racer.full_name,
      start_number: race_result.start_number.value
    }

    render json: data
  end
end
