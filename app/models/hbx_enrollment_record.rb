class HbxEnrollmentRecord
  include Mongoid::Document

  field :hbx_enrollment_id, type: String
  field :hbx_enrollment, type: Hash

  index({hbx_enrollment_id: 1}, {unique: true})
end
