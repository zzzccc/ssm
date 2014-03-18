Ssm::Application.routes.draw do
  
  resources :srvinfos

  resources :monitor

  get 'sys/:hostname' => 'monitor#sys', as: :monitor_sys , :constraints => { :hostname => /.*/ }
  get 'http/:hostname/:port' => 'monitor#http', as: :monitor_http , :constraints => { :hostname => /.*/ }

end
