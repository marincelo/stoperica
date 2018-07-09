class RaceResult < ApplicationRecord
  belongs_to :racer
  belongs_to :race
  belongs_to :category
  belongs_to :start_number, optional: true
  attr_accessor :racer_start_number
  accepts_nested_attributes_for :racer

  validate :disallow_duplicates

  def disallow_duplicates
    return if self.id
    errors.add(:racer, 'prijava vec postoji!') if RaceResult.exists?(racer: self.racer, race: self.race)
  end

  def pretty_status
    if status == 1
      'Prijavljen'
    elsif status == 2
      'Na startu'
    elsif status == 3
      'Zavrsio'
    elsif status == 4
      'DNF'
    elsif status == 5
      'DSQ'
    elsif status == 6
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
    reference_race_result = RaceResult.joins(:racer).where(category: category, race: race, status: 3).order('position asc').limit(1).first()
    if !lap_times.empty?
      seconds = Time.at(lap_times.last.to_i) - Time.at(reference_race_result.lap_times.last.to_i)
      Time.at(seconds).utc.strftime('+%k:%M:%S')
    else
      '- -'
    end
  end

  def to_csv
    # ['Startni broj', 'Ime', 'Prezime', 'Klub',
    # 'Kategorija', 'Velicina majice',
    # 'Godiste', 'Prebivaliste', 'Email', 'Mobitel', 'Vrijeme', 'Status'
    # 'Personal Best', 'UCI ID']
    [
      start_number&.value, racer.first_name, racer.last_name,
      racer.club.try(:name), category.try(:name), racer.shirt_size,
      racer.year_of_birth, racer.town, racer.email, racer.phone_number,
      finish_time, status, racer.personal_best, racer.uci_id
    ]
  end
end
