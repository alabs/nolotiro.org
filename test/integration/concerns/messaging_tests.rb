# frozen_string_literal: true

require 'integration/concerns/messaging'
require 'integration/concerns/login_helper'

module MessagingTests
  include LoginHelper
  include Messaging

  def setup
    super

    @user1 = create(:user, username: 'user1')
    @user2 = create(:user, username: 'user2')

    login_as @user1

    visit new_conversation_path(recipient_id: @user2.id)

    accept_cookie_bar
  end

  def teardown
    super

    logout
  end

  def test_shows_errors_when_message_has_no_subject
    send_message(body: 'hola, user2')

    assert_text 'Título no puede estar en blanco'
  end

  def test_prevents_from_creating_conversation_with_empty_message
    send_message(subject: 'hola, user2')

    assert_text 'Nuevo mensaje privado para el usuario user2'
  end

  def test_shows_errors_when_replying_to_conversation_with_empty_message
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: '')

    # Check HTML5 validator is present since this driver understand it and does
    # not submit the form
    assert_selector :xpath, "//textarea[@required='required']"
  end

  def test_replies_to_conversation
    send_message(subject: 'hola, user2', body: 'How you doing?')
    send_message(body: 'hola, user1, nice to see you around')

    assert_message_sent 'nice to see you around'
  end

  def test_shows_the_other_user_in_the_conversation_header
    send_message(subject: 'Cosas', body: 'hola, user2')
    assert_text 'Conversación con user2'

    go_to_conversation_as(Conversation.first, @user2)
    assert_text 'Conversación con user1'
  end

  def test_links_to_the_other_user_in_the_conversation_list
    send_message(subject: 'Cosas', body: 'hola, user2')
    visit conversations_path

    assert_link 'user2'
  end

  def test_does_not_show_conversations_with_banned_users
    send_message(subject: 'Cosas', body: 'Send me info to myemail@example.org')
    @user2.ban!
    visit conversations_path

    assert_no_link 'user2'
  end

  def test_just_shows_a_special_label_when_the_recipient_is_no_longer_there
    send_message(subject: 'Cosas', body: 'hola, user2')
    assert_message_sent 'hola, user2'

    @user2.destroy

    assert_shows_special_label_for_deleted_user
  end

  def test_just_shows_a_special_label_when_the_sender_is_no_longer_there
    send_message(subject: 'Cosas', body: 'hola, user2')
    assert_message_sent 'hola, user2'

    @user1.destroy
    go_to_conversation_as(Conversation.last, @user2)

    assert_shows_special_label_for_deleted_user
  end

  def test_messages_another_user
    send_message(subject: 'hola mundo', body: 'hola trololo')

    assert_message_sent 'hola trololo'
  end

  def test_deletes_a_single_conversation_and_shows_a_confirmation_flash
    send_message(subject: 'hola mundo', body: 'What a nice message!')
    click_link 'Borrar conversación'

    assert_no_text 'hola mundo'
    assert_text 'Conversación borrada'
  end

  def test_deletes_multiple_conversations_by_checkbox
    send_message(subject: 'hola mundo', body: 'What a nice message!')
    visit new_conversation_path(recipient_id: @user2.id)
    send_message(subject: 'hola marte', body: 'What a nice message!')

    visit conversations_path
    check("delete-conversation-#{Conversation.first.id}")
    click_button 'Borrar conversaciones seleccionadas'

    assert_no_text 'hola mundo'
    assert_text 'hola marte'
  end

  def test_does_not_revive_deleted_conversation_when_the_other_user_replies
    send_message(subject: 'hola mundo', body: 'What a nice message!')
    click_link 'Borrar conversación'
    assert_no_text 'hola mundo'

    go_to_conversation_as(Conversation.first, @user2)
    send_message(body: 'hombre, tú por aquí')

    go_to_conversation_as(Conversation.first, @user1)
    assert_no_text 'What a nice message!'
  end

  def test_include_links_in_messages_only_for_admins
    send_message(subject: 'hi! <3', body: 'See the FAQs at https://faqs.org')
    assert_no_link 'https://faqs.org'

    @user1.update!(role: 1)

    visit new_conversation_path(recipient_id: @user2.id)
    send_message(subject: 'hi! <3', body: 'See the FAQs at https://faqs.org')
    assert_link 'https://faqs.org'
  end
end
