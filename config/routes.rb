Rails.application.routes.draw do
  scope ENV.fetch('MOUNT_PATH', '') do
    resources :rechargers, except: [:new, :edit, :update, :destroy]
    resources :wallets, except: [:new, :edit, :update, :destroy]
    resources :revenues, except: [:new, :edit, :update, :destroy]

    resources :recharges, except: [:new, :edit, :update, :destroy]
    resources :spends, except: [:new, :edit, :update, :destroy]
    resources :refunds, except: [:new, :edit, :update, :destroy]

    get '/wallets/:wallet_id/statement', to: 'reports#statement'

    get '/', to: 'home#index'
  end
end
