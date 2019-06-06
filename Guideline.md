# Guideline for Online Store Application

- ### Create a Application

    ```
    rails new RubyonRails
    ```

- ### Product Table

    ```
    Name - String
    Description - Text
    Image - String
    Price - Numeric
    ```

- ### Generate Product Scaffold

    ```
    rails g scaffold Product name description:text image price:numeric

    rails db:migrate
    ```

- ### Change the Size of Description in Product _form.html.erb

    ``` html
    <%= form.text_area :description, cols: 18, rows: 20 %>
    ```

- ### Find Image and Put it in assets / images

- ### Maleficent ( 2014 )

    ```
    Description - As a beautiful young woman of pure heart, Maleficent (Angelina Jolie) has an idyllic life in a forest kingdom. When an invading army threatens the land, Maleficent rises up to become its fiercest protector. However, a terrible betrayal hardens her heart and twists her into a creature bent on revenge. She engages in an epic battle with the invading king's successor, then curses his newborn daughter, Aurora -- realizing only later that the child holds the key to peace in the kingdom ...

    Price - 19.99
    ```

- ### Cinderella ( 2015 )

    ```
    Description - After her father unexpectedly dies, young Ella (Lily James) finds herself at the mercy of her cruel stepmother (Cate Blanchett) and stepsisters, who reduce her to scullery maid. Despite her circumstances, she refuses to despair. An invitation to a palace ball gives Ella hope that she might reunite with the dashing stranger (Richard Madden) she met in the woods, but her stepmother prevents her from going. Help arrives in the form of a kindly beggar woman who has a magic touch for ordinary things ...

    Price - 19.99
    ```

- ### Beauty and the Beast ( 2017 )

    ```
    Description - An arrogant prince is cursed to live as a terrifying beast until he finds true love. Strangely, his chance comes when he captures an unwary clockmaker, whose place is then taken by his bold and beautiful daughter Belle. Helped by the Beast's similarly enchanted servants, including a clock, a teapot and a candelabra, Belle begins to see the sensitive soul behind the fearsome facade. But as time runs out, it soon becomes obvious that Belle's cocky suitor Gaston is the real beast of the piece ...

    Price - 19.99
    ```

- ### Aladdin ( 2019 )

    ```
    Description - Aladdin is a lovable street urchin who meets Princess Jasmine, the beautiful daughter of the sultan of Agrabah. While visiting her exotic palace, Aladdin stumbles upon a magic oil lamp that unleashes a powerful, wisecracking, larger-than-life genie. As Aladdin and the genie start to become friends, they must soon embark on a dangerous mission to stop the evil sorcerer Jafar from overthrowing young Jasmine's kingdom ...

    Price - 19.99
    ```

- ### Add Other Film Informations

- ### Use seed.rb Add Products

    ``` ruby
    Product.create(
        name: "...", 
        description: "...",
        image: "...",
        price: ...
    )
    ```

    ```
    rails db:seed
    ```

- ### Create Product Index View

    ``` html
    <% if notice %>
        <p id="notice"><%= notice %></p>
    <% end %>

    <h1>Products</h1>

    <table>
        <tbody>
            <% @products.each do |product| %>
                <tr class="<%= cycle('list_line_even', 'list_line_odd') %>">
                    <td class="list_image"><%= image_tag(product.image) %></td>
                    <td class="list_description">
                        <dl>
                            <dt><%= product.name %></dt><br><br>
                            <dd>
                                <%= product.description %><br><br><br>
                            </dd>
                            <dd class="list_price">
                                $<%= product.price %>
                            </dd>
                        </dl>
                    </td>
                    <td class="list_actions">
                        <%= link_to 'Show', product %><br><br><br>
                        <%= link_to 'Edit', edit_product_path(product) %><br><br><br>
                        <%= link_to 'Destroy', product, method: :delete, data: { confirm: 'Are you sure?' } %>
                    </td>
                </tr>
            <% end %>
        </tbody>
    </table>

    <br>

    <%= link_to 'New Product', new_product_path %>
    ```

- ### Add Class to Layout View

    ``` html
    <body class="products">
    ```

