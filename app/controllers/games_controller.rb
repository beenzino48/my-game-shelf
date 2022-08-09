class GamesController < ApplicationController


  def index
    @games = Game.all
    @games = policy_scope(Game).order(created_at: :desc)
  end

  # def recommended
  #   show
  #   # @game.genre = game_genre
  #   # @game.title = game_title
  #   index
  #   total = 0
  #   @games.each do |game|
  #     if game.genre == game_genre && game.title != game_title
  #       break if total == 3

  #       total += 1
  #       link_to game_path(game)
  #     end
  #   end
  # end

  def show
    @games = Game.all
    @game = Game.find(params[:id])

    # if the user is not signed in they cannot add a game to a list
    if user_signed_in?
      # list_game is either present with an id or not yet made
      @list_game = current_user.list_games.find_by(game: @game) || ListGame.new
      @lists = current_user.lists
      # You need this to make a new review in the show page
    end
    @review = Review.new
    ratings = []
    @rating = 0
    @game.reviews.each do |review|
      ratings << review.rating
    end
    unless ratings.empty?
      @rating = ratings.sum / ratings.length
    end
    total = 0
    # can be done in sql
    @three_games = []
      @games.map do |element|
      if @game.genre == element.genre && @game.title != element.title
        break if total == 3
        @three_games << element
        total += 1
      end
    end
    authorize @game
  end

  private

  # def recommended(game, all_games)
  #   total = 0
  #   # can be done in sql
  #     @three_games = @games.map do |element|
  #     if game.genre == element.genre && game.title != element.title
  #       break if total == 3

  #       total += 1
  #     end
  #   end
  #   return @three_games
  #   raise
  # end
end
