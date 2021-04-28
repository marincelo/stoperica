# frozen_string_literal: true

module Admin
  class AdminController < ApplicationController
    before_action :authenticate_admin

    private

      def authenticate_admin
        return if current_user&.admin?

        flash[:error] = 'You are not authorized to access these resources!'
        redirect_to root_path
      end
  end
end
