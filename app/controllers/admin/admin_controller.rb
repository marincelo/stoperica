# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :authenticate_admin

    private

      def authenticate_admin
        unless current_user&.admin? # rubocop:disable Style/GuardClause
          flash[:error] = 'You are not authorized to access these resources!'
          redirect_to root_path
        end
      end
  end
end
