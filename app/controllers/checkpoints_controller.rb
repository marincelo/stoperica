class CheckpointsController < ApplicationController
  # "TAGID"=>" 00 00 00 00 00 00 00 00 00 01 65 19",
  # "RSSI"=>"60",
  # "TIME"=>"14.08.2017 13:07:14.36753 %2B02:00",
  # "RACEID"=>5
  def create
    race = Race.find(params[:RACEID])
    start_number = StartNumber.find_by(race: race, tag_id: params[:TAGID].strip)
    start_number = StartNumber.find_by(tag_id: params[:TAGID].strip) if start_number.nil?

    race_result = RaceResult.find_by(race: race, start_number: start_number)
    millis = DateTime.strptime(params[:TIME], '%d.%m.%Y %H:%M:%S.%L %:z').to_f

    race_result.lap_times << millis
    race_result.status = 3
    race_result.save!

    data = {
      finish_time: race_result.finish_time,
      racer_name: race_result.racer.full_name,
      start_number: race_result.start_number.value,
      tag_id: race_result.start_number.tag_id
    }

    render json: data
  end
end
