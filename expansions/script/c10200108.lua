--幻叙·灭世之邪龙 LV12
function c10200108.initial_effect(c)
    c:EnableReviveLimit()
    -- 不能通常召唤
    local e0=Effect.CreateEffect(c)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_SPSUMMON_CONDITION)
    e0:SetValue(aux.FALSE)
    c:RegisterEffect(e0)
    -- 胜利
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(10200108,0))
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetCondition(c10200108.wincon)
    e1:SetOperation(c10200108.winop)
    c:RegisterEffect(e1)
end
c10200108.lvdn={10200107}
-- 1
function c10200108.wincon(e,tp,eg,ep,ev,re,r,rp)
    return re and re:GetHandler():IsCode(10200107)
end
function c10200108.winop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Win(tp,0xe24)
end