- ### Add Validation to Product Model

    ``` ruby
    class Product < ApplicationRecord  
        validates :name, :description, :image, presence: true  
        validates :price, numericality: {greater_than_or_equal_to: 0.01}
        validates :name, uniqueness: true
        validates :image, allow_blank: true, format: {with: %r{\.(jpeg|jpg|png|gif)\z}i, message: 'Image Format must be JPEG, JPG, PNG, GIF! '}
    end
    ```

- ### Create Catalog for Shopper
    - Generate Controller

        ```
        rails g controller Shopper index
        ```

    - Create Index Views

        ``` html
        <<div id="block">
            <% if notice %>
                <p id="notice"><%= notice %></p>
            <% end %>
        </div>

        <h1>Products Catalog</h1>

        <% @products.each do |product| %>
            <div class="entry">
                <%= image_tag(product.image) %>
                <h3><%= product.name %></h3>
                <p><%= product.description %></p>
                <div class="price_line">
                    <span class="price">$<%= product.price %></span>
                </div>
            </div>
        <% end %>
        ```

    - Change Controller 

        ``` ruby
        def index
            @products = Product.order(:name)
        end
        ```

    - Change Layout View

        ``` html
        <body class="<%= controller.controller_name %>">
            <div id="banner">
                <%= image_tag("Disney.png") %>
                <p>Disney's Live-Action Animated Film Store</p>
            </div>
            <div id="columns">
                <div id="side">
                </div>
                <div id="main">
                    <%= yield %>
                </div>
            </div>
        </body>
        ```

    - Add Root in config / routes.rb

        ``` ruby
        root "shopper#index", as: "shopper"
        ```

- ### Create Cart Scaffold

    ```
    rails g scaffold Cart

    rails db:migrate
    ```

- ### Create Line_Item Scaffold

    ```
    rails g scaffold lineitem product:references cart:belongs_to

    rails db:migrate
    ```

- ### Add Has_Many to Cart and Product

    ``` ruby
    has_many :lineitems
    ```

- ### Action when Delete Lineitem
    - For Cart

        ``` ruby
        dependent: :destroy
        ```

    - For Product

        ``` ruby
        before_destory :make_sure_no_line_items

        def make_sure_no_line_items
            if lineitems.empty? 
                return true
            else      
                errors.add(:base, 'Line Items present') 
                return false
            end
        end
        ```

- ### Implement Add_to_Cart
    - Add the Button in Shopper Index View

        ``` html
        <%= button_to 'Add to Cart', lineitems_path(product_id: product), class: 'add_to_cart' %> 
        ```

    - Create a current_cart.rb in concerns Folder

        ``` ruby
        module CurrentCart  
            extend ActiveSupport::Concern
            
            def set_cart
                @cart = Cart.find(session[:cart_id])
            rescue
                @cart = Cart.create()
                session[:cart_id] = @cart.id
            end
        end
        ```

    - Add Something in LineItems Controller

        ``` ruby
        include CurrentCart

        before_action :set_cart
        ```

    - Modify the Create Action

        ``` ruby
        def create 
            product = Product.find(params[:product_id]) 
            @line_item = @cart.lineitems.build(product: product) 
            ...
        end
        ```

- ### Add Quantity to Lineitems Table
    - Add a Column for Quantity

        ```
        rails g migration AddSomethingToLineitems quantity:integer
        ```

    - Change Migration File

        ``` ruby
        add_column :lineitems, :quantity, :integer, default: 1
        ```

    - Migrate

        ```
        rails db:migrate
        ```

- ### Add Methods
    - Cart
        - Add Item

            ``` ruby
            def add_item(product_id)
                current_item = lineitems.find_by(product_id: product_id)

                if current_item
                    current_item.quantity += 1
                else
                    current_item = self.lineitems.build(product_id: product_id)
                end

                return current_item
            end
            ```

        - Total Price

            ``` ruby
            def total_price
                return lineitems.to_a.sum { |item| item.item_total_price }
            end
            ```

    - Lineietm
        - Item Total Price

            ``` ruby
            def item_total_price
                return quantity * self.product.price
            end
            ```

- ### Use Add Item Method

    ``` ruby
    @lineitem = @cart.add_item(product.id)
    ```

- ### Add Empty_Cart Method
    - Modify the Destroy Action

        ``` ruby
        def destroy
            @cart.destroy if @cart.id == session[:cart_id]    
            session[:cart_id] = nil
            ...
        end
        ```
        
