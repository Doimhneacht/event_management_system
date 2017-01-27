class EventSerializer < ActiveModel::Serializer
  attributes :id, :time, :place, :purpose, :owner
end
