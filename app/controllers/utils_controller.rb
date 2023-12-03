# frozen_string_literal: true

# j1: "東", j2: "南", j3: "西", j4: "北"
# z1: "白", z2: "發", z3: "中"
# その他の機能
class UtilsController < ApplicationController
  def agari
    result = constract_mentsu
    # TODO: mentsuに鳴きかどうかのフラグが必要だ...
    render json: result
  end

  private

  def constract_mentsu
    {
      mentsu: [
        ["p1", "p1", "p1"],
        ["p1", "p2", "p3"],
        ["s2", "s2", "s2"],
        ["s1", "s2", "s3"],
      ],
      janto: ["j1","j1"],
      machj_type: "tanki",
      agari_type: "tsumo",
      menzen: true,
      kaze: "j1"
    }
  end
end