- ### Move the Cart to Side Bar
    - Change the Layout View

        ``` html
        <div id="side">          
            <% if controller.controller_name == "shopper" %>
                <div id="cart">
                    <%= render @cart %>
                </div>
            <% end %>    
        </div>
        ```

    - Create _cart.html.erb

        ``` html
        <h3>Shopping Cart</h3>

        <table>
            <% @cart.lineitems.each do |item| %>
                <tr>
                    <td><%= item.quantity %> ×</td>
                    <td colspan="2" id="name"><%= item.product.name %></td>
                    <td>$<%= item.product.price %></td>
                </tr>
            <% end %>
            <tr>
                <td colspan="3">Total</td>
                <td><%= number_to_currency(@cart.total_price) %></td>
            </tr>
        </table>

        <%= button_to "Empty Cart", @cart, method: :delete, data: {confirm: "Are you sure?"} %>
        ```

    - Make Add to Cart and Empty Cart Redirect to Shopper_Url

        ``` ruby
        format.html { redirect_to shopper_url, ... }
        ```

    - Add Something in Shopper Controller

        ``` ruby
        include CurrentCart

        before_action :set_cart
        ```

- ### Add AJAX
    - Change the Add to Cart Button in Shopper Index View

        ``` html
        <%= button_to "Add to Cart", lineitems_path(product_id: product), class: "add_to_cart", remote: true %>
        ```

    - Add format.js in Lineitem Create Controller

        ``` ruby
        def create

            ...

            respond_to do |format|
                if @lineitem.save
                    format.html { redirect_to shopper_url }
                    format.js   # By Default, Goes to "create.js.erb"
                    format.json { render :show, status: :created, location: @lineitem }
                else
                    format.html { render :new }
                    format.json { render json: @lineitem.errors, status: :unprocessable_entity }
                end
            end
        end
        ```

    - Create create.js.erb in views/lineitems

        ``` javascript
        document.getElementById('block').innerHTML = "";
        document.getElementById('cart').innerHTML = "<%= escape_javascript render(@cart) %>";
        ```

- ### Order Table

    ```
    Name - String
    Address - Text
    Email - String
    Phone Number - String
    Pay Type - String
    ```

- ### Generate Order Scaffold & Add Order Column in Lineitem

    ```
    rails g scaffold Order name address:text email phonenumber paytype

    rails g migration AddOrderToLineitems order:references

    rails db:migrate
    ```

- ### Add Association in Lineitem Model

    ``` ruby
    belongs_to :order, optional: true
    ```

- ### Add Validation in Order Model

    ``` ruby
    class Order < ApplicationRecord
        has_many :lineitems, dependent: :destroy

        PAYMENT_TYPES = ["Credit Card", "PayPal", "Venmo", "AliPay", "WeChat Pay"]

        validates :name, :address, :email, :phonenumber, presence: true
        validates :paytype, inclusion: PAYMENT_TYPES
    end
    ```

- ### Add Check Out Button to Shopping Cart

    ``` html
    <%= button_to "Check Out", new_order_path, method: :get %>
    ```

- ### Modify Order Controller
    - Set Cart

        ``` ruby
        include CurrentCart

        before_action :set_cart, only: [:new, :create]
        ```

    - Modify New Action

        ``` ruby
        def new
            if @cart.lineitems.empty?
                redirect_to shopper_url, notice: "Your Cart is Still Empty! "
                return
            end
            
            @order = Order.new
        end
        ```

- ### Change the View of Order
    - For new.html.erb

        ``` html
        <h1>New Order Information</h1>

        <div class="order_form">
            <fieldset>
                <legend>Please Enter Your Information</legend>

                <%= render 'form' %>
            </fieldset>
        </div>
        ```

    - For _form.html.erb

        ``` html
        <%= form_for(@order) do |form| %>
            <% if @order.errors.any? %>
                <div id="error_explanation">
                    <h2><%= pluralize(@order.errors.count, "error") %> prohibited this order from being saved:</h2>

                    <ul>
                        <% @order.errors.full_messages.each do |message| %>
                            <li><%= message %></li>
                        <% end %>
                    </ul>
                </div>
            <% end %>

            <div class="field">
                <%= form.label :name %>
                <%= form.text_field :name, size: 23 %>
            </div>

            <div class="field">
                <%= form.label :address %>
                <%= form.text_area :address, rows: 3, cols: 21 %>
            </div>

            <div class="field">
                <%= form.label :email %>
                <%= form.text_field :email, size: 23, placeholder: "?@?.com" %>
            </div>

            <div class="field">
                <%= form.label 'Phone Number' %>
                <%= form.text_field :phonenumber, size: 23, placeholder: "?-?-?" %>
            </div>

            <div class="field">
                <%= form.label 'Payment Method' %>
                <%= form.select :paytype, Order::PAYMENT_TYPES, prompt: "Select a Payment Method" %>
            </div>

            <div class="actions">
                <%= form.submit 'Place Order' %>
            </div>

            <%= link_to 'Back', shopper_url %>
        <% end %>
        ```

