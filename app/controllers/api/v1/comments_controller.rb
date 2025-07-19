class Api::V1::CommentsController < ApplicationController
    # before_action :authenticate_user!, except: [:index]
    before_action :set_post
    before_action :set_comment, only: [:destroy]

    def index
        @comments = @post.comments.includes(:user).ordered
        render json: @comments.map { |comment|
            {
                id: comment.id,
                content: comment.content,
                created_at: comment.created_at,
                user: {
                    id: comment.user_id,
                    username: comment.user.name || 'Anonymous'
                }
            }
        }
    end

    def create
        if session[:user_id].nil?
            render json: { error: 'Please log in to comment' }, status: :unauthorized
            return
          end
        
        @comment = @post.comments.build(comment_params)
        @comment.user_id = session[:user_id]

        if @comment.save
            render json: {
                id: @comment.id,
                content: @comment.content,
                created_at: @comment.created_at,
                user: {
                    id: @comment.user.id,
                    username: @comment.user.name || 'Anonymous'
                }
            }, status: :created
            else
                render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
            end
        end

        def destroy
            if session[:user_id] && @comment.user_id == session[:user_id]
              @comment.destroy
              head :no_content
            else
              render json: { error: 'Unauthorized' }, status: :unauthorized
            end
          end
        
        private
        
        def set_post
            @post = Post.find(params[:post_id])
        end
    
        def set_comment
            @comment = @post.comments.find(params[:id])
        end
    
        def comment_params
            params.require(:comment).permit(:content)
        end
    end