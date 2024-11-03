--惑星 末日轮回
function c38020021.initial_effect(c)
	 local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCost(c38020021.cost)
	e1:SetTarget(c38020021.target)
	e1:SetOperation(c38020021.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c38020021.handcon)
	c:RegisterEffect(e2)
end
function c38020021.rfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(8) and c:IsFaceup()
		and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c38020021.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c38020021.rfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	if chk==0 then return  g:GetClassCount(Card.GetCode)>7 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,aux.TRUE,false,8,8)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c38020021.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,5)
end
function c38020021.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)==0 then 
			Duel.Draw(1-tp,5,REASON_EFFECT) end
	end
end
function c38020021.handcon(e)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,38020016)
end