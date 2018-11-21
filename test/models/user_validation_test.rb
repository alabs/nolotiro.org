# frozen_string_literal: true

require "test_helper"

class UserValidationTest < ActiveSupport::TestCase
  it "has unique usernames" do
    user1 = build(:user, username: "Username")
    assert user1.save

    user2 = build(:user, username: "Username")
    assert_not user2.save
    assert_includes user2.errors[:username], "ya está en uso"
  end

  it "has unique case insensitive usernames" do
    user1 = build(:user, username: "Username")
    assert user1.save

    user2 = build(:user, username: "username")
    assert_not user2.save
    assert_includes user2.errors[:username], "ya está en uso"
  end

  it "disallows usernames that look like emails" do
    user = build(:user, username: "larryfoster@example.com")

    assert_not user.valid?
    assert_includes user.errors[:username], "no es válido"
  end

  it "disallows usernames that look like ids" do
    user1 = build(:user, username: "007")
    assert user1.valid?

    user2 = build(:user, username: "12345")
    assert_not user2.valid?
    assert_includes user2.errors[:username], "no es válido"
  end

  it "disallows usernames containing URL separator character" do
    user = build(:user, username: "elena/mario")
    assert_not user.valid?
  end

  it "has unique emails" do
    user1 = build(:user, email: "larryfoster@example.com")
    assert user1.save

    user2 = build(:user, email: "larryfoster@example.com")
    assert_not user2.save
    assert_includes user2.errors[:email], "ya está en uso"
  end

  it "saves downcased emails" do
    user1 = build(:user, email: "Larryfoster@example.com")
    assert user1.save
    assert_equal "larryfoster@example.com", user1.email
  end

  it "has passwords no shorter than 5 characters" do
    user1 = build(:user, password: "1234")
    assert_not user1.valid?
    assert_includes user1.errors[:password],
                    "es demasiado corto (5 caracteres mínimo)"

    user2 = build(:user, password: "12345")
    assert user2.valid?
  end

  it "has non-empty usernames" do
    user1 = build(:user, username: "")
    assert_not user1.valid?
    assert_includes user1.errors[:username], "no puede estar en blanco"
  end

  it "has usernames no longer than 63 characters" do
    user1 = build(:user, username: "A" * 63)
    assert user1.valid?

    user2 = build(:user, username: "A" * 64)
    assert_not user2.valid?
    assert_includes user2.errors[:username],
                    "es demasiado largo (63 caracteres máximo)"
  end

  it "requires acceptance of new terms" do
    user1 = build(:user, terms: true)
    assert_equal true, user1.valid?

    user2 = build(:user, terms: false)
    assert_equal false, user2.valid?
    assert_includes user2.errors[:terms], "debe ser aceptado"
  end

end
