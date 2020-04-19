class Item < ApplicationRecord
  belongs_to :list
  enum visibility: [:everyone, :coordinator]
end