- ### Change Create Order Controller

    ``` ruby
    def create
        @order = Order.new(order_params)

        respond_to do |format|
            if @order.save
                @order.add_items_from_cart(@cart)

                Cart.destroy(session[:cart_id])
                session[:cart_id] = nil

                format.html { redirect_to shopper_url, notice: 'Thanks for your Order ! Your Order has been Placed. ' }
                format.json { render :show, status: :created, location: @order }
            else
                format.html { render :new }
                format.json { render json: @order.errors, status: :unprocessable_entity }
            end
        end
    end
    ```

- ### Define add_items_from_cart in Order Model

    ``` ruby
    def add_items_from_cart(cart)
        cart.lineitems.each do |item|
            item.cart_id = nil
            item.order_id = self.id

            item.save
        end
    end
    ```

- ### Order Table

    ```
    Username - String
    Password - String
    ```

- ### Generate Admin User Scaffold

    ```
    rails g scaffold User username password_digest
    ```

- ### Change the Migration File

    ``` ruby
    class CreateUsers < ActiveRecord::Migration[5.2]
        def change
            create_table :users do |t|
                t.string :username
                t.string :password_digest

                t.timestamps
            end
        end
    end
    ```

- ### Migrate User Table

    ```
    rails db:migrate
    ```

- ### Add Validate in User Model

    ``` ruby
    class User < ApplicationRecord
        validates :username, presence: true, uniqueness: true
        validates :password, :password_confirmation, presence: true
        validates :password, confirmation: { case_sensitive: true }
        has_secure_password     # Then we can call user.authenticate Method
    end
    ```

- ### Change Gemfile and Install
    - Uncomment Below

        ```
        gem 'bcrypt', '~> 3.1.7'
        ```

    - Install Gem

        ```
        bundle install
        ```

- ### Modify Action in User Controller
    - For Create

        ``` ruby
        def create
            @user = User.new(user_params)

            respond_to do |format|
                if @user.save
                    format.html { redirect_to users_url, notice: "User #{@user.username} was successfully created." }
                    format.json { render :show, status: :created, location: @user }
                else
                    format.html { render :new }
                    format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
        end
        ```

    - For Update

        ``` ruby
        def update
            respond_to do |format|
                if @user.update(user_params)
                    format.html { redirect_to users_url, notice: "User #{@user.username} was successfully updated." }
                    format.json { render :show, status: :ok, location: @user }
                else
                    format.html { render :edit }
                    format.json { render json: @user.errors, status: :unprocessable_entity }
                end
            end
        end
        ```

    - For Index

        ``` ruby
        def index
            @users = User.order(:username)
        end
        ```

    - Other

        ``` ruby
        # Never trust parameters from the scary internet, only allow the white list through.
        def user_params
            params.require(:user).permit(:username, :password, :password_confirmation)
        end
        ```

- ### Change User Index View 

    ``` html
    <% if notice %>
        <p id="notice"><%= notice %></p>
    <% end %>

    <h1>Admin Users</h1>
    ```

- ### Change _form.html.erb in User View

    ``` html
    <div class="order_form">
        <%= form_for(@user) do |form| %>
            <% if @user.errors.any? %>
                <div id="error_explanation">
                    <h2><%= pluralize(@user.errors.count, "error") %> prohibited this user from being saved:</h2>

                    <ul>
                        <% @user.errors.full_messages.each do |message| %>
                            <li><%= message %></li>
                        <% end %>
                    </ul>
                </div>
            <% end %>

            <fieldset>
                <legend>Please Enter User Information</legend>
                <div class="field">
                    <%= form.label :username %>
                    <%= form.text_field :username %>
                </div>

                <div class="field">
                    <%= form.label :password %>
                    <%= form.password_field :password %>
                </div>

                <div class="field">
                    <%= form.label :password_confirmation %>
                    <%= form.password_field :password_confirmation %>
                </div>

                <div class="actions">
                    <%= form.submit %>
                </div>

                <%= link_to 'Back', users_path %>
            </fieldset>
        <% end %>
    </div>
    ```

