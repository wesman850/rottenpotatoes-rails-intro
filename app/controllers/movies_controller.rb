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
    # @movies = Movie.all
    @all_ratings = Movie.allRatings
    #Part 1 Code
    # if params[:ratings]
    #   @movies = Movie.where(:rating => params[:ratings].keys)
    # else
    #   @movies = Movie.all
    # end
    session[:ratings] || session[:ratings] = Hash[@all_ratings.map {|rating| [rating, rating]}]
    session[:sort] || session[:sort] = 'id'
    
    if params[:ratings]
      temp = params[:ratings]
      session[:ratings] = temp
    end
    
    if params[:sort]
      temp = params[:sort]
      session[:sort] = temp
    end
    
    heuristic1 = !params[:ratings]
    heuristic2 = !params[:sort]
   
    #Check Heuristic
    if(heuristic1 || heuristic2)
      #No matches
      flash.keep
      #Redirection
      redirect_to :ratings => session[:ratings], :sort => session[:sort]
    end
    
     @movies = Movie.where(:rating => session[:ratings].keys).order(session[:sort])
    
      
   
    #PART 2
    # :rate => params[:ratings].keys
    # if params[:ratings].present?
    #   @ratings_picked = params[:ratings]
    # else
    #   @ratings_picked = []
    # end
    # Checking to see if movie titles are in order
    
    #PART 1
    if params[:sortTitleFunction] == "TitleSort"
      @movies = @movies.order(:title)
    end
    #Checking to see if movie release dates are in order
    if params[:sortReleaseFunction] == "ReleaseSort"
      @movies = @movies.order(:release_date)
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
