class Api::V1::RatingsController < ApplicationController

    def current_post
        @current_post ||= Post.find(params[:post_id])
    end

    # get the rating belonging to the post
    # render it to json
    def show
        rating = current_post.rating
        if rating.nil?
            render json: { error: 'Rating not found' }, status: 404
        else
            render json: rating_summary(rating)
        end
    end

    # create a new rating belonging to the post
    # render them to the user by json
    def create
        if current_post.user == current_user
          new_rating = current_post.build_rating(rating_params.merge(user_id: current_user.id))
          if new_rating.save
            render json: rating_summary(new_rating), status: 201
          else
            render json: { error: new_rating.errors.full_messages }, status: 422
          end
        else
          render json: { error: 'Not authorized' }, status: 403
        end
      end

      def update
        rating = current_post.rating

        if current_post.user == current_user
            if rating.update(rating_params)
                render json: rating_summary(rating)
            else
                render json: { error: rating.errors.full_messages }, status: 422
            end
        else
            render json: { error: 'Not authorized' }, status: 403
        end
    end

    # destroy a rating belonging to the post
    # only if the rating belongs to the same post
    def destroy
        rating = current_post.ratings.find(params[:id])
        if current_post.user == current_user
            rating.destroy
            render json: { message: 'Rating deleted successfully' }
        else
            render json: { error: 'Not authorized' }, status: 403
        end
    end

    private

    def rating_params
        params.require(:rating).permit(:overall, :food, :safety, :cost, :transportation, :climate, :visit_again, :summary, :tags, :post_id)
    end

    def rating_summary(rating)
        {
            id: rating.id,
            overall: rating.overall,
            food: rating.food,
            safety: rating.safety,
            cost: rating.cost,
            transportation: rating.transportation,
            climate: rating.climate,
            visit_again: rating.visit_again ? "Yes" : "No",
            summary: rating.summary,
            tags: rating.tags
        }
    end

end