- ### Create Action for Admin to Check Orders Number

    ```
    rails g controller admin index
    ```

- ### Change the Index View for Admin

    ``` html
    <% if notice %>
        <p id="notice"><%= notice %></p>
    <% end %>

    <h1>Welcome Back !</h1>

    <p>Now, it is <%= Time.now %></p>
    <p>There are still <%= pluralize(@total_orders, "Order") %> Waiting to be Completed !</p>
    ```

- ### Change the Admin Controller

    ``` ruby
    class AdminController < ApplicationController
        def index
            @total_orders = Order.count
        end
    end
    ```

- ### Create Action for Authenticated User

    ```
    rails g controller access new create destroy
    ```

- ### Change the View for User Login ( new.html.erb )

    ``` html
    <div class="order_form">
        <% if flash[:alert] %>
            <p id="notice"><%= flash[:alert] %></p>
        <% end %>

        <%= form_tag do %>
            <fieldset>
                <legend>Please Login First</legend>
                <div>
                    <%= label_tag :username, 'Username:' %>
                    <%= text_field_tag :username, params[:username] %>
                </div>
                <div>
                <%= label_tag :password, 'Password:' %>
                    <%= password_field_tag :password, params[:password] %>
                </div>
                <div>
                    <%= submit_tag "Login" %>
                </div>
            </fieldset>
        <% end %>
    </div>
    ```

- ### Change Actions in Access Controller

    ``` ruby
    class AccessController < ApplicationController
        def new
            if session[:user_id]
                redirect_to admin_url, notice: "You've Already Logged In! "
            return
            end 
        end

        # Post '/login'
        def create
            user = User.find_by(username: params[:username])

            if user and user.authenticate(params[:password])
                session[:user_id] = user.id
                redirect_to admin_url, notice: "You've Logged In Successfully! "
            else
                redirect_to login_url, alert: "Invalid Username or Password. Please Try Again! "
            end
        end

        def destroy
            session[:user_id] = nil
            redirect_to shopper_url, notice: "You've Logged Out Successfully ! "
        end
    end
    ```

- ### Change the Route in config / routes.rb

    ``` ruby
    get '/admin', to: "admin#index", as: "admin"
    get '/login', to: "access#new", as: "login"
    post '/access/new', to: "access#create"     # POST '/login'
    delete '/logout', to: "access#destroy", as: "logout"
    ```

- ### Add Links and Buttons to Side Bar

    ``` html
    <div id="side">
        <% if controller.controller_name == "shopper" %>
          <div id="cart">
            <%= render(@cart) %>
          </div>
        <% end %>
        <h3>Website Links</h3>
        <ul>
            <li><%= link_to 'Home', shopper_path %></li>
            <li><%= link_to 'Products', products_path %></li>
            <li><%= link_to 'Orders', orders_path %></li>
            <li><%= link_to 'Users', users_path %></li>
            <li><%= link_to 'Login', access_new_path %></li>
        </ul>
        <% if session[:user_id] %>
            <%= button_to 'Logout', logout_path, method: :delete %>
        <% end %>
    </div>
    ```

- ### Set Access in Application Controller

    ``` ruby
    class ApplicationController < ActionController::Base
        before_action :authorize

        # Prevent CSRF attacks by raising an exception.
        # For APIs, you may want to use :null_session instead.
        protect_from_forgery with: :exception

        def authorize
            unless User.find_by(id: session[:user_id])
                redirect_to login_url, notice: "Please Login First ! "
            end
        end
    end
    ```

- ### Add Shopper, Cart, Lineitem, Access to the White List

    ``` ruby
    skip_before_action :authorize
    ```

- ### Add New and Create Order to the White List

    ``` ruby
    skip_before_action :authorize, only: [:new, :create]
    ```

