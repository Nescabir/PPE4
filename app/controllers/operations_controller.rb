class OperationsController < ApplicationController
    require "httparty"
    require "json"

    getToken = HTTParty.get('https://api.egcorp.tk/tokens/log/' + $api_username + '/' + $api_password)
    token = JSON.parse getToken.body
    token = token['token']
    $bearerToken = 'Bearer ' + token

    def index

        if $connected == true
            player_id = params[:player_id]
    

            @players = HTTParty.get(
                'https://api.egcorp.tk/joueurs',
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )

            @infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + player_id,
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            comptejoueur = HTTParty.get(
                'https://api.egcorp.tk/comptes/byPseudojoueur/' + @infojoueur['pseudo'],
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            @operationsjoueur = HTTParty.get(
                'https://api.egcorp.tk/operations/byNumerocompte/' + comptejoueur['numerocompte'],
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
        else
            redirect_to root_path
        end
    end

    def new

        if $connected == true
            player_id = params[:player_id]
    

            @players = HTTParty.get(
                'https://api.egcorp.tk/joueurs',
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )

            @infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + player_id,
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
        else
            redirect_to root_path
        end
    end

    def create
        if $connected == true
            player_id = params[:player_id]
    
            infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + player_id,
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            comptejoueur = HTTParty.get(
                'https://api.egcorp.tk/comptes/byPseudojoueur/' + infojoueur['pseudo'],
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            nomoperation = params[:operation]["nomoperation"]
            montant = params[:operation]["montant"].to_i
            dateoperation = DateTime.now.strftime('%FT%T%:z')
            numerocompte = comptejoueur['numerocompte']
            idcomptejoueur = comptejoueur['idcomptejoueur'].to_s
    
            operation = {
                "nomoperation" => nomoperation,
                "montant" => montant,
                "dateoperation" => dateoperation,
                "numerocompte" => numerocompte,
                "idcomptejoueur" => "/comptes/" + idcomptejoueur
            }
    
            post_operation = HTTParty.post(
                'https://api.egcorp.tk/operations',
                :body => JSON.generate(operation),
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            redirect_to player_operations_path(infojoueur['idjoueur'])
        else
            redirect_to root_path
        end
    end
end
