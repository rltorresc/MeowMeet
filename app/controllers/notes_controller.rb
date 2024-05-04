class NotesController < ApplicationController
    before_action :logged?
    before_action :set_current_user
    def new
        @note = Note.new
        @cat = Cat.find(params[:cat_id])
        @user = User.find(params[:user_id])
    end

    def create
        @note = Note.new(note_params)
        @note.user_id = @current_user.id
        if @note.save
            redirect_to cat_url(@note.cat)
        else
            flash.now[:errors] = @note.errors.full_messages
            render :new
        end
    end

    def destroy
        @note = Note.find(params[:id])
        if @note.user_id == @current_user.id || @current_user.admin?
            @note.destroy
            redirect_to cat_url(@note.cat)
        else
            flash[:alert] = "You can't delete someone else's note!"
            redirect_to cat_url(@note.cat)
        end
    end

    private
    def note_params
        params.require(:note).permit(:cat_id, :user_id, :notes)
    end
end