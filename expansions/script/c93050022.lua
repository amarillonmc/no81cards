--幻叙-绝断终末
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(id)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,s.ovfilter,aux.Stringid(id,0))
	c:EnableReviveLimit()
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.chcon)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
	--atk/def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SET_BASE_ATTACK)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_BASE_DEFENSE)
	e3:SetValue(s.defval)
	c:RegisterEffect(e3)
end
function s.ovfilter(c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetAttribute)>=6
end
function s.filter(c)
	return c:IsSetCard(0x838) and c:IsType(TYPE_MONSTER)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)&LOCATION_ONFIELD~=0
		and not re:GetHandler():IsLocation(LOCATION_OVERLAY+LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	return Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local c=e:GetHandler()
	if c and c:IsRelateToEffect(e) and not e:GetHandler():IsLocation(LOCATION_OVERLAY+LOCATION_GRAVE+LOCATION_REMOVED) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function s.atkval(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetAttribute)*1000
end
function s.defval(e,c)
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	return g:GetClassCount(Card.GetAttribute)*1000
end
