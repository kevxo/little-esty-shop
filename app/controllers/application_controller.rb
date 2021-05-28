class ApplicationController < ActionController::Base
  before_action :repo_name, :collaborators

  def repo_name
    repo = Faraday.get('https://api.github.com/repos/kevxo/little-esty-shop') do |req|
      req.headers['Authorization'] = ENV['Auth']
    end

    @repo_name = JSON.parse(repo.body, symbolize_names: true)[:name]
  end

  def collaborators
    repo = Faraday.get('https://api.github.com/repos/kevxo/little-esty-shop/contributors') do |req|
      req.headers['Authorization'] = ENV['Auth']
    end

    data = JSON.parse(repo.body, symbolize_names: true)

    @collaborators = data.map do |user|
      user[:login]
    end.join(', ')
  end
end
