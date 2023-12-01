# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "home#index"

  get 'agari', to: 'utils#agari'

  tehai = '(/:mentsu)(/:janto)(/:agari_type)(/:menzen)/'
  get "calc_fu#{tehai}",
  # constraints: { mentsu: /\d+/, janto: /\d+/, agari_type: /[a-z]+/, menzen /[true|false]/ },
  to: 'fus#calc_fu',
  as: 'calc_fu'
end
