# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#

mando = User.create(name: 'mando', email: 'mando@bountyhunters.com', password: 'TheKid=Great', password_confirmation: 'TheKid=Great')
greef = User.create(name: 'greef', email: 'greef@bountyhunters.com', password: '12345678', password_confirmation: '12345678')
pershing = User.create(name: 'pershing', email: 'pershing@navarro.edu', password: '12345678', password_confirmation: '12345678')

MoneyTransaction.create(creditor: greef, debitor: mando, amount: 10.50)
MoneyTransaction.create(creditor: mando, debitor: greef, amount: 1000, paid_at: '2220-01-01 15:30')
