class PlayersController < ApplicationController
    require "httparty"
    require "json"

    getToken = HTTParty.get('https://api.egcorp.tk/tokens/log/' + $api_username + '/' + $api_password)
    token = JSON.parse getToken.body
    token = token['token']
    $bearerToken = 'Bearer ' + token

    def generernumerocompte
        x = 0
        numcompte = Array.new
        while x < 24
            x += 1
            if  x == 5 || x == 10 || x == 15 || x == 20
                numcompte << "-"
            else
                numcompte << SecureRandom.random_number(10)
            end
        end
        return numcompte.join
    end

    def soldeOperationsJoueurs(collection)
        solde = 0

        collection.each do |item|
            solde += item['montant']
        end    

        return solde
    end

    def index
        if $connected == true
            @players = HTTParty.get(
                'https://api.egcorp.tk/joueurs',
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
    
            @players = HTTParty.get(
                'https://api.egcorp.tk/joueurs',
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
        else
            redirect_to root_path
        end
    end
    
    def show
        if $connected == true
            id = params[:id]
    
            @players = HTTParty.get(
                'https://api.egcorp.tk/joueurs',
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            @infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + id,
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
    
            operationsjoueur = HTTParty.get(
                'https://api.egcorp.tk/operations/byNumerocompte/' + comptejoueur['numerocompte'],
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )

            @soldeOperations = soldeOperationsJoueurs(operationsjoueur)
        else
            redirect_to root_path
        end
    end

    def destroy
        
        if $connected == true
            id = params[:id]
    
            infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + id,
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
    
            operationsjoueur = HTTParty.get(
                'https://api.egcorp.tk/operations/byNumerocompte/' + comptejoueur['numerocompte'],
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            operations_archives = Array.new
    
            operationsjoueur.each do |operation|
                operations_archives << {
                    "nomoperation" => operation['nomoperation'],
                    "montant" => operation['montant'],
                    "dateoperation" => operation['dateoperation'],
                    "numerocompte" => comptejoueur['numerocompte']
                }
            end
    
            joueur_archive = {
                "idjoueurarchive" => infojoueur['idjoueur'],
                "pseudoarchive" => infojoueur['pseudo'],
                "motdepassearchive" => infojoueur['motdepasse'],
                "nomarchive" => infojoueur['nom'],
                "prenomarchive" => infojoueur['prenom'],
                "datenaissancearchive" => infojoueur['datenaissance'],
                "datecreationarchive" => infojoueur['datecreation'],
                "numerotelephonearchive" => infojoueur['numerotelephone'],
                "nombrepartiesarchive" => infojoueur['nombreparties']
            }
    
            compte_archive = {
                "idcomptejoueur" => comptejoueur['idcomptejoueur'],
                "pseudojoueur" => comptejoueur['pseudojoueur'],
                "numerocompte" => comptejoueur['numerocompte']
            }
    
            post_joueur_archive = HTTParty.post(
                'https://api.egcorp.tk/joueur_archives', 
                :body => JSON.generate(joueur_archive), 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            post_compte_archive = HTTParty.post(
                'https://api.egcorp.tk/compte_archives', 
                :body => JSON.generate(compte_archive), 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            operations_archives.each do |operation|
                post_operation_archive = HTTParty.post(
                    'https://api.egcorp.tk/operation_archives', 
                    :body => JSON.generate(operation), 
                    :headers => { 
                        'Content-Type' => 'application/json',
                        "Authorization" => $bearerToken 
                    } 
                )
            end
    
    
            idcompte = comptejoueur['idcomptejoueur'].to_s
            idjoueur = infojoueur['idjoueur'].to_s
    
            delete_joueur = HTTParty.delete(
                'https://api.egcorp.tk/joueurs/' + idjoueur, 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
    
            operationsjoueur.each do |operation|
                delete_operation = HTTParty.delete(
                'https://api.egcorp.tk/operations/' + operation['idoperation'].to_s, 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
            end
    
            delete_compte = HTTParty.delete(
                'https://api.egcorp.tk/comptes/' + idcompte, 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            redirect_to players_path
        else
            redirect_to root_path
        end
    end

    def edit

        if $connected == true
            id = params[:id]
    
            @players = HTTParty.get(
                'https://api.egcorp.tk/joueurs',
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            @infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + id,
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            comptejoueur = HTTParty.get(
                'https://api.egcorp.tk/comptes/byPseudojoueur/' + @infojoueur["pseudo"],
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            @datenaissance = DateTime.strptime(@infojoueur['datenaissance'], '%Y-%m-%dT%H:%M:%S%z')
    
        else
            redirect_to root_path
        end
    end

    def update

        if $connected == true
            id = params[:id]
    
            infojoueur = HTTParty.get(
                'https://api.egcorp.tk/joueurs/' + id,
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
    
    
            pseudo = params[:player]["username"]
            motdepasse = params[:player]["password"]
            nom = params[:player]["lastname"]
            prenom = params[:player]["firstname"]
            datenaissance = params[:player]["birthday"]
            numerotelephone = params[:player]["phone"]
    
            joueur = {
                "pseudo" => pseudo,
                "motdepasse" => motdepasse,
                "nom" => nom,
                "prenom" => prenom,
                "datenaissance" => datenaissance,
                "numerotelephone" => numerotelephone
            }
    
            compte = {
                "pseudojoueur" => pseudo
            }
    
            put_joueur = HTTParty.put(
                'https://api.egcorp.tk/joueurs/' + id, 
                :body => JSON.generate(joueur), 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            idcompte = comptejoueur['idcomptejoueur'].to_s
    
            put_compte = HTTParty.put(
                'https://api.egcorp.tk/comptes/' + idcompte, 
                :body => JSON.generate(compte), 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            redirect_to player_path
        else
            redirect_to root_path
        end
    end

    def create
        if $connected == true

            pseudo = params[:player]["username"]
            motdepasse = params[:player]["password"]
            nom = params[:player]["lastname"]
            prenom = params[:player]["firstname"]
            datenaissance = params[:player]["birthday"]
            datecreation = DateTime.now
            numerotelephone = params[:player]["phone"]
            nombreparties = 0
            numcompte = generernumerocompte
    
            joueur = {
                "pseudo" => pseudo,
                "motdepasse" => motdepasse,
                "nom" => nom,
                "prenom" => prenom,
                "datenaissance" => datenaissance,
                "datecreation" => datecreation,
                "numerotelephone" => numerotelephone,
                "nombreparties" => nombreparties
            }
    
            compte = {
                "pseudojoueur" => pseudo,
                "numerocompte" => numcompte
            }
    
            post_joueur = HTTParty.post(
                'https://api.egcorp.tk/joueurs', 
                :body => JSON.generate(joueur), 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            post_compte = HTTParty.post(
                'https://api.egcorp.tk/comptes', 
                :body => JSON.generate(compte), 
                :headers => { 
                    'Content-Type' => 'application/json',
                    "Authorization" => $bearerToken 
                } 
            )
    
            redirect_to players_path
        else
            redirect_to root_path
        end
    end
end
