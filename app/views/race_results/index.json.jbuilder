# frozen_string_literal: true

json.array! @race_results, partial: 'race_results/race_result', as: :race_result
