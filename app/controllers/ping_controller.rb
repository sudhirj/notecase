class PingController < ApplicationController

    def index
      render json: {
        message: 'pong'
      }
    end
end
