--神威骑士堡左护炮（未解限）
function c24501076.initial_effect(c)
	-- Activate
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e0)
    -- 卡组检索
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(24501076,0))
    e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_SZONE)
    e1:SetCountLimit(1,24501076)
    e1:SetCondition(c24501076.con1)
    e1:SetTarget(c24501076.tg1)
    e1:SetOperation(c24501076.op1)
    c:RegisterEffect(e1)
    -- 效果伤害
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(24501076,1))
    e2:SetCategory(CATEGORY_DAMAGE)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_SZONE)
    e2:SetCountLimit(1,24501077)
    e2:SetCondition(c24501076.con2)
    e2:SetTarget(c24501076.tg2)
    e2:SetOperation(c24501076.op2)
    c:RegisterEffect(e2)
end
-- 1
function c24501076.con1(e,tp)
    return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c24501076.filter1(c)
    return c:IsSetCard(0x501) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c24501076.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c24501076.filter1,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
end
function c24501076.op1(e,tp)
    local g=Duel.SelectMatchingCard(tp,c24501076.filter1,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
        local dg=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,0,1,1,nil)
        Duel.Destroy(dg,REASON_EFFECT)
    end
end
-- 2
function c24501076.filter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x501) and c:IsControler(tp)
end
function c24501076.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c24501076.filter2,1,nil,tp)
end
function c24501076.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c24501076.op2(e,tp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end
