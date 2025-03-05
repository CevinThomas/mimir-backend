class Folder < ApplicationRecord
  belongs_to :parent, class_name: 'Folder', optional: true
  belongs_to :user, optional: true
  belongs_to :account, optional: true
  has_many :children, class_name: 'Folder', foreign_key: 'parent_id', dependent: :nullify
end
