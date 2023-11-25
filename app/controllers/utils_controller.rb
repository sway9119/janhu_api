# frozen_string_literal: true

# その他の機能
class UtilsController < ApplicationController
  def agari
    render json:
    {
      mentsu: [
        ['p1', 'p1', 'p1'],
        ['p1', 'p2', 'p3'],
        ['s1', 's1', 's1'],
        ['s1', 's2', 's3'],
        ['s1', 's2', 's3'],
      ],
      janto: ['j1','j1'],
      agari_type: 'tanki'
    }
  end
end
