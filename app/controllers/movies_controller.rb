class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    if session[:ratings] || session[:sort]
      params[:ratings] ||= session[:ratings]
      params[:sort] ||= session[:sort]
      session.delete(:ratings)
      session.delete(:sort)
      redirect_to movies_path(params)
    else
    
      @all_ratings = Movie.all_ratings
      @ratings = {}
      @all_ratings.each do |rating|
        @ratings[rating] = "1"
      end

      @ratings = params[:ratings] if params[:ratings]

      @stitle = "normal"
      @sdate = "normal"
      if params[:sort]
        session[:sort] = params[:sort]
        @movies = Movie.order(params[:sort]).find_all_by_rating(@ratings.keys)
        @stitle = 'hilite' if params[:sort] == "title"
        @sdate = 'hilite' if params[:sort] == "release_date"
      else
        @movies = Movie.find_all_by_rating(@ratings.keys)
      end
      session[:ratings] = params[:ratings]
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
