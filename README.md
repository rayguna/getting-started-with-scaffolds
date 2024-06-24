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
