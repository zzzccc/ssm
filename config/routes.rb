Ssm::Application.routes.draw do
  
  resources :monitor

  get 'sys' => 'monitor#sys', as: :monitor_sys
  get 'http' => 'monitor#http', as: :monitor_http

end
