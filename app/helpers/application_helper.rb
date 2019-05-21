require 'securerandom'

module ApplicationHelper

    def title(page_title)
        content_for(:title) { page_title }
    end

    def joli_tel(numero,separateur)
        numero.split('').in_groups_of(2).collect(&:join).join(separateur)
    end

    def soldeOperationsJoueurs(collection)
        solde = 0

        collection.each do |item|
            solde += item['montant']
        end    

        return solde
    end

end
