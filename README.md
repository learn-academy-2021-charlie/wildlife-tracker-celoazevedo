# README

## The API Stories
    - The Forest Service is considering a proposal to place in conservancy a forest of virgin Douglas fir just outside of Portland, Oregon. Before they give the go-ahead, they need to do an environmental impact study. They've asked you to build an API the rangers can use to report wildlife sightings.

# getting started
- create the app
    - $ rails new wildlife_tracker -d postgresql -T
- cd into app folder
- create db
    - $ rails db:create
- now we can add the git command
    - $ git remote add origin https://github.com/learn-academy-2021-charlie/wildlife-tracker-celoazevedo.git
- checkout main
    - $ git checkout -b main
- push to main
    - $ git push origin main
- For this app we will need the testing framework  -->> remember to do this before we create our model!
    - $ bundle add rspec-rails
    - $ rails generate respec:install
- Now we can start to create our models and controllers!!

## Start the user stories!

- Story: As a developer I can create an animal model in the database. An animal has the following information: common name, latin name, kingdom (mammal, insect, etc.).
    - by using the g resource command, Rails will create just about everything that we need to start working with animals as a data source. 
            - it setted up the migration file
            - it setted up the model
            - it created a controller
            - it also created a view folder (we will not be using it in this app since we are only working on the backend)
            - it also setted up the resourced routes for the Animals. Rails generated all of the CRUD functionalities for the animals.
                - now we do not need to build our routes for every controller action
            - Now we need to tell our controller what we want to do for each request!
    - $ rails g resource Animal common_name:string latin_name:string kingdom:string
    - $ db:migrate
- Story: As the consumer of the API I can see all the animals in the database.
Hint: Make a few animals using Rails Console
    - first we created a few animal instances to feed our database
        - $ rails c
        - $ Animal.create common_name: 'Butterfly', latin_name: 'Rhopalocera', kingdom: 'Animalia'
    - Now we need to define the index method inside of our animal controller
        ```
        def index
            animal = Animal.all
            render json: animal
        end
        ```
    - !! To confirm if we are indeed getting the data back!! We will use Postman!!! -- this tool will create requests and responses and we can see the responses to make sure our app is working!
        - web.postman.co
        - under workspace 
        - in the headers tab
            - KEY -> Content-Type
            - Value -> application/json
        - this is a GET request to 
            http://localhost:3000/animals

- Story: As the consumer of the API I can update an animal in the database.
    - need to create an update method inside the controller
    ```
    def update
        animal = Animal.find(params[:id])
        animal.update(animal_params)
        if animal.valid?
            render json: animal
        else
            render json: animal.errors
        end
    end
    ```
    - to check for the route on postman (!!! ASK SARA!)
        - use the $ rails routes command to check the routes that were set up already! 
        - /animals/:id
    - this is a PATCH request
        - make sure to pass in your info in the body as json
        - http://localhost:3000/animals/5
    - ! Now this thing is working!!!!

- Story: As the consumer of the API I can destroy an animal in the database.
    - define the destroy method
    def destroy
        animal = Animal.find(params[:id])
        if animal.destroy
            render json: animal
        else
            render json: animal.errors
        end
    end
    - and the private settup in our controller for another leayer of security to our db
        private
        def animal_params
            params.require(:animal).permit(:common_name, :latin_name, :kingdom)
        end
    - Now lets check a DELETE request on POstMan
        - it is getting a message on the termial of authenticity error!
            need to set up an authenticaiton token 
                - inside the application controller
                     ```
                     skip_before_action :verify_authenticity_token
                     ```
    - this is a DELETE request
        - http://localhost:3000/animals/4
        - it is working!!!
- Story: As the consumer of the API I can create a new animal in the database.
    - define create method inside controller
    ```
     def create
        animal = Animal.create(animal_params)
        if aimal.valid?
            render json: animal
        else 
            render json: animal.errors
        end
    end
    ```
    - now we can check the endpoint using PostMan
        - remember that is is a POST request
        - pass in your data using json format in the body (postman)
        - http://localhost:3000/animals
    - Create method is working !!!
    
- Story: As the consumer of the API I can create a sighting of an animal with date (use the datetime datatype), a latitude, and a longitude.
Hint: An animal has_many sightings. (rails g resource Sighting animal_id:integer ...)
    - create a model for Sighting
    - ! should we use decimal data type for latitude and longitude? can we use precision?
    - ex: :decimal, { precision: 10, scale: 6 }

    - $ rails g resource Sighting date:datetime latitude:decimal longitude:decimal animal_id:integer

    - $ rails db:migrate
        - NOW we have a schema file with both tables:
            - animal
            - sighting
    - Now we can make the Active Records Association
        - inside the Animal model folder
            ```
            class Animal < ApplicationRecord
                has_many :sightings
            end
            ```
        - inside the Sightings model folder
            ```
            class Sighting < ApplicationRecord
                belongs_to :animal
            end
            ```
    - ! NOW our app is expecting this relationship!
    - Lets create the sightings for the Butterfly
        - $ rails c
        - $ myButterfly = Animal.find(3)
        - $ myButterfly.sightings.create date: DateTime.now, latitude: 31.1, longitude: -117.4
            - nice! now we can create sightings for our animals like that.... form the rails console. It is working. How do we test it in postman?
            
- Story: As the consumer of the API I can update an animal sighting in the database.
    - 
- Story: As the consumer of the API I can destroy an animal sighting in the database.
- Story: As the consumer of the API, when I view a specific animal, I can also see a list sightings of that animal.
Hint: Checkout the Ruby on Rails API docs on how to include associations.
- Story: As the consumer of the API, I can run a report to list all sightings during a given time period.
Hint: Your controller can look like this:
```
class SightingsController < ApplicationController
  def index
    sightings = Sighting.where(date: params[:start_date]..params[:end_date])
    render json: sightings
  end
end
```
Remember to add the start_date and end_date to what is permitted in your strong parameters method.

## Stretch Challenges
Note: All of these stories should include the proper RSpec tests. Validations will require specs in spec/models, and the controller method will require specs in spec/requests.

- Story: As the consumer of the API, I want to see validation errors if a sighting doesn't include: latitude, longitude, or a date.
- Story: As the consumer of the API, I want to see validation errors if an animal doesn't include a common name, or a latin name.
- Story: As the consumer of the API, I want to see a validation error if the animals latin name matches exactly the common name.
- Story: As the consumer of the API, I want to see a validation error if the animals latin name or common name are not unique.
- Story: As the consumer, I want to see a status code of 422 when a post request can not be completed because of validation errors.
Check out Handling Errors in an API Application the Rails Way

## Super Stretch Challenge
- Story: As the consumer of the API, I can submit sighting data along with a new animal in a single API call.
Hint: Look into accepts_nested_attributes_for
