class Api::V1::DaysController < ApplicationController

    def current_post
        @current_post ||= Post.find(params[:post_id])
    end

    # get all days belonging to the post
    # render them to the user by json
    def index
        days = current_post.days
        render json: days.map { |day| day_summary(day) }
    end

    # create a new day belonging to the post
    # render them to the user by json
    def create

        if current_post.user == current_user
            new_day = current_post.days.build(day_params)
            if new_day.save
                render json: day_summary(new_day), status: 201
            else
                render json: { errors: new_day.errors.full_messages }, status: 422
            end
        else
            render json: { error: 'Not authorized' }, status: 403
        end

    end

    # delete a day belonging to the post
    # only if the day belongs to the same post (post id)
    def destroy
        day = current_post.days.find(params[:id])
        if current_post.user == current_user
            day.destroy
            render json: { message: 'Day deleted successfully' }
        else
            render json: { error: 'Not authorized' }, status: 403
        end
    end

    private

    def day_params
        params.require(:day).permit(:day_intro, :day_picture_url, :day_description, :post_id)
    end

    def day_summary(day)
        {
            id: day.id,
            number: day.day_number,
            intro: day.day_intro,
            picture: day.day_picture_url,
            description: day.day_description
        }
    end

end