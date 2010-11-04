require 'rubygems'
require 'json'
require 'open-uri'
require 'mash'

module GitHub
  VERSION = "0.0.3"
  class API
    @base_url = ""
    def initialize(options = {"use_ssl" => false})
      @base_url = (options["use_ssl"]) ? "https://github.com/api/v1/json" : "http://github.com/api/v1/json"
    end
    
    # Fetches information about the specified user name.
    def user(user, use_ssl=false)      
      url = @base_url + "/#{user}"
      GitHub::User.new(JSON.parse(open(url).read)["user"])
    end
  
    # Fetches the commits for a given repository.
    def commits(user,repository,branch="master")
      url = @base_url + "/#{user}/#{repository}/commits/#{branch}"
      JSON.parse(open(url).read)["commits"].collect{ |c| 
        GitHub::Commit.new(c.merge(:user => user, :repository => repository))
      }
    end
  
    # Fetches a single commit for a repository.
    def commit(user,repository,commit)
      url = @base_url + "/#{user}/#{repository}/commit/#{commit}"
      GitHub::Commit.new(JSON.parse(open(url).read).merge(:user => user, :repository => repository))
    end
  end
  
  class Repository < Mash
    def commits
      ::GitHub::API.commits(user,name)
    end
  end
  
  class User < Mash
    def initialize(hash = nil)
      @user = hash["login"] if hash
      super
    end
    
    def repositories=(repo_array)
      puts self.inspect
      self["repositories"] = repo_array.collect{|r| ::GitHub::Repository.new(r.merge(:user => login || @user))}
    end
  end
  
  class Commit < Mash
    # if a method only available to a detailed commit is called,
    # automatically fetch it from the API
    def detailed
      ::GitHub::API.new.commit(user,repository,id)
    end
  end
end