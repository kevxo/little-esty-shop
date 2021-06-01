class ApplicationController < ActionController::Base
  before_action :repo_name, :collaborators, :commits, :pull_requests

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

  def commits(author_commits = {})
    repo = Faraday.get('https://api.github.com/repos/kevxo/little-esty-shop/stats/contributors') do |req|
      req.headers['Authorization'] = ENV['Auth']
    end

    data = JSON.parse(repo.body, symbolize_names: true)

    author_com_hash(author_commits, data)

    @commits = author_commits.sort { |a, b| b[1] <=> a[1] }
  end

  def author_com_hash(author_commits, data)
    data.each do |info|
      author = info[:author][:login]
      commit_total = info[:total]

      author_commits[author] = commit_total
    end
  end

  def pull_requests
    repo = Faraday.get('https://api.github.com/repos/kevxo/little-esty-shop/pulls') do |req|
      req.headers['Authorization'] = ENV['Auth']
      req.params['state'] = 'closed'
    end

    data = JSON.parse(repo.body, symbolize_names: true)

    @count = data.length
  end
end
