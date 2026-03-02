--人理之诗 驰骋天际星之枪尖
function c22025060.initial_effect(c)
	aux.AddCodeList(c,22025040,22025820)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22025060)
	e1:SetTarget(c22025060.target)
	e1:SetOperation(c22025060.activate)
	c:RegisterEffect(e1)
	--aeg
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c22025060.aegcon)
	e3:SetOperation(c22025060.aegop)
	c:RegisterEffect(e3)
end
function c22025060.filter1(c,tp)
	return c:IsFaceup() and c:IsCode(22025040)
		and Duel.IsExistingTarget(c22025060.filter2,tp,0,LOCATION_MZONE,1,nil,tp,c)
end
function c22025060.filter2(c,tp,tc)
	local tg=Group.FromCards(c,tc)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c22025060.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tg)
end
function c22025060.desfilter(c,tg)
	return not tg:IsContains(c) and c:IsType(TYPE_MONSTER)
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
function c22025060.aegcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp==tp and re:GetHandler():IsCode(22025820) and Duel.GetFlagEffect(tp,22026360)==0 and c:IsAbleToRemove() and Duel.IsPlayerCanDraw(tp,2) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<2
end
function c22025060.aegop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(22025060,0)) then
		Duel.Hint(HINT_CARD,0,22025060)
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
		Duel.Draw(tp,2,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,22025060,RESET_PHASE+PHASE_END,0,1)
		local e0=Effect.CreateEffect(c)
		e0:SetDescription(aux.Stringid(22025060,1))
		e0:SetType(EFFECT_TYPE_FIELD)
		e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e0:SetReset(RESET_PHASE+PHASE_END)
		e0:SetTargetRange(1,0)
		Duel.RegisterEffect(e0,tp)
	end
end
