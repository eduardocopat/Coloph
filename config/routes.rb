Coloph::Application.routes.draw do
  root :to => 'welcome#index'
  get "welcome/index"

  match '/features' => 'static_pages#features'
  match '/bug_report' => 'static_pages#bug_report'
  match '/help' => 'static_pages#help'

  resources :diagrams do
    resources :tables do
      resources :table_fields
    end
    resources :relationships
    resources :specializations
  end

  match "/relationship.json/validate" => "relationships#validate"
  match "/table.json/validate" => "tables#validate"
  match "/table.json/changeName" => "tables#changeName"
  match "/table_field.json/validate" => "table_fields#validate"
  match "/delete_table_field.json" => "tables#deleteTableField"

  #match "/coloph", :to => redirect("/Coloph/web/coloph.html")

  devise_for :users

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
end
