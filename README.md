# getting-started-with-scaffolds

There is no target for this project.

Lesson: https://learn.firstdraft.com/lessons/158-getting-started-with-scaffolds

Video: https://share.descript.com/view/nTBab1wF2JO

Grading: https://grades.firstdraft.com/resources/382309a2-3398-4045-86a8-4e9671e5c29c

Learning Outcomes
By the end of this module, you will be able to:

- Use scaffolding to quickly generate the structure of a Rails application.
- Utilize helper methods for named routes and links.
- Create forms using Rails form helpers.
- Integrate Bootstrap for styling and use partials to DRY up your views.

***

### A. Generate Movie table

1. Typing bin/dev initialize the server. The bin/server command is not recognized. 
2. Routes.rb file has not defined routes.
3. Create a Movie table using the command `rails generate draft:resource movie title:string description:text released:boolean`
- I receive an error message "Could not find generator 'draft:resource'. (Rails::Command::Base::CorrectableError):."
- Reason: draft resource was written by R.B., and it doesn't come with rails out of the box. 
- Let's learn to pull out this resource from a gem file. Go to Gemfile and add below ruby '3.0.3':

```
gem "draft_generators", :github => "firstdraft/draft_generators"
```

Type in the terminal: `bundle install`.

(2 min)

4. Re-type the above command. It should work this time. The command is: `rails generate draft:resource movie title:string description:text released:boolean`. Here is the output:

```
getting-started-with-scaffolds main % rails generate draft:resource movie title:string description:text released:boolean
      create  app/controllers/movies_controller.rb
      invoke  active_record
      create    db/migrate/20240624171950_create_movies.rb
      create    app/models/movie.rb
      create  app/views/movies
      create  app/views/movies/index.html.erb
      create  app/views/movies/show.html.erb
       route  RESTful routes
      insert  config/routes.rb
```

5. STOP. Before you proceed, please add the following to the two new and edit forms on the index and show pages:

```
<!-- app/views/movies/index.html.erb -->

<form action="/insert_movie" method="post" data-turbo="false">

```

and 

```
<!-- app/views/movies/show.html.erb -->

<form action="/modify_movie/<%= @the_movie.id %>"  method="post" data-turbo="false">
```

We had to disable turno because it is enabled by default.

### B. Adding a security layer to your form to prevent cross-site request forgery

Running the app with bin/dev resulted in an error message. I 

```
ActiveRecord::PendingMigrationError - Migrations are pending. To resolve this issue, run:
        bin/rails db:migrate RAILS_ENV=development
You have 1 pending migration:
20240624171950_create_movies.rb:
```
(4 min)

Type in the terminal `rails db:migrate` and refreshing the page.

5. Type in the url: https://super-duper-robot-g54j6jv7rg6fvpvq-3000.app.github.dev/movies. You will see a form.

(8 min) Try adding a movie, It was successful on my end. On the video, clicking on the button led to `/insert_movie` route which led to actioncontroller::invalidauthenticitytoken. 

The message shown in the video is:

lib/action_controller/metal/request_forgery_protection.rb

```
#... at /insert_movie
#ActionController:InvalidAuthenticityToken

def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken
end
```

(9 min-10 min)

Look at routes.rb:

```
  post("/insert_movie", { :controller => "movies", :action => "create" })
```

The above code shows that the route calls controller class and calls create method.

6. (18 min) Cross-site request forgery. An attacker can redirect a form on your website to another domain and steal the user's information. The above exception is a form of security to prevent that.  

(21 min) CSRF protection: Add the following script right below the <form action="/..."> tag.

```
<form action="/insert_movie" method="post">
  <input type="hidden" name="authenticity_token" value="<%=form_authenticity_token%>">

  <input type="hidden" name="_method" value="patch"> <!-- this command line is to indicate that the method is a type patch or post-->
```
7. Make it a habit to add the above script for any post or delete forms.

8. helper method example, time_ago_in_words(Time.now)

### C. RESTful routes - industrial grade

