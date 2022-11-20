--连锁的落穴
function c10174019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10174019.condition)
	e1:SetTarget(c10174019.target)
	e1:SetOperation(c10174019.activate)
	c:RegisterEffect(e1)
end
function c10174019.cfilter(c,tp,zone)
	local seq=c:GetSequence()
	if c:IsLocation(LOCATION_MZONE) then
		if c:IsControler(1-tp) then seq=seq+16 end
	else
		seq=c:GetPreviousSequence()
		if c:GetPreviousControler()==1-tp then seq=seq+16 end
	end
	return bit.extract(zone,seq)~=0
end
function c10174019.lkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_LINK)
end
function c10174019.condition(e,tp,eg,ep,ev,re,r,rp)
	local zone=0
	local lg=Duel.GetMatchingGroup(c10174019.lkfilter,tp,0,LOCATION_MZONE,nil)
	for tc in aux.Next(lg) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return eg:IsExists(c10174019.cfilter,1,nil,tp,zone)
end
function c10174019.filter(c)
	return c:GetMutualLinkedGroupCount()>0
end
function c10174019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c10174019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c10174019.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c10174019.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
