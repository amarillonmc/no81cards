--欲望之书
local m=33330079
local cm=_G["c"..m]
function c33330079.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN1 and not Duel.CheckPhaseActivity()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,3) and Duel.IsPlayerCanDraw(1-tp,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,0,PLAYER_ALL,1)
end
function cm.thfilter(c)
	return c:IsAbleToHand()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local hand1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local hand2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local g1=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,0,hand1,nil)
	local g2=Duel.SelectMatchingCard(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,0,hand2,nil)
	local sdes=0
	local odes=0
	if g1:GetCount()>0 then
		sdes=Duel.SendtoGrave(g1,REASON_EFFECT)
	end
	if g2:GetCount()>0 then
		odes=Duel.SendtoGrave(g2,REASON_EFFECT)
	end
	
	Duel.ConfirmDecktop(tp,sdes+3)
	Duel.ConfirmDecktop(1-tp,odes+3)
	local dg1=Duel.GetDecktopGroup(tp,sdes+3)
	local dg2=Duel.GetDecktopGroup(1-tp,odes+3)
	if  sdes>odes then
		Group.Merge(dg1,dg2)
		if dg1:GetCount()>0 then
			if dg1:IsExists(cm.thfilter,1,nil) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg=dg1:FilterSelect(tp,cm.thfilter,1,2,nil)
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
		end
	elseif sdes<odes then
		Group.Merge(dg2,dg1)
		if dg2:GetCount()>0 then
			if dg2:IsExists(cm.thfilter,1,nil) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg1=dg2:FilterSelect(1-tp,cm.thfilter,1,2,nil)
				Duel.SendtoHand(sg1,1-tp,REASON_EFFECT)
				Duel.ConfirmCards(tp,sg1)
				Duel.ShuffleHand(1-tp)
			end
		end
	else
		if dg1:GetCount()>0 then
			if dg1:IsExists(cm.thfilter,1,nil) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg=dg1:FilterSelect(tp,cm.thfilter,1,1,nil)
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
				Duel.ShuffleHand(tp)
			end
		end
		if dg2:GetCount()>0 then
			if dg2:IsExists(cm.thfilter,1,nil) then
				Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
				local sg1=dg2:FilterSelect(1-tp,cm.thfilter,1,1,nil)
				Duel.SendtoHand(sg1,1-tp,REASON_EFFECT)
				Duel.ConfirmCards(tp,sg1)
				Duel.ShuffleHand(1-tp)
			end
		end
	end
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
end