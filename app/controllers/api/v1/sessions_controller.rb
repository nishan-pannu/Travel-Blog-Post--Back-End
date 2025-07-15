class Api::V1::SessionsController < ApplicationController

    # post
    def create
        user = User.find_by(email: params[:email]) || User.find_by(name: params[:email])

        if user && user.authenticate(params[:password])
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
                error: 'Invalid Credentials.'
            }, status: 401
        end
    end

    # delete
    def destroy
        session[:user_id] = nil
        render json: { logged_in: false }
    end

    # get
    def current_user
        if session[:user_id]
            user = User.find_by(session[:user_id])
            render json: {
                user: {
                    id: user.id,
                    name: user.name,
                    email: user.email
                },
                logged_in: true
            }
        else
            render json: { logged_in: false }
        end
    end
end