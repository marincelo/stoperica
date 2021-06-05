# frozen_string_literal: true

class DashboardController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:timesync]

  def index
    @races = if current_user.admin?
               Race.all
             else
               RaceAdmin.where(racer: current_user.racer).collect(&:race)
             end
  end

  def timesync
    ts = {
      jsonrpc: '2.0',
      id: params[:id],
      result: (DateTime.now.to_f * 1000).to_i
    }
    render json: ts
  end
end
