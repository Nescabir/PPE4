class LoginController < ApplicationController

    $api_username = ""
    $api_password = ""
    $message = ""
    $connected = false
  
    def index
        render layout: "login"
    end

    def destroy
        $connected = false

        redirect_to root_path
    end
  
    def create
        username = params[:login]['username']
        password = params[:login]['password']

        getToken = HTTParty.get('https://api.egcorp.tk/tokens/log/' + username + '/' + password)
        token = JSON.parse getToken.body
        token = token['token']

        if token == 'Bad User'
            $message = "Identifiant incorrect"
            $connected = false
            redirect_to root_path
        elsif token == 'Bad Mdp'
            $message = "Mot de passe incorrect"
            $connected = false
            redirect_to root_path
        else
            $api_username = username
            $api_password = password
            $connected = true
            redirect_to players_path
        end
    end
end