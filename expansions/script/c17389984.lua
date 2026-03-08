local s,id=GetID()
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end

function s.ctfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5f51) and c:IsControlerCanBeChanged()
end

function s.desfilter(c)
	return not c:IsSetCard(0x5f51) and c:IsType(TYPE_MONSTER) and c:IsDestructable()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.ctfilter,tp,0,LOCATION_MZONE,1,nil) end	
	local g1=Duel.GetMatchingGroup(s.ctfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,#g1,0,0)
	local g2=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,#g2,0,0)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.ctfilter,tp,0,LOCATION_MZONE,nil)
	if #g1>0 then
		local res=Duel.GetControl(g1,tp)
		if res~=0 then
			Duel.BreakEffect()
		end
	end
	local g2=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if #g2>0 then
		Duel.Destroy(g2,REASON_EFFECT)
	end
end