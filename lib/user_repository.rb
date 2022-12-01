require 'user'

class UserRepository

  # The hydrate method takes the user data from the chitter database and converts it into a User object
  def hydrate(user_record)
    user = User.new
    user.id = user_record['id'].to_i
    user.name = user_record['name']
    user.email = user_record['email']
    user.username = user_record['username']
    user.password = user_record['password']
    return user
  end

  # The all method returns an array of all User objects to be checked against by other methods
  def all
    sql = "SELECT * FROM users;"
    result_set = DatabaseConnection.exec_params(sql, [])
    users = result_set.map { |user| hydrate(user) }
  end

  # The register method vets a new users data and, if it checks out, adds them to the users database
  def register(user)
    p user.email
    return false if (user.name || user.email || user.username || user.password) == nil
    sql = "INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, $4);"
    params = [user.name, user.email, user.username, user.password]
    DatabaseConnection.exec_params(sql, params)
    return true
  end
end