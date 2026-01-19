--人理之诗 驰骋天际星之枪尖
function c22025060.initial_effect(c)
	aux.AddCodeList(c,22025040)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22025060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c22025060.target)
	e1:SetOperation(c22025060.activate)
	c:RegisterEffect(e1)
end
function c22025060.filter1(c,tp)
	return c:IsFaceup() and c:IsCode(22025040)
		and Duel.IsExistingTarget(c22025060.filter2,tp,0,LOCATION_MZONE,1,nil,tp,c)
end
function c22025060.filter2(c,tp,tc)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c22025060.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,tg)
end
function c22025060.desfilter(c,tg)
	return not tg:IsContains(c)
end
function c22025060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22025060.filter1,tp,LOCATION_MZONE,0,1,nil,tp) end
	local g1=Duel.SelectTarget(tp,c22025060.filter1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local g2=Duel.SelectTarget(tp,c22025060.filter2,tp,0,LOCATION_MZONE,1,1,nil,tp,g1:GetFirst())
	g1:Merge(g2)
	local g=Duel.GetMatchingGroup(c22025060.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,g1)
end
function c22025060.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local g=Duel.GetMatchingGroup(c22025060.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tg)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_RULE)
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetTargetRange(1,1)
		e1:SetValue(c22025060.aclimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22025060.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE or re:GetActivateLocation()==LOCATION_HAND 
end