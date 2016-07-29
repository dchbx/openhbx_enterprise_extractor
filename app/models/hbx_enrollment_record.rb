class HbxEnrollmentRecord
  include Mongoid::Document

  field :hbx_enrollment_id, type: String
  field :hbx_enrollment, type: Hash

  index({hbx_enrollment_id: 1}, {unique: true})


  def self.store(hbx_enrollment_id, data)
    existing_record = self.where(:hbx_enrollment_id => hbx_enrollment_id).first
    if existing_record
      existing_record.update_attributes!(
        :hbx_enrollment => data
      )
    else
      self.create!(
        :hbx_enrollment_id => hbx_enrollment_id,
        :hbx_enrollment => data
      )
    end
  end
end
