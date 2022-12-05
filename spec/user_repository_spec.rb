require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds/chitter_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'chitter_test' })
  connection.exec(seed_sql)
end

RSpec.describe UserRepository do
  before(:each) do 
    reset_users_table
  end

  context "when all is called" do
    it "returns all users as an array of User objects" do
      repo = UserRepository.new
      users = repo.all
      expect(users.length).to eq 3
      expect(users[0].id).to eq 1
      expect(users[0].name).to eq 'User One'
      expect(users[0].email).to eq 'one@one.com'
      expect(users[0].username).to eq 'one1'
      expect(users[1].id).to eq 2
      expect(users[1].name).to eq 'User Two'
      expect(users[1].email).to eq 'two@two.com'
      expect(users[1].username).to eq 'two2'
    end
  end

  context "when register is called with correct arguments and unique username and email" do
    it "returns true and adds the user to the users table" do
      user = User.new
      user.name = 'User Four'
      user.email = 'four@four.com'
      user.username = 'four4'
      user.password = 'password4'
      repo = UserRepository.new
      expect(repo.register(user)).to eq true
      users = repo.all
      expect(users.length).to eq 4
      expect(users[-1].id).to eq 4
      expect(users[-1].name).to eq 'User Four'
      expect(users[-1].email).to eq 'four@four.com'
      expect(users[-1].username).to eq 'four4'
    end
  end

  context "when register is called but not all fields are complete" do
    it "fails" do
      user1 = User.new
      user1.name = 'User Four'
      user1.username = 'four4'
      user1.password = 'password4'
      user2 = User.new
      user2.name = 'User Four'
      user2.email = 'four@four.com'
      user2.password = 'password4'
      repo = UserRepository.new
      expect{ repo.register(user1) }.to raise_error "Field required"
      expect{ repo.register(user2) }.to raise_error "Field required"
    end
  end

  context "when register is called but username already exists" do
    it "fails" do
      user = User.new
      user.name = 'User One'
      user.username = 'one1'
      user.email = 'two@one.com'
      user.password = 'password1'
      repo = UserRepository.new
      expect{ repo.register(user) }.to raise_error "Email or username already exists"
    end
  end

  context "when register is called but email already exists" do
    it "fails" do
      user1 = User.new
      user1.name = 'User One'
      user1.username = 'one2'
      user1.email = 'one@one.com'
      user1.password = 'password1'
      repo = UserRepository.new
      expect{ repo.register(user1) }.to raise_error "Email or username already exists"
    end
  end

  context "when register is called and both email and username already exist" do
    it "fails" do
      user2 = User.new
      user2.name = 'User One'
      user2.username = 'one1'
      user2.email = 'one@one.com'
      user2.password = 'password1'
      repo = UserRepository.new
      expect{ repo.register(user2) }.to raise_error "Email or username already exists"
    end
  end

  context "when register is called and username and email are already taken by 2 seperate users" do
    it "fails" do
      user3 = User.new
      user3.name = 'User One'
      user3.username = 'one1'
      user3.email = 'two@two.com'
      user3.password = 'password1'
      repo = UserRepository.new
      expect{ repo.register(user3) }.to raise_error "Email or username already exists"
    end
  end

  context "when login is called and details correct" do
    it "returns the users id" do
      repo = UserRepository.new
      expect(repo.login('one@one.com', 'password1')).to eq 1
      expect(repo.login('two@two.com', 'password2')).to eq 2
    end
  end

  context "when login is called and email doesn't exist" do
    it "raises error" do
      repo = UserRepository.new
      expect{ repo.login('one@two.com', 'password1') }.to raise_error "No such email"
    end
  end
end