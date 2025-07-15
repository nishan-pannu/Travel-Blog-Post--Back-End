class Api::V1::PostsController < ApplicationController

    # get all posts belonging to the user
    # render posts as json
    def index
        @posts = Post.all.order(created_at: :desc)
        render json: @posts.map { |post| post_summary(post) }
    end

    def search
        query = params[:q]
        @posts = Post.all
    
        if query.present?
            @posts = @posts.where(
                "LOWER(title) LIKE ? OR LOWER(intro) LIKE ? OR LOWER(stayed_at) LIKE ?", 
                "%#{query.downcase}%", "%#{query.downcase}%", "%#{query.downcase}%"
            )
        end
    
        @posts = @posts.order(created_at: :desc).limit(20)
        render json: @posts.map { |post| post_summary(post) }
  end

    # find one post by its ID
    # render post as json
    def show
        post = Post.find_by(id: params[:id])
        if post.nil?
            render json: { error: 'Post not found' }, status: 404
        else
            render json: post_summary(post)
        end
    end

    # create a new post with params and save
    # render as json
    def create
        if current_user
            @post = current_user.posts.build(post_params)

            if @post.save
                render json: post_summary(@post), status: 201
            else
                render json: { error: @post.errors.full_messages.join(', ') }, status: 422
            end
        else
            render json: { error: 'You must be logged in to create a post' }, status: 401
        end
    
    #     new_post = Post.new(post_params)
    #     new_post.user = current_user

    #     if new_post.save
    #         render json: post_summary(new_post), status: 201
    #     else
    #         render json: { errors: new_post.errors.full_messages }, status: 422
    #     end
    end

    def update
        @post = Post.find(params[:id])

        if @post.user == current_user
            if @post.update(post_params)
                render json: post_summary(@post)
            else
                render json: { error: @post.errors.full_messages.join(', ') }, status: 422
            end
        else
            render json: { error: 'Not authorized to update this post' }, status: 403
        end
    rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: 404
    end

    # delete a post
    def destroy
        @post = Post.find(params[:id])
        
        if @post.user == current_user
          @post.destroy
          render json: { message: 'Post deleted successfully' }
        else
          render json: { error: 'Not authorized to delete this post' }, status: 403
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: 404
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
        author: post.anonymous ? "Anonymous" : post.user.name,
        author_id: post.user.id  # Always include author_id for ownership checks, even for anonymous posts
        }
    end

    private
    
    def post_params
        params.require(:post).permit(:title, :trip_date, :intro, :stayed_at, :picture_url, :anonymous)
      end
    
    

end