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
    # Checking for empty fields
    raise "Field required" if user.name == nil || user.email == nil || user.username == nil || user.password == nil
    # Checking for duplicates
    sql1 = "SELECT * FROM users WHERE email = $1 OR username = $2;"
    params1 = [user.email, user.username]
    duplicate = DatabaseConnection.exec_params(sql1, params1)
    raise "Email or username already exists" if duplicate.ntuples > 0
    # Inserting if previous checks pass
    sql2 = "INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, crypt($4, gen_salt('bf')));"
    params2 = [user.name, user.email, user.username, user.password]
    DatabaseConnection.exec_params(sql2, params2)
    return true
  end

  # Login fiorst checks for a valid email, and then retrives encrtypted password and checks against it, 
  # returning the account owner's ID
  def login(email, password)
    sql = "SELECT password FROM users WHERE email = $1;"
    params = [email]
    password_to_check = DatabaseConnection.exec_params(sql, params)
    raise "No such email" if password_to_check.ntuples == 0
    sql1 = "SELECT id FROM users WHERE email = $1 AND password =crypt($2, $3);"
    params1 = [email, password, password_to_check[0]['password']]
    result = DatabaseConnection.exec_params(sql1, params1)
    raise "Incorrect password" if result.ntuples == 0
    result[0]['id'].to_i
  end
end