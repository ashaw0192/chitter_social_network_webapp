## Chitter Tables Design Recipe

1. Extract nouns from the user stories or specification

STRAIGHT UP

As a Maker
So that I can let people know what I am doing  
I want to post a message (peep) to chitter

As a maker
So that I can see what others are saying  
I want to see all peeps in reverse chronological order

As a Maker
So that I can better appreciate the context of a peep
I want to see the time at which it was made

As a Maker
So that I can post messages on Chitter as me
I want to sign up for Chitter

HARDER

As a Maker
So that only I can post messages on Chitter as me
I want to log in to Chitter

As a Maker
So that I can avoid others posting messages on Chitter as me
I want to log out of Chitter

ADVANCED

As a Maker
So that I can stay constantly tapped in to the shouty box of Chitter
I want to receive an email if I am tagged in a Peep

Nouns: Peep, Time, Content, Name, Email, Username, Password

2. Infer the Table Name and Columns

Record - Properties
Chitter Users - name, username, email, password	
Peeps - Content, Time, user_id

Name of the first table (always plural): users

Column names: name, email, username, password

Name of the second table (always plural): peeps

Column names: content, time, user_id

3. Decide the column types.

Table: users
id: SERIAL
name: text
email: text
username: text
password: text

Table: peeps
id: SERIAL
content: text
time: timestamp
user_id: int

4. Decide on The Tables Relationship

[user] has many [peeps]
And on the other side, [peep] belongs to [users]
In that case, the foreign key is in the table [peeps]

4. Write the SQL.

-- file: seeds/chitter_tables.sql

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name text,
  email text,
  username text,
  password text
);

CREATE TABLE peeps (
  id SERIAL PRIMARY KEY,
  content text,
  time timestamp,
  user_id int,
  constraint fk_user foreign key(user_id)
    references users(id)
    on delete cascade
);

5. Create the tables.

psql -h 127.0.0.1 database_name < albums_table.sql