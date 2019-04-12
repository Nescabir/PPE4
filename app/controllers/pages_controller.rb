class PagesController < ApplicationController
  require "httparty"

  getToken = HTTParty.get('http://193.70.0.15:8080/tokens/log/technicien/technicien2018*')
  token = JSON.parse getToken.body
  token = token['token']
  $bearerToken = 'Bearer ' + token

  def home

    getJoueursMethod()
  end

  def getJoueursMethod
    getJoueurs = HTTParty.get('http://193.70.0.15:8080/joueurs', :headers => {
      "Authorization" => $bearerToken
    })
    @joueurs = JSON.parse getJoueurs.body
  end
  
end