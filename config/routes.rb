Rails.application.routes.draw do
  resources :transcoding, only: %i[new create show]

  root 'transcoding#new'
end