1. Change the routes as follows. Note that the routes all begin with the table name. Also, the http verbs are more than just get and post. Here, we introduce patch and delete verbs. Since the root routes are the same "/movie", in the html forms, we must add the helper command to indicate the routes role (i.e., get, post, patch, or delete) as discussed above.

```
  #post("/insert_movie", { :controller => "movies", :action => "create" })
  post("/movies", { :controller => "movies", :action => "create" })
          
  # READ
  get("/movies", { :controller => "movies", :action => "index" })
  
  get("/movies/:path_id", { :controller => "movies", :action => "show" })
  
  # UPDATE
  
  #post("/modify_movie/:path_id", { :controller => "movies", :action => "update" })
  #patch("/modify_movie/:path_id", { :controller => "movies", :action => "update" })
  patch("/movies/:path_id", { :controller => "movies", :action => "update" })

  # DELETE
  #get("/delete_movie/:path_id", { :controller => "movies", :action => "destroy" })
  delete("/movies/:path_id", { :controller => "movies", :action => "destroy" })
```

(12 min)

2. Note the path name convention. The name should only identify the resource we are working with, rather than describing what we are trying to do.

(25 min: URI naming convention)
3. RESTful routes: The widely accepted naming convention for routes is such that we shoud adopt RESTful routing. In particular, we should not use CRUD functions names in URIs. URIs should not be used to indicate that a CRUD function is performed. URIs should be used to uniquely identify resources and not any action upon them.

4. On the other hand, the *HTTP request methods* should be used to indicate which CRUD function is performed.

5. The names of the routes start with slash and then the plural version of the table name.

(27 min) Up to this point, we have been introduced to new HTTP verbs:
- post
- get
- patch (or update)
- delete

6. Also, all routes start with the table names, e.g., /movies/.

7. Even though the routings are the same, note that the HTTP verbs are different and the :action methods are different too. 

8. By changing the routing names to movies, it becomes harder to hack into the web app because all the buttons are triggered by calling the correct methods.

9. (27 min) Accordingly, update the form action links in the index.html.erb page.

10. (28 min) Is it a security issue to use verb in the url? Not really, only the get to post is a security patch. By using route that match the table name, we are following the developer standard.

11.In addition to using the different http verbs (i.e., post, get, patch, and delete) and changing the routes root to the table names, the corresponding form tags must also contain the helper commands, e.g., 

Change this
```
<form action="/insert_movie" method="post" data-turbo="false">
```

To this
```
<form action="/movies" method="post" data-turbo="false">
```

### D. RESTful

1. RESTful convention.
2. "/plural_table_name/"
(28 min)
(40 min)
(42) Summary. We did 3 things:
- Protect form from cross-site request by adding a line of script.

- (31 min) Show details button not working. You must access the table as an array using [0], rather than at(0) within the def show method.

### E. Fix the delete hyperlink

1. Got error when clicking on Delete hyperlink on the show.html.erb page after changing the a href to /movies.

```
<!-- app/views/movies/show.html.erb -->

        <a href="/delete_movie/<%= @the_movie.id %>">
          Delete movie
        </a>
```

to

```
<a href="/movies/<%= @the_movie.id %>"> 
```

2. Need to specify in the form that the http request type is delete. Further modify the above command to:

```
#views/movies/show.html.erb
<a href="/movies/<%= @the_movie.id %>" data-turbo-method="delete"> 
```

### F. Fix update method along the RCAV routine

1. Use the /movies route root in the controller file.
2. In the show.html.erb form, modify:

```
    <form action="/movies/<%= @the_movie.id %>" method="post" data-turbo="false">
        <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">
```

into

```
<form action="/movies/<%= @the_movie.id %>" method="post" data-turbo="false">
    <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">

    <input type="hidden" name="_method" value="patch">
```

### G. Use the convention and change `:path_id` to `:id` in dynamic route

1. change .fetch("path_id") to .fetch("id") `app/controllers/movies_controller.rb`.
2. In the `config/routes.rb` file, change `:path_id` to `:id` as well.

