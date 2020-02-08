class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    # Self note 1: if elsif used to change background color of column header
    # Self note 2: apparently does not matter if title, hilite, and release_date
    #              are in single or double quotes
    if params[:sort] == "title"
      @title_header = "hilite"
    elsif params[:sort] == "release_date"
      @release_header = "hilite"
    end
    
    @all_ratings = Movie.all_ratings.keys
    @set_ratings = params[:ratings]
    
    # Self note 3: params[:something] returns nil or false if undefined
    # Self note 4: process of getting ratings moved into Movie model, but has 
    #              to sort when returned
    if params[:ratings]
      @movies = Movie.with_ratings(params[:ratings].keys).order params[:sort]
    else
      @movies = Movie.all.order params[:sort]
      @set_ratings = Hash.new
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
end
