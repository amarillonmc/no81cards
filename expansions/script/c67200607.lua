--征冥天的监视者
function c67200607.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--revive limit
	aux.EnableReviveLimitPendulumSummonable(c,LOCATION_HAND)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.ritlimit)
	c:RegisterEffect(e0)
	--change scale
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200607,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,67200607)
	e1:SetCost(c67200607.sscost)
	e1:SetTarget(c67200607.sstg)
	e1:SetOperation(c67200607.ssop)
	c:RegisterEffect(e1)  
	--disable effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c67200607.disop)
	c:RegisterEffect(e2)
	--become material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c67200607.condition)
	e3:SetOperation(c67200607.operation)
	c:RegisterEffect(e3)   
end
function c67200607.scfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x677)
end
function c67200607.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c67200607.scfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(67200607,2))
	local g=Duel.SelectMatchingCard(tp,c67200607.scfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.SendtoExtraP(tc,tp,REASON_COST)
end
function c67200607.setfilter(c)
	return c:IsSetCard(0x677) and bit.band(c:GetType(),0x82)==0x82 and c:IsSSetable()
end
function c67200607.sstg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c67200607.setfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c67200607.ssop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c67200607.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
--
function c67200607.filter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsFaceup() and c:IsSetCard(0x677)
end
function c67200607.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if g and g:IsExists(c67200607.filter,1,nil,tp) then
		if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
			Duel.Destroy(rc,REASON_EFFECT)
		end
	end
end
--
function c67200607.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL and not e:GetHandler():IsPreviousLocation(LOCATION_OVERLAY)
end
function c67200607.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=eg:GetFirst()
	while rc and rc:IsSetCard(0x677) and not rc:IsCode(67200607) do
		if rc:GetFlagEffect(67200607)==0 then
			local e2=Effect.CreateEffect(c)
			e2:SetDescription(aux.Stringid(67200607,1))
			e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e2:SetCode(EVENT_CHAIN_SOLVING)
			e2:SetRange(LOCATION_MZONE)
			e2:SetOperation(c67200607.disop)
			rc:RegisterEffect(e2,true)
			rc:RegisterFlagEffect(67200607,RESET_EVENT+RESETS_STANDARD,0,1)
		end
		rc=eg:GetNext()
	end
end

