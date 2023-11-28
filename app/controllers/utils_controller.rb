# frozen_string_literal: true

# j1: "東", j2: "南", j3: "西", j4: "北"
# z1: "白", z2: "發", z3: "中"
# その他の機能
class UtilsController < ApplicationController
  def agari
    # TODO: 符の計算する用の上がり手を返す処理を実装する
    # TODO: mentsuに鳴きかどうかのフラグが必要だ...
    render json:
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

  # 参考サイト: https://majandofu.com/fu-calculation
  # http://localhost:4000/calc_fu?mentsu=[["p1", "p1", "p1"],["p1", "p2", "p3"],["s2", "s2", "s2"],["s1", "s2", "s3"]]&janto=["j1","j1"]&machj_type=tanki&agari_type=tsumo&menzen=true&kaze="j1"
  def calc_fu
    render json: { fu: 20 } if agari_type_pinfu_tsumo?
    render json: { fu: 25 } if agari_type_ci_toitsu?

    # (1) 副底（フーテイ）＝基本符
    fu = 20

    # (2) 門前加符（メンゼンカフ）と ツモ符（ツモフ）か？
    fu += calc_tsumo

    # (3) 各面子（メンツ）の種類による 加符点
    fu += calc_mentsus(JSON.parse(@params['mentsu']))

    # 4) 雀頭（ジャントウ＝アタマ） の種類による 加符点
    fu += calc_janto(JSON.parse(@params['janto']))

    # (5) 待ち の種類による 加符点
    fu += calc_machi

    # 符 は10単位で切り上げる
    fu = (fu / 10.0).ceil * 10

    render json: { fu: fu }
  end

  private

  # 符の計算系
  def calc_tsumo
    return 10 if ron? && menzen?
    return 2 if tsumo?

    0
  end

  def calc_mentsus(mentsus)
    fu = 0
    mentsus.to_a.each do |mentsu|
      fu += calc_mentsu(mentsu)
    end
    fu
  end

  def calc_mentsu(mentsu)
    return 0  if syuntu?(mentsu)

    # 条件列挙型
    return 32 if yaochu?(mentsu)   && kantsu?(mentsu) && menzen?
    return 16 if yaochu?(mentsu)   && kantsu?(mentsu) && !menzen?
    return 8  if yaochu?(mentsu)   && kotsu?(mentsu)  && menzen?
    return 4  if yaochu?(mentsu)   && kotsu?(mentsu)  && !menzen?
    return 16 if chunchan?(mentsu) && kantsu?(mentsu) && menzen?
    return 8  if chunchan?(mentsu) && kantsu?(mentsu) && !menzen?
    return 4  if chunchan?(mentsu) && kotsu?(mentsu)  && menzen?
    return 2  if chunchan?(mentsu) && kotsu?(mentsu)  && !menzen?

    0
    # # マトリクス型（槓子、幺九牌、面前）
    # matrix = [
    #   [[2, 4], [8, 16]]
    #   [[4, 8], [16, 32]]
    # ]
    # matrix[0][0][1]

    # # 数式型
    # fu = 2
    # fu *= 2 if yaochu?(mentsu)
    # fu *= 4 if kantsu?(mentsu)
    # fu *= 2 if menzen?
    # fu
  end

  def calc_janto(janto)
    return 2 if yakuhai?(janto)

    0
  end

  def calc_machi
    return 2 if machi_type_penchan?
    return 2 if machi_type_kanchan?
    return 2 if machi_type_tanki?
    return 2 if machi_type_nobetan?

    0
  end

  # 判定のメソッド
  def menzen?
    @params['menzen'] == 'true'
  end

  def chunchan?(mentsu)
    (2..8).include?(mentsu[0].slice(1).to_i) \
    && (2..8).include?(mentsu[1].slice(1).to_i) \
    && (2..8).include?(mentsu[2].slice(1).to_i)
  end

  def yaochu?(mentsu)
    return true if 

    [1, 9].include?(mentsu[0].slice(1).to_i) \
    && [1, 9].include?(mentsu[1].slice(1).to_i) \
    && [1, 9].include?(mentsu[2].slice(1).to_i)
  end

  def syuntu?(mentsu)
    mentsu.uniq.length != 1
  end

  def kotsu?(mentsu)
    mentsu.size == 3
  end

  def kantsu?(mentsu)
    mentsu.size == 4
  end

  def yakuhai?(mentsu)
    return false if syuntu?(mentsu)
    return false if otakaze?(mentsu)

    true
  end

  def otakaze?(mentsu)
    return false if syuntu?(mentsu)

    mentsu[0] != @params['kaze']
  end

  def include_zihai?(mentsu)
    # TODO: kantsuの場合の対応を後で実装する
    %w[j z].include?(mentsu[0].slice(0).to_s) \
    && %w[j z].include?(mentsu[1].slice(0).to_s) \
    && %w[j z].include?(mentsu[2].slice(0).to_s)
  end

  # 上がり方に関する判定
  def agari_type_pinfu_tsumo?
    # TODO: 平和の判定処理を入れる。
    @params['agari_type'] == 'pinfu_tsumo'
  end

  def agari_type_ci_toitsu?
    # TODO: 七対子の判定処理を入れる
    @params['agari_type'] == 'ci_toitsu'
  end

  def tsumo?
    @params['agari_type'] == 'tsumo'
  end

  def ron?
    @params['agari_type'] == 'ron'
  end

  # 待ち方に関する判定
  def machi_type_penchan?
    @params['machi_type'] == 'penchan'
  end

  def machi_type_kanchan?
    @params['machi_type'] == 'kanchan'
  end

  def machi_type_tanki?
    @params['machi_type'] == 'tanki'
  end

  def machi_type_nobetan?
    @params['machi_type'] == 'nobetan'
  end
end