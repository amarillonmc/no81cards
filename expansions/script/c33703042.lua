--虚拟占卜师 狼-半-仙
local m=33703042
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,3,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	e1:SetLabel(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetLabel(2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetLabel(3)
	c:RegisterEffect(e3)
end
function cm.ovfilter(c)
	return  (c:IsType(TYPE_XYZ)  and c:IsRankAbove(7)) or (c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(7))
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,ct,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,ct,ct,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_REMOVED)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local temp =e:GetLabel()
	if temp == 1 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) then
	local g=Duel.GetDecktopGroup(tp,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
	if  g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==Duel.GetFieldGroupCount(tp,LOCATION_HAND,0) then
			Duel.DisableShuffleCheck()
			Duel.ConfirmDecktop(tp,Duel.GetFieldGroupCount(tp,LOCATION_HAND,0))
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			local sc =Group.Select(g,tp,1,1,nil)
			Duel.SendtoHand(sc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
			Duel.ShuffleHand(tp)
	end
	elseif temp ==2 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>5 then
	local g=Duel.GetDecktopGroup(tp,5)
		if  g:FilterCount(Card.IsAbleToRemove,nil,POS_FACEDOWN)==5 then
			Duel.DisableShuffleCheck()
			Duel.ConfirmDecktop(tp,5)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			local sc =Group.Select(g,tp,1,1,nil)
			Duel.SendtoHand(sc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
			Duel.ShuffleHand(tp)
		end
	elseif temp ==3 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_DECK,0,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.ConfirmCards(1-tp,g)
			Duel.DisableShuffleCheck()
			Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			local sc =Group.Select(g,tp,1,1,nil)
			Duel.SendtoHand(sc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sc)
			Duel.ShuffleHand(tp)
	end



end

