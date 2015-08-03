Rails.application.routes.draw do
  resources :rechargers, except: [:new, :edit]
  resources :wallets, except: [:new, :edit]
  resources :revenues, except: [:new, :edit]

  resources :recharge, except: [:new, :edit]
  resources :spend, except: [:new, :edit]
  resources :refund, except: [:new, :edit]
end
