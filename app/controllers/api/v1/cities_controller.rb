module Api
  module V1
    class CitiesController < ApplicationController
      def barangays
        city = Address::City.find(params[:city_id])
        barangays = city.barangays
        render json: barangays
      end
    end
  end
end