```
#config/routes.rb

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
```

### H. No .at(0)
1. Make sure to replce all of .at(0) to [0] in all methods of the movie_controller.rb file.


### I. Make book table using the rails generate scaffold commmand
(48 min))

1. In the terminal type: 

```
rails generate scaffold book title:string description:text released:boolean.
```

However, I don't see the migrate file being generated in db/migrate.

2. Followed by:

```
rails db:migrate
```
Use instead:


```
rake db:migrate
```


3. Problem: there are no routes. 

4. search routes by typing .../rails/.info.routes.

5. Table exists, as a result, but the routes don't exist!

6. Within routes, only one line is generated: `resources:books`

### J. The Scaffold command

1. Rather than using the draft:resource: command to generate tables automatically by executing the entire RCAV routine, we can use the scaffold method. The scaffold method, however, generates the series of files that conform to the industria conventions that we just went through in the above, where we changes the non-industrial convention naming in the files generated using the darft:resource command.

2. The scaffold command for generating book table is as follows.

```
rails generate scaffold book title:string description:text released:boolean
```

Here is the output:

```
getting-started-with-scaffolds main % rails generate scaffold book title:string description:text released:boolean
      invoke  active_record
      create    db/migrate/20240626025622_create_books.rb
      create    app/models/book.rb
      invoke  resource_route
       route    resources :books
      invoke  scaffold_controller
      create    app/controllers/books_controller.rb
      invoke    erb
      create      app/views/books
      create      app/views/books/index.html.erb
      create      app/views/books/edit.html.erb
      create      app/views/books/show.html.erb
      create      app/views/books/new.html.erb
      create      app/views/books/_form.html.erb
      create      app/views/books/_book.html.erb
      invoke    resource_route
      invoke    jbuilder
      create      app/views/books/index.json.jbuilder
      create      app/views/books/show.json.jbuilder
      create      app/views/books/_book.json.jbuilder
```
3. Next, type `rails db:migrate` to execute the migrate commands.

**Amazing!** Unlike the draft:resource generator, I didn’t have to add a gem to get this to run. It’s just built in to Rails.

4. Visit: https://super-duper-robot-g54j6jv7rg6fvpvq-3000.app.github.dev/rails/db. You will find that the books table has been generated.

5. Look at the config/routes.rb table. You will find that only one line has been generated associated with the book table:

```
resources :books
```
Also, visit: https://super-duper-robot-g54j6jv7rg6fvpvq-3000.app.github.dev/rails/info

Here, you will find all the routes associated with the book table. 

6. Next, review `# app/controller/books_controller.rb`.

```
# app/controller/books_controller.rb

class BooksController < ApplicationController
  before_action :set_book, only: %i[ show edit update destroy ]

  # GET /books or /books.json
  def index
    @books = Book.all
  end

  # GET /books/1 or /books/1.json
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end
# ...
```

Notice how short the codes are. As long as conventional naming is used, rails can figure it out and all boiler plates can be removed.

7. Here’s an example of where scaffold added code that we haven’t seen:

```
# app/controller/books_controller.rb

class BooksController < ApplicationController
  # ...
  # POST /books or /books.json
  def create
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end
  ...
```

### K. Add a new route for movies, "/movies/new"

1. Add the http get in routes.rb:

```
# config/routes.rb

Rails.application.routes.draw do
  resources :books

  # Routes for the Movie resource:

  get("/movies/new", { :controller => "movies", :action => "new" })
```

2. Add the new method within movies_controller.rb.

```
# app/controllers/movies_controller.rb

class MoviesController < ApplicationController
  def new
    render template: "movies/new"
  end
  # ...
```

3. Create the new.html.erb page:

```
<!-- app/views/movies/new.html.erb -->

<h2>
  Add a new movie
</h2>

<form action="/movies" method="post" data-turbo="false">
  <input type="hidden" name="authenticity_token" value="<%= form_authenticity_token %>">

  <!-- ... -->

  <button>
    Create movie
  </button>
</form>
```

### L. Edit the show page


