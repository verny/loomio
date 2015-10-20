class Network < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :network_coordinators
  has_many :network_memberships
  has_many :coordinators, through: :network_coordinators
  has_many :groups, through: :network_memberships
  has_many :membership_requests, class_name: "NetworkMembershipRequest"
end