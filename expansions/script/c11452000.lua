--反转宇宙
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_MAIN_END)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
end
function cm.filter(c)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_EXTRA)) and c:IsAbleToDeck()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0x7e,0x7e,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0x7e,0x7e,e:GetHandler())
	Duel.SetChainLimit(function(e,ep,tp) return ep~=Duel.GetTurnPlayer() end)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,PLAYER_ALL,0x7e)
end
function cm.dfilter(c,tp)
	return c:IsLocation(LOCATION_DECK) and c:IsControler(tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0x7e,0x7e,aux.ExceptThisCard(e))
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 then
		Duel.SetLP(tp,8000)
		Duel.SetLP(1-tp,8000)
	end
	local sg1,sg2,g2r,exg2r=Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup(),Group.CreateGroup()
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	local exg1=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	Duel.ConfirmCards(tp,g1+exg1)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g1r=g1:Select(tp,math.min(15,#g1),math.min(15,#g1),nil)
	local exg1r=exg1:Select(tp,math.min(5,#exg1),math.min(5,#exg1),nil)
	if Duel.Remove(g1r+exg1r,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.SendtoDeck(g1r+exg1r,tp,0,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1r+exg1r)
		sg1=Duel.GetOperatedGroup()
	end
	if Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		local g2=Duel.GetFieldGroup(1-tp,0,LOCATION_DECK)
		local exg2=Duel.GetFieldGroup(1-tp,0,LOCATION_EXTRA)
		Duel.ConfirmCards(1-tp,g2+exg2)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(m,1))
		g2r=g2:Select(1-tp,math.min(15,#g2),math.min(15,#g2),nil)
		exg2r=exg2:Select(1-tp,math.min(5,#exg2),math.min(5,#exg2),nil)
	end
	if Duel.Remove(g2r+exg2r,POS_FACEUP,REASON_EFFECT)>0 then
		Duel.SendtoDeck(g2r+exg2r,1-tp,0,REASON_EFFECT)
		Duel.ConfirmCards(tp,g2r+exg2r)
		sg2=Duel.GetOperatedGroup()
	end
	sg1=sg1:Filter(cm.dfilter,nil,tp)
	if #sg1>0 then
		Duel.ShuffleDeck(tp)
		local tg=sg1:GetMinGroup(Card.GetSequence)
		while tg and #tg>0 do
			local tc=tg:GetFirst()
			Duel.MoveSequence(tc,0)
			sg1:RemoveCard(tc)
			tg=sg1:GetMinGroup(Card.GetSequence)
		end
	end
	sg2=sg2:Filter(cm.dfilter,nil,1-tp)
	if #sg2>0 then
		Duel.ShuffleDeck(1-tp)
		local tg=sg2:GetMinGroup(Card.GetSequence)
		while tg and #tg>0 do
			local tc=tg:GetFirst()
			Duel.MoveSequence(tc,0)
			sg2:RemoveCard(tc)
			tg=sg2:GetMinGroup(Card.GetSequence)
		end
	end
	Duel.Draw(tp,5,REASON_EFFECT)
	Duel.Draw(1-tp,5,REASON_EFFECT)
end