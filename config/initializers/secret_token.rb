# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Ssm::Application.config.secret_key_base = 'b029e74968433350616eb491280c972ee768ee2c102430f32e501fa55d8e22b4c5bd2d0a39006101a9f56fdcd204cef7664d8b0688485b1d93ebbcb669a9cc56'
