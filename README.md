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
  <input type="hidden" name="_method" value="patch">
```
7. Make it a habit to add the above script for any post or delete forms.

8. helper method example, time_ago_in_words(Time.now)

9. Change the routes as follows:

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

Note the path name convention. The name should only identify the resource we are working with, rather than describing what we are trying to do.

(25 min: URI naming convention)
RESTful routes: The widely accepted naming convention for routes is such that we shoud adopt RESTful routing. In particular, we should not use CRUD functions names in URIs. URIs should not be used to indicate that a CRUD function is performed. URIs should be used to uniquely identify resources and not any action upon them.

On the other hand, the *HTTP request methods* should be used to indicate which CRUD function is performed.

The names of the routes start with slash and then the plural version of the table name.

(27 min) Up to this point, we have been introduced to new HTTP verbs:
- post
- get
- patch (or update)
- delete

Also, all routes start with the table names, e.g., /movies/.

Even though the routings are the same, note that the HTTP verbs are different and the :action methods are different too. 

By changing the routing names to movies, it becomes harder to hack into the web app because all the buttons are triggered by calling the correct methods.

(27 min) Accordingly, update the form action links in the index.html.erb page.

(28 min) Is it a security issue to use verb in the url? Not really, only the get to post is a security patch. By using route that match the table name, we are following the developer standard.

### C. RESTful

1. RESTful convention.
2. "/plural_table_name/"
(28 min)
(40 min)
(42) Summary. We did 3 things:
- Protect form from cross-site request by adding a line of script.

(31 min) Show details button not working. You must access the table as an array using [0], rather than at(0) within the def show method.

Got error when clicking on Delete hyperlink on the show.html.erb page. Need to change the a href to /movies accordingly.

```
<form action="/insert_movie" method="post">
  <input type="hidden" name="authenticity_token" value="<%=form_authenticity_token%>">
  <input type="hidden" name="_method" value="patch">
```

### D. Make book table using the rails generate scaffold commmand
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
