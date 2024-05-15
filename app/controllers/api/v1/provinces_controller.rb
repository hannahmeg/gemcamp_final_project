module Api
  module V1
    class ProvincesController < ApplicationController
      def cities
        province = Address::Province.find(params[:province_id])
        cities = province.cities
        render json: cities
      end
    end
  end
end

