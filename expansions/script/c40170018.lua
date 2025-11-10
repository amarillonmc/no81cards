--巨神龙骑士 闪耀
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,1639384)
	--xyz summon
	aux.AddXyzProcedure(c,s.mfilter,8,2,s.ovfilter,aux.Stringid(id,0),99,s.xyzop)
	c:EnableReviveLimit()  
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.imcon)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(s.imcon)
	e2:SetValue(s.indval)
	c:RegisterEffect(e2)
	--todeck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(s.cost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
end
function s.mfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(1639384)
end
function s.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,is)==0 and Duel.IsPhase(PHASE_MAIN2) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:IsLevel(7,8) 
end
function s.imcon(e)
	return Duel.IsExistingMatchingCard(s.filter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function s.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function s.indval(e,c)
	return not c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function s.tdfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_DRAGON+RACE_WARRIOR) and c:IsAbleToDeck()
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.tdfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end