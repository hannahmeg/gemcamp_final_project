module Api
  module V1
    class RegionsController < ApplicationController
      def provinces
        region = Address::Region.find(params[:region_id])
        provinces = region.provinces
        render json: provinces
      end
    end
  end
end