- ### Add Search Bar in Home Page
    - For View ( application.html.erb )

        ``` html
        <div id="side">
            <% if controller.controller_name == "shopper" %>
                <h3>Search Product</h3>
                <div id="search_bar">
                    <%= form_tag(shopper_path, method: :get) do %> 
                    <%= text_field_tag(:search, params[:search]) %>
                    <%= submit_tag("Search") %>
                    <% end %>
                </div>
            <% end %>
            <% if controller.controller_name == "shopper" %>
                <div id="cart">
                    <%= render(@cart) %>
                </div>
            <% end %>
            <h3>Website Links</h3>
            <ul>
                <li><%= link_to 'Home', shopper_path %></li>
                <li><%= link_to 'Product', products_path %></li>
                <li><%= link_to 'Order', orders_path %></li>
                <li><%= link_to 'User', users_path %></li>
                <li><%= link_to 'Login', access_new_path %></li>
            </ul>
            <% if session[:user_id] %>
                <%= button_to 'Logout', logout_path, id: 'logout', method: :delete %>
            <% end %>
        </div>
        ```

    - For Controller ( shopper_controller.rb )

        ``` ruby
        def index
            @products = Product.search(params[:search])
        end
        ```

    - For Model ( product.rb ), Add Search Function

        ``` ruby
        def self.search(name)
            if name
                return Product.where('name LIKE ?', "%#{name}%").order(:name)
            else
                return Product.order(:name)
            end
        end
        ```

    - ( Optional ) Change the Shopper Index View

        ``` html
        <div id="block">
            <% if notice %>
                <p id="notice"><%= notice %></p>
            <% end %>
        </div>

        <h1>Products Catalog</h1>

        <% if @products.length != 0 %>
            <% @products.each do |product| %>
                <div class="entry">
                    <%= image_tag(product.image) %>
                    <h3><%= product.name %></h3>
                    <p><%= product.description %></p>
                    <div class="price_line">
                        <span class="price">$<%= product.price %></span>
                    </div>
                    <%= button_to "Add to Cart", lineitems_path(product_id: product), class: "add_to_cart", remote: true %>
                </div>
            <% end %>
        <% else %>
            <p id="oops">- Sorry, There is No Similar Products in Our Store Currently ! -</p>
        <% end %>
        ```

- ### ( Optional ) Optimize Products View & Function
    - For Show Products Information, Show the Image

        ``` html
        <% if notice %>
            <p id="notice"><%= notice %></p>
        <% end %>

        <h1>Product Details</h1>

        <table>
            <tbody>
                <tr>
                    <td class="list_image"><%= image_tag(@product.image) %></td>
                    <td class="list_description">
                        <strong>Name:</strong>
                        <%= @product.name %>
                        <br><br><br>
                        <strong>Description:</strong>
                        <%= @product.description %>
                        <br><br><br>
                        <strong>Price:</strong>
                        $<%= @product.price %>
                    </td>
                </tr>
            </tbody>
        </table>

        <%= link_to 'Edit', edit_product_path(@product) %> |
        <%= link_to 'Back', products_path %>
        ```

    - For _form.html.erb

        ``` html
        <div class="order_form">
            <%= form_with(model: product, local: true) do |form| %>
                <% if product.errors.any? %>
                    <div id="error_explanation">
                        <h2><%= pluralize(product.errors.count, "error") %> prohibited this product from being saved:</h2>

                        <ul>
                            <% product.errors.full_messages.each do |message| %>
                                <li><%= message %></li>
                            <% end %>
                        </ul>
                    </div>
                <% end %>

                <fieldset>
                    <legend>Please Enter Product Information</legend>
                    <div class="field">
                        <%= form.label :name %>
                        <%= form.text_field :name %>
                    </div>

                    <div class="field">
                        <%= form.label :description %>
                        <%= form.text_area :description, cols: 18, rows: 20 %>
                    </div>

                    <div class="field">
                        <%= form.label 'Image Name' %>
                        <%= form.text_field :image %>
                    </div>

                    <div class="field">
                        <%= form.label :price %>
                        <%= form.text_field :price %>
                    </div>

                    <div class="actions">
                        <%= form.submit %>
                    </div>

                    <%= link_to 'Back', products_path %>
                </fieldset>
            <% end %>
        </div>
        ```

