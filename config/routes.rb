Rails.application.routes.draw do
  get 'count/index'
  get 'hello/index'
  root to: 'hello#index'
end
