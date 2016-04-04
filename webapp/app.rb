require 'mongo'

module CHALLENGE
  class App < Sinatra::Base
    helpers do
      def title
        "Challenge demo app"
      end
    end

    get '/' do
      erb :index
    end

    post '/' do

      # TODO: the client should be a class member
      client = Mongo::Client.new([ 'mongodbd:27017' ], :database => 'comments')
      colls = client.database.collection_names

      # Ensure we are not creating the collection twice
      if colls.length > 0 and not colls.include?('comments')
      	coll = client[:comments]
      	coll.create
      end
     
      # Insert new comment
      if params[:text] and params[:author]
        client[:comments].insert_one({"text" => params[:text], "author" => params[:author]})
      end

      # Render all available comments
      comments = client[:comments].find
      erb :comments, :locals => {:comments => comments}

    end
  end
end
