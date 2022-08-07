--人理之诗 女神的微笑
function c22020370.initial_effect(c)
	aux.AddCodeList(c,22020360)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22020370+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c22020370.cost)
	e1:SetCondition(c22020370.condition)
	e1:SetTarget(c22020370.target)
	e1:SetOperation(c22020370.activate)
	c:RegisterEffect(e1)
end
function c22020370.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Debug.Message("唔呵呵．．．做好觉悟了吗？")
end
function c22020370.cfilter(c)
	return c:IsFacedown()
end
function c22020370.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)
	return ct>0 
end
function c22020370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=Duel.GetMatchingGroupCount(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)
		if ct<=1 then return Duel.GetFieldGroupCount(ep,LOCATION_HAND,0)>0 end
		return true
	end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(c22020370.chainlm)
	end
end
function c22020370.chainlm(e,rp,tp)
	return not e:GetHandler():IsType(TYPE_TRAP)
end
function c22020370.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g2=Duel.GetMatchingGroupCount(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)
	local g=Duel.GetMatchingGroup(c22020370.cfilter,tp,0,LOCATION_ONFIELD,nil)
	local ct=g:GetCount()
	if ct>=1 then
		Duel.Damage(1-tp,g2*500,REASON_EFFECT)
		Debug.Message("女神的微笑！")
	end
	if ct>=3 and #g1>0 then
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g1:FilterSelect(tp,Card.IsAbleToDeck,1,1,nil)
		if #sg<=0 then return end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	if ct>=5 and Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_ONFIELD,0,nil,22020360)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	end
end
function c22020370.todeck(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(p,0,LOCATION_HAND)
	if #g>0 then
		Duel.ConfirmCards(p,g)
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
		local sg=g:FilterSelect(p,Card.IsAbleToDeck,1,1,nil)
		if #sg<=0 then return end
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		Duel.ShuffleHand(1-p)
	end
end
