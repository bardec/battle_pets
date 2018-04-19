class ContestSerializerSerializer < ActiveModel::Serializer
  attribute :contest_type, key: :type 
  attributes :id, 
    :first_competitor, 
    :second_competitor,
    :winner,
    :status,
    :completed_at

end
