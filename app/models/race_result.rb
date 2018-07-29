class RaceResult < ApplicationRecord
  belongs_to :racer
  belongs_to :race
  belongs_to :category
  belongs_to :start_number, optional: true
  has_many :checkpoints
  attr_accessor :racer_start_number

  validate :disallow_duplicates

  def disallow_duplicates
    return if self.id
    errors.add(:racer, 'prijava vec postoji!') if RaceResult.exists?(racer: self.racer, race: self.race)
  end

  def registered_text
    if racer.gender == 2
      'Prijavljen'
    else
      'Prijavljena'
    end
  end

  def ended_text
    if racer.gender == 2
      'Završio'
    else
      'Završila'
    end
  end

  def lap_text(length)
    case length
    when 1
      'krug'
    when 2..4
      'kruga'
    else
      'krugova'
    end
  end

  def pretty_status
    case status
    when 1
      registered_text
    when 2
      'Na startu'
    when 3
      "#{ended_text} #{lap_times.length} #{lap_text(lap_times.length)}"
    when 4
      'DNF'
    when 5
      'DSQ'
    when 6
      'DNS'
    else
      'Nepoznat'
    end
  end

  def finish_time
    return '- -' unless status == 3

    start_time = started_at || race.started_at

    if !lap_times.empty? && start_time
      ended_at = Time.at(lap_times.last.to_i)
      seconds = ended_at - start_time

      Time.at(seconds).utc.strftime('%k:%M:%S')
    else
      '- -'
    end
  end

  def finish_delta
    return '- -' unless status == 3
    reference_race_result = RaceResult.joins(:racer).where(category: category, race: race, status: 3).order(:position).limit(1).first()
    lap_diff = reference_race_result.lap_times.length - lap_times.length
    if !lap_times.empty?
      if lap_diff == 0
        seconds = Time.at(lap_times.last.to_i) - Time.at(reference_race_result.lap_times.last.to_i)
        Time.at(seconds).utc.strftime('+%k:%M:%S')
      else
        "- #{lap_diff} #{lap_text(lap_diff)}"
      end
    else
      '- -'
    end
  end

  def to_csv
    # ['Startni broj', 'Pozicija', 'Ime', 'Prezime', 'Klub',
    # 'Kategorija', 'Velicina majice',
    # 'Godiste', 'Prebivaliste', 'Email', 'Mobitel', 'Vrijeme', 'Razlika',
    # 'Status', 'Personal Best', 'UCI ID']
    [
      start_number&.value, position, racer.first_name, racer.last_name,
      racer.club.try(:name), category.try(:name), racer.shirt_size,
      racer.year_of_birth, racer.town, racer.email, racer.phone_number,
      finish_time, finish_delta, status, racer.personal_best, racer.uci_id
    ]
  end
end
