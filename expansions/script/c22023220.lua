--人理之诗 过于漫长的巡礼之旅
function c22023220.initial_effect(c)
	aux.AddCodeList(c,22023210) 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22023220)
	e1:SetCondition(c22023220.condition)
	e1:SetTarget(c22023220.target)
	e1:SetOperation(c22023220.activate)
	c:RegisterEffect(e1)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023220,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22023221)
	e2:SetCondition(c22023220.thcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22023220.thtg)
	e2:SetOperation(c22023220.thop)
	c:RegisterEffect(e2)
end
function c22023220.indesfilter(c)
	return c:IsSummonLocation(LOCATION_HAND) and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsFaceup() and c:IsSetCard(0xff1)
end
function c22023220.condition(e)
	return Duel.IsExistingMatchingCard(c22023220.indesfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c22023220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SelectOption(tp,aux.Stringid(22023220,2))
	Duel.SelectOption(tp,aux.Stringid(22023220,3))
end
function c22023220.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	Duel.SelectOption(tp,aux.Stringid(22023220,4))
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	if #g>0 and Duel.HintSelection(g) then return end
	if Duel.Remove(g,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(22023220,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c22023220.retop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
		e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e2:SetTargetRange(0,1)
		e2:SetValue(HALF_DAMAGE)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c22023220.retfilter(c)
	return c:GetFlagEffect(22023220)~=0
end
function c22023220.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c22023220.retfilter,nil)
	if sg:GetCount()>1 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)==1 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22023220,1))
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		Duel.ReturnToField(tc)
	else
		local tc=sg:GetFirst()
		while tc do
			Duel.ReturnToField(tc)
			tc=sg:GetNext()
		end
	end
end
function c22023220.cfilter(c)
	return c:IsFaceup() and c:IsCode(22023210)
end
function c22023220.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023220.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c22023220.filter1(c)
	return c:IsCode(22023250) and c:IsAbleToHand()
end
function c22023220.filter2(c)
	return c:IsSetCard(0xff1) and not c:IsCode(22023220) and c:IsAbleToHand()
end
function c22023220.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c22023220.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingTarget(c22023220.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectTarget(tp,c22023220.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g2=Duel.SelectTarget(tp,c22023220.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g1,2,0,0)
end
function c22023220.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=g:Filter(Card.IsRelateToEffect,nil,e)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
