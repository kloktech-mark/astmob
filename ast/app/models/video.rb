class Video < AstBase

  acts_as_solr :include => [:video_model]

  belongs_to :video_model

end
