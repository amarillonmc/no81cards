--终梦的夜空
function c9910906.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x11e0)
	e1:SetCountLimit(1,9910906+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c9910906.condition)
	e1:SetTarget(c9910906.target)
	e1:SetOperation(c9910906.activate)
	c:RegisterEffect(e1)
end
function c9910906.spfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER)
end
function c9910906.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910906.spfilter,tp,LOCATION_REMOVED,0,nil)
	return g:GetClassCount(Card.GetCode)>2
end
function c9910906.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>0
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_REMOVED)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,g1:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,g2:GetCount(),0,0)
end
function c9910906.damfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_XYZ+TYPE_PENDULUM)
end
function c9910906.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetFieldGroup(tp,LOCATION_REMOVED,0)
	if #g1==0 or Duel.SendtoGrave(g1,REASON_EFFECT+REASON_RETURN)==0 then return end
	local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	if #g2==0 then return end
	Duel.BreakEffect()
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	local g3=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
	if #g3==0 then return end
	for sc in aux.Next(g3) do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
		e1:SetTarget(c9910906.distg)
		e1:SetLabelObject(sc)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_CHAIN_SOLVING)
		e2:SetCondition(c9910906.discon)
		e2:SetOperation(c9910906.disop)
		e2:SetLabelObject(sc)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(c9910906.distg)
		e3:SetLabelObject(sc)
		Duel.RegisterEffect(e3,tp)
		sc:RegisterFlagEffect(9910906,0,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910906,0))
	end
	local g4=g3:Filter(c9910906.damfilter,nil)
	if g4:GetClassCount(Card.GetCode)>2 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,#g3*500,REASON_EFFECT)
	end
end
function c9910906.distg(e,c)
	local tc=e:GetLabelObject()
	return c:IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910906.discon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return re:GetHandler():IsOriginalCodeRule(tc:GetOriginalCodeRule())
end
function c9910906.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
