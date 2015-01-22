class VideoModel < ActiveRecord::Base

  has_many :videos

  def collection_name
    return self.manufacture + ' - ' + self.model
  end
end
