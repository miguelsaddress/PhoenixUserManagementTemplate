# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ShoppingList.Repo.insert!(%ShoppingList.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias ShoppingList.Accounts.{User, Role}
alias ShoppingList.Repo

Repo.insert!(%Role{
  id: 1,
  name: "Admin",
})

Repo.insert!(%Role{
  id: 2,
  name: "User",
})

Repo.insert!(%User{
    name: "user1",
    email: "user1@example.org",
    google_token: "a token",
    image: "https://lh6.googleusercontent.com/-_5vNjEQxgrg/AAAAAAAAAAI/AAAAAAAAALI/-gMH61h2TRY/photo.jpg",
    role_id: 1
})

Repo.insert!(%User{
    name: "user2",
    email: "user2@example.org",
    google_token: "a token",
    image: "https://lh6.googleusercontent.com/-_5vNjEQxgrg/AAAAAAAAAAI/AAAAAAAAALI/-gMH61h2TRY/photo.jpg",
    role_id: 1
})

Repo.insert!(%User{
    email: "the.address@example.org",
    google_token: "a token",
    image: "https://lh6.googleusercontent.com/-_5vNjEQxgrg/AAAAAAAAAAI/AAAAAAAAALI/-gMH61h2TRY/photo.jpg",
    role_id: 2
})
