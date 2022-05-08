--银流秘术H·拉布雷斯预测结界
local m=33701604
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Removed Summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
end
cm.toss_coin=true
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
   local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,LOCATION_HAND,nil)
   if chk==0 then return g:GetCount()>0 end
   Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
   Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local coin1=Duel.TossCoin(tp,1)
	if coin1==1 then  
		local cg=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		Duel.ConfirmCards(tp,cg)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,1-tp,LOCATION_HAND,0,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			Duel.ShuffleHand(1-tp)
		end
	elseif coin1==0 then
		local cg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
		Duel.ConfirmCards(1-tp,cg)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
		if g:GetCount()>=1 then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local sg=g:Select(1-tp,1,1,nil)
			Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end
--Removed Summon
function cm.filter(c,e,tp)
	return c:IsFaceup() and c:IsCode(33701601) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end 
end