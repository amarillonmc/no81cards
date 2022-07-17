--ブルーアイズ・カオス・MAX・ドラゴン
--Blue-Eyes Chaos MAX Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    --spsummon
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_SINGLE)
    e0:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    c:RegisterEffect(e0)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.indval)
	c:RegisterEffect(e3)
    
    local e13=Effect.CreateEffect(c)
    e13:SetDescription(aux.Stringid(id,1))
    e13:SetType(EFFECT_TYPE_QUICK_O)
    e13:SetCode(EVENT_FREE_CHAIN)
    e13:SetRange(LOCATION_MZONE)
    e13:SetCountLimit(1,id,EFFECT_COUNT_CODE_DUEL)
	e13:SetCost(s.cost1)
    e13:SetTarget(s.tg)
    e13:SetOperation(s.op)
    c:RegisterEffect(e13)	
end
s.listed_names={21082832}
function s.chlimit(e,ep,tp)
    return tp==ep
end
function s.indval(e,re,tp)
	return tp~=e:GetHandlerPlayer()
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,4000) end
	Duel.PayLPCost(tp,4000)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,1,nil) end
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,sg:GetCount(),0,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD)
	Duel.SetChainLimit(s.chlimit)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
    local sg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	local ct=Duel.Remove(sg,POS_FACEDOWN,REASON_RULE)
	Duel.Damage(1-tp,ct*300,REASON_EFFECT)
end