- ### ( Optional ) Change the SCSS as you Wish ( or you can Copy Mine )
    - application.scss

        ``` scss
        #banner {
            background: #efc780;
            padding: 10px;
            border-bottom: 2px solid;
            height: 60px;
            color: #282;
            text-align: center;

            p {
                margin-top: 25px;
                font-size: 40px;
                font-family: cursive;
            }

            img {
                width: 120px;
                float: left;
            }
        }

        #notice {
                color: red !important;
                border: 2px solid red;
                padding: 1em;
                margin-bottom: 1.5em;
                background-color: #f0f0f0;
                font-weight: bold;
                font-size: larger;
                font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
        }

        #columns {
            background: #9c947a;

            #main {
                margin-left: 17em;
                padding: 1em;
                background: white;

                h1 {
                    font-size: 200%;
                    font-family: monospace;
                    margin-bottom: 1em;
                }

                #oops {
                    font-size: larger;
                    font-family: 'Gill Sans', 'Gill Sans MT', Calibri, 'Trebuchet MS', sans-serif;
                    color: #226;
                    margin-bottom: 1em;
                }
            }

            #side {
                float: left;
                padding: 1em 1em;
                width: 15em;
                background: #9c947a;

                h3 {
                    font-size: large;
                    font-family: fantasy;
                    font-weight: bold;
                    font-style: italic;
                    color: white;
                }

                #search_bar {
                    form {
                        #search {
                            width: 125px;
                            margin-bottom: 0.5em;
                        }
                    }
                }

                #cart {
                    font-size: small; 
                    color: white;
            
                    table {
                        border-top: 1px dotted #599;
                        border-bottom: 1px dotted #599;
                        padding-top: 0.5em;
                        margin-bottom: 10px;
                        table-layout: fixed;
                        width: 100%;

                        #name {
                            white-space: nowrap; 
                            overflow: hidden; 
                            text-overflow: ellipsis;
                        }
                    }

                    #check {
                        margin-left: 31px;
                    }
                }

                form, div {
                    display: inline;
                }
            
                input {
                    font-size: small;
                }

                #logout {
                    margin-top: 1em;
                }

                ul {
                    padding-left: 1.5em;

                    li {
                        margin-bottom: 1em;
                        color: white;

                        a{
                            color: #bfb;
                            
                        }
                    } 
                }
            } 
        }
        ```
    - products.scss

        ``` scss
        .products {
            h1 {
                font-size: 200%;
                font-family: monospace;
                margin-bottom: 1em;
            }

            table {
                border-collapse: collapse;
            }

            table tr td {
                padding: 0.5em;
                vertical-align: top;
            }
            
            .list_image {
                width:  15%;

                img {
                    width: 100%;
                }
            }
            
            .list_description {
                width: 75%;

                dl {
                    margin: 0; 
                }

                dt {
                color:        #244;
                font-weight:  bold;
                font-size:    larger;
                }

                dd {
                    margin: 0; 
                }

                .list_price {
                    color:        #244;
                    font-weight:  bold;
                }
            }

            .list_actions {
                text-align:   center;
                padding-top:  4em;
                padding-left: 1em;
            }
            
            .list_line_even {
                background:   #e0f8f8;
            }
            
            .list_line_odd {
                background:   #f8b0f8;
            }

            .list_line {
                background:   #abaca9;
            }
        }
        ```

    - shopper.scss

        ``` scss
        .shopper {
            h1 {
                margin: 0;
                margin-top: 0.5em;
                padding-bottom: 1em;
                font-size: 150%;
                font-family: monospace;
                color: #226;
                border-bottom: 3px dotted #77d;
            }
            /* An entry in the store catalog */
            .entry {
                overflow: auto;
                margin-top: 1em;
                border-bottom: 1px dotted #77d;
                min-height: 140px;

                img {
                    width: 85px;
                    margin-right: 5px;
                    margin-bottom: 5px;
                    position: absolute;
                }

                h3 {
                    font-size: 120%;
                    font-family: sans-serif;
                    margin-left: 100px;
                    margin-top: 0;
                    margin-bottom: 2px;
                    color: #227;
                }

                p, .price_line {
                    margin-left: 100px;
                    margin-right: 10px;
                    margin-top: 0.5em;
                    margin-bottom: 0.8em;
                }

                .price {
                    color: #44a;
                    font-weight: bold;
                }

                form, div {
                    display: inline;
                }
            }
        }
        ```

    - orders.scss
    
        ``` scss
        .order_form {
            fieldset {
                background: #efe;
        
                legend {
                    color: #aaa;
                    font-weight: bold;
                    font-size: larger;

                    form { 
                        label {
                            background: #141;
                            font-family: sans-serif;
                            padding: 0.2em 1em;
                        }
                    }

                    text-align: left;
                    display: block;
                }

                width: 60em;

                select, textarea, input {
                    margin-top: 0.5em;
                    margin-left: 0.5em;
                }

                select {
                    min-height: 25px;
                }
        
                .actions {
                    margin-right: 2em;
                }

                .actions, a {
                    display: inline;
                }

                #login {
                    margin-top: 0.5em;
                }

                p {
                    font-size: smaller;
                    font-family: 'Lucida Sans', 'Lucida Sans Regular', 'Lucida Grande', 'Lucida Sans Unicode', Geneva, Verdana, sans-serif;
                }
        
                br {
                    display: none
                }
            }
        }
        ```

