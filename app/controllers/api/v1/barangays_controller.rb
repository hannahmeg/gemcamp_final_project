module Api
  module V1
    class BarangaysController < ApplicationController
      def index
        city = Address::City.find(params[:city_id])
        barangays = city.barangays
        render json: barangays
      end
    end
  end
end

