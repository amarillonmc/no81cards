local m = 11223436  
local cm = _G["c"..m]
cm.name = "歧义斗神 月浊"

function cm.initial_effect(c)
    -- 苏生限制
    c:EnableReviveLimit()
    -- 超量召唤的注册
    aux.AddXyzProcedure(c, nil, 8, 2, cm.ovfilter, aux.Stringid(m, 0))

    -- 原本攻击力设定
    c:SetBaseAttack(500)

    -- 丢弃特定手牌进行特殊超量召唤的效果
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(cm.summoncondition)
    e1:SetOperation(cm.summonoperation)
    Duel.RegisterEffect(e1, 0)
end

function cm.ovfilter(c)
    return c:IsFaceup() and (c:IsCode(11223401) or c:IsCode(11223405))
end

function cm.summoncondition(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    local tc = eg:GetFirst()
    return tc:GetSummonType() == SUMMON_TYPE_XYZ and tc == c and Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0) > 0 and Duel.IsExistingMatchingCard(aux.TRUE, tp, LOCATION_HAND, 0, 1, nil, Card.IsCode, 11223425)
end

function cm.summonoperation(e, tp, eg, ep, ev, re, r, rp)
    Duel.DiscardHand(tp, aux.TRUE, 1, 1, REASON_COST, Card.IsCode, 11223425)
end