- ### ( Optional ) Optimize Orders View & Function
    - For Order Index, just Show the Order ID and Allow Admin User to View Order Details and Complete Order

        ``` html
        <% if notice %>
            <p id="notice"><%= notice %></p>
        <% end %>

        <h1>Orders</h1>

        <table>
            <thead>
                <tr>
                    <th>Order ID</th>
                </tr>
            </thead>

            <tbody>
                <% @orders.each do |order| %>
                <tr>
                    <td><%= order.id %></td>
                    <td><%= link_to 'Show Details', order %></td>
                    <td><%= link_to 'Complete', order, method: :delete, data: { confirm: 'Are you sure?' } %></td>
                </tr>
                <% end %>
            </tbody>
        </table>
        ```

    - For Show Order Detail, Show the Shopper Information and Order Information

        ``` html
        <% if notice %>
            <p id="notice"><%= notice %></p>
        <% end %>

        <p>
            <strong>Name:</strong>
            <%= @order.name %>
        </p>

        <p>
            <strong>Address:</strong>
            <%= @order.address %>
        </p>

        <p>
            <strong>Email:</strong>
            <%= @order.email %>
        </p>

        <p>
            <strong>Phone Number:</strong>
            <%= @order.phonenumber %>
        </p>

        <p>
            <strong>Payment Method:</strong>
            <%= @order.paytype %>
        </p>

        <p>
            <strong>Order Details:</strong>
        </p>

        <% @order.lineitems.each do |item|%>
            <ul>
                <li><%= item.quantity %> × <%= item.product.name %></li>
            </ul>
        <% end%>

        <%= link_to 'Back', orders_path %>
        ```

    - For Delete Controller

        ``` ruby
        def destroy
            @order.destroy
            respond_to do |format|
                format.html { redirect_to orders_url, notice: "Order No.#{@order.id} was Completed !" }
                format.json { head :no_content }
            end
        end
        ```

- ### ( Optional ) Optimize Admin Users View & Function
    - For User Index, just Show the Username and Allow Admin Users to Create, Edit and Delete User

        ``` html
        <% if notice %>
            <p id="notice"><%= notice %></p>
        <% end %>

        <h1>Admin Users</h1>

        <br>

        <table>
            <tbody>
                <% @users.each do |user| %>
                    <tr>
                        <td>-</td>
                        <td><%= user.username %></td>
                        <td><%= link_to 'Edit Information', edit_user_path(user) %></td>
                        <td><%= link_to 'Delete', user, method: :delete, data: { confirm: 'Are you sure?' } %></td>
                    </tr>
                <% end %>
            </tbody>
        </table>

        <br>

        <%= link_to 'Create Admin User', new_user_path %>
        ```

    - For Delete Controller

        ``` ruby
        def destroy
            if @user.id != session[:user_id]
                @user.destroy
            else
                redirect_to users_url, notice: "User #{@user.username} cannot be Deleted !"
                return
            end

            respond_to do |format|
                format.html { redirect_to users_url, notice: "User #{@user.username} was Successfully Deleted !" }
                format.json { head :no_content }
            end
        end
        ```
            

- ### ( Optional ) Use Asset Pipeline
    - Change development.rb in config/environments

        ``` ruby
        # Debug mode disables concatenation and preprocessing of assets.
        # This option may cause significant delays in view rendering with a large
        # number of complex assets.
        config.assets.debug = false

        # Suppress logger output for asset requests.
        config.assets.quiet = false
        ```