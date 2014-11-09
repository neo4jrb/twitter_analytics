require 'thor/rails'

class Neo4j < Thor
  include Thor::Rails

  desc "clear_database", "Clear out the current neo4j database"
  def clear_database
    if yes?('Are you really, really, REALLY sure you want to delete all the data in your database?')
      say "Clearing..."
      ::Neo4j::Session.current.query('MATCH (n) OPTIONAL MATCH (n)-[r]-() DELETE n,r')
      say "Cleared!"
    end
  end
end
