Rails.application.routes.draw do
  resources :books
  # Routes for the Movie resource:

   # Routes for the Movie resource:

   get("/movies/new", { :controller => "movies", :action => "new" })

  # CREATE
  #post("/insert_movie", { :controller => "movies", :action => "create" })
  post("/movies", { :controller => "movies", :action => "create" })
          
  # READ
  get("/movies", { :controller => "movies", :action => "index" })
  
  #get("/movies/:path_id", { :controller => "movies", :action => "show" })
  get("/movies/:id", { :controller => "movies", :action => "show" })
  
  # UPDATE
  
  #post("/modify_movie/:path_id", { :controller => "movies", :action => "update" })
  #patch("/modify_movie/:path_id", { :controller => "movies", :action => "update" })
  #patch("/movies/:path_id", { :controller => "movies", :action => "update" })
  patch("/movies/:id", { :controller => "movies", :action => "update" })

  # DELETE
  #get("/delete_movie/:path_id", { :controller => "movies", :action => "destroy" })
  #delete("/movies/:path_id", { :controller => "movies", :action => "destroy" })
  delete("/movies/:id", { :controller => "movies", :action => "destroy" })

  #------------------------------

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get("/movies/:id/edit", {:controller => "movies", :action => "edit"})
end
