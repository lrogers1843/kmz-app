Rails.application.routes.draw do
  resources :pictures
  resources :projects
  root 'projects#index'
  get 'projects/download_file/:id', to: 'projects#download_file'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end

