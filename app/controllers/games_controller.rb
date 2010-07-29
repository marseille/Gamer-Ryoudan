class GamesController < ApplicationController
  def find_game
    pp params
    game = Game.find_by_name(params["search_tag"])
    if game
      render :file => "games/index.html"
    else
      flash[:notice] = "Couldn't find your game, add it to the database nao!"
      render :file => "games/new_game.html.erb"
    end
  end
end
