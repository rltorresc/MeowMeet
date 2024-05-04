class CatRentalRequestsController < ApplicationController
    before_action :logged?
    before_action :set_current_user 
    before_action :check_cat_owner, only: [:approve, :deny]

    def new 
        @rental_request = CatRentalRequest.new
        @rental_request.cat_id = params[:cat_id]
    end

    def create
        @rental_request = CatRentalRequest.new(rental_params)
        @rental_request.user_id = current_user.id
        if  @rental_request.save
            redirect_to cat_url(@rental_request.cat)
        else
            flash[:alert] = @rental_request.errors.full_messages.join(", ")
            redirect_to cat_rental_requests_url(@rental_request.cat)
        end
        
    end

    def approve
        @rental_request = CatRentalRequest.find(params[:id])
        @rental_request.approve!
        redirect_to cat_url(@rental_request.cat)
    end

    def deny
        @rental_request = CatRentalRequest.find(params[:id])
        @rental_request.deny!
        redirect_to cat_url(@rental_request.cat)
    end

    private
    def rental_params
        params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date, :status)
    end
    def check_cat_owner
        @rental_request = CatRentalRequest.find(params[:id])
        unless @rental_request.cat.user_id == current_user.id
            redirect_to cat_url(@rental_request.cat)
        end
    end

end
