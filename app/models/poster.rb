class Poster < ActiveRecord::Base
  has_and_belongs_to_many :categories 
  belongs_to :user

  mount_uploader :ref_imagem, PosterImageUploader
  
  def self.filter(term: nil, category: nil)
    query = self
    if term
      query = QueryUtils.where_attr_like(query, QueryUtils.concatenate_attrs(:description, :title), term)
    end
    if category
      query = query.joins(:categories).where(categories_posters: {category_id: category})
    end
    query
  end

  def have_image?(type)
    @poster.ref_imagem &&
      @poster.ref_imagem.public_send(type.to_sym) &&
      @poster.ref_imagem.public_send(type.to_sym).url
  end
end
