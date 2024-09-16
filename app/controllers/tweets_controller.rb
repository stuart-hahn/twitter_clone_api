class TweetsController < ApplicationController
  before_action :set_user, only: [ :index, :create ]

  # GET /tweets or /users/:user_id/tweets
  def index
    if @user
      @tweets = @user.tweets
    else
      @tweets = Tweet.all
    end

    render json: @tweets
  end

  # GET /tweets/:id
  def show
    @tweet = Tweet.find(params[:id])

    render json: @tweet
  end

  # POST /tweets or /users/:user_id/tweets
  def create
    @tweet = @user ? @user.tweets.build(tweet_params) : Tweet.new(tweet_params)

    if @tweet.save
      render json: @tweet, status: :created, location: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tweets/:id
  def update
    @tweet = Tweet.find(params[:id])

    if @tweet.update(tweet_params)
      render json: @tweet
    else
      render json: @tweet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /tweets/:id
  def destroy
    @tweet = Tweet.find(params[:id])
    @tweet.destroy

    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  # Only allow a trusted parameter "white list" through.
  def tweet_params
    params.require(:tweet).permit(:content, :user_id)
  end
end
