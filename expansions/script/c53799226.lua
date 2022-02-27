local m=53799226
local cm=_G["c"..m]
cm.name="晴空万里 RU"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(cm.tg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.tg)
	c:RegisterEffect(e3)
end
function cm.spfilter(c)
	return c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.spcon(e,c)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,nil)
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and #g>0 and #g==g:FilterCount(Card.IsAbleToGraveAsCost,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.tg(e,c)
	return c~=e:GetHandler() and c:GetOriginalType()&(TYPE_SPELL+TYPE_TRAP)~=0 and c:IsStatus(STATUS_EFFECT_ENABLED)
end
