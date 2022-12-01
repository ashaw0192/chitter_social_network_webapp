Users Model and Repository Classes Design Recipe

1. Design and create the Table

2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

-- EXAMPLE
-- (file: spec/users_seeds.sql)

3. Define the class names

# Table name: users

# Model class
# (in lib/user.rb)
class User
end

# Repository class
# (in lib/user_repository.rb)
class UserRepository
end

4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

# EXAMPLE
# Table name: students

# Model class
# (in lib/student.rb)

class User
  attr_accessor :id, :name, :email, :username, :password
end

5. Define the Repository Class interface

# Table name: users

# Repository class
# (in lib/user_repository.rb)

class UserRepository

  # Selecting all users
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT * FROM users;

    # Returns an array of User objects.
  end

  # Registers a new user
  # Five argument: name, email, username, password
  def register(name, email, username, password)
    # Executes the SQL query:
    # INSERT INTO users (name, email, username, password) VALUES ($1, $2, $3, $4);

    # Returns a success message.
  end

  # Login existing user
  # Two arguments: username, password
  def login(email, password)
    # Executes the SQL query
    # SELECT * FROM users WHERE email = $1 AND password = $2

    # Returns true
  end

  # Logout user
  # No arguments
  def logout
    returns false
  end
  
6. Write Test Examples

# 1
# Get all users

# 2
# Register a new user

# 3
# Login an unexisting user

# 4
# Login an existing user

# 5
# Login a new registered user

# 6
# Logout a user

7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

# EXAMPLE

# file: spec/student_repository_spec.rb

def reset_students_table
  seed_sql = File.read('spec/seeds_students.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'students' })
  connection.exec(seed_sql)
end

describe StudentRepository do
  before(:each) do 
    reset_students_table
  end

  # (your tests will go here).
end

8. Test-drive and implement the Repository class behaviour

After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour.