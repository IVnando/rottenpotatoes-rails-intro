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
    
    # Self note: one thing to consider for the sessions is to have one session hash
    #            rather than two session arrays
    if params[:sort]
      @sort_by = params[:sort]
      session[:sort] = params[:sort]
    elsif session[:sort]
      @sort_by = session[:sort]
    else
      @sort_by = nil
    end
    
    if params[:ratings]
      @set_ratings = params[:ratings]
      session[:ratings] = params[:ratings]
    elsif params[:commit] == "Refresh" and !params[:ratings]
      @set_ratings = session[:ratings]
    elsif session[:ratings]
      @set_ratings = session[:ratings]
    else
      @set_ratings = Hash.new
    end
    
    # Self note 1: if elsif used to change background color of column header
    # Self note 2: apparently does not matter if title, hilite, and release_date
    #              are in single or double quotes
    if @sort_by == "title"
      @title_header = "hilite"
    elsif @sort_by == "release_date"
      @release_header = "hilite"
    end
    
    @all_ratings = Movie.all_ratings.keys
    
    # Self note 3: params[:something] returns nil or false if undefined
    # Self note 4: process of getting ratings moved into Movie model, but has 
    #              to sort when returned
    if @set_ratings
      @movies = Movie.with_ratings(@set_ratings.keys).order @sort_by
    else
      @movies = Movie.all.order @sort_by
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
