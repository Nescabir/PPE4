class PagesController < ApplicationController
  require "httparty"

  getToken = HTTParty.get('http://api.egcorp.tk/tokens/log/technicien/technicien2018*')
  token = JSON.parse getToken.body
  token = token['token']
  $bearerToken = 'Bearer ' + token

  def home

  end

  def login

  end

  def getJoueursMethod
    getJoueurs = HTTParty.get('http://api.egcorp.tk/joueurs', :headers => {
      "Authorization" => $bearerToken
    })
    @joueurs = JSON.parse getJoueurs.body
  end
  
end