class Api::V1::UsersController < ApplicationController

    # post
    def create
        user = User.new(user_params)

        if user.save
            session[:user_id] = user.id
            render json: {
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email
                },
                logged_in: true
            }
        else
            render json: {
                errors: user.errors.full_messages
            }, status: 422
        end
    end

    # get
    def show
        @user = User.find(params[:id])
        render json: {
            id: @user.id,
            name: @user.name,
            email: @user.email,
            bio: @user.bio,
            profile_picture: @user.profile_picture,
            followers_count: @user.followers_count || 0,
            following_count: @user.following_count || 0
        }

        # if session[:user_id]
        #     user = User.find(session[:user_id])
        #     render json: { user: user }
        # else
        #     render json: { error: 'Not logged in' }, status: 401
        # end
    end

    def posts
        @user = User.find(params[:user_id])
        @posts = @user.posts.order(created_at: :desc)
        render json: @posts.map { |post| post_summary(post) }
    end

    private
    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def post_summary(post)
        {
            id: post.id,
            title: post.title,
            trip_date: post.trip_date,
            intro: post.intro,
            anonymous: post.anonymous,
            stayed_at: post.stayed_at,
            picture_url: post.picture_url,
            like_count: post.like_count,
            comment_count: post.comment_count,
            author: post.anonymous ? "Anonymous" : post.user.name
        }
    end
end