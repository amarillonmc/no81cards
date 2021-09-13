--言叶无限欺 布局
local m=33403529
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	 XY.magane(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end
function cm.costfilter1(c)
	return  c:IsSetCard(0x6349) or c:IsCode(33403520) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.filter1(c)
	return (c:IsSetCard(0x6349) or c:IsCode(33403520)) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local b2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if chk==0 then return b1>=4 and  b2>=4 end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local cm1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	local cm2=Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
	if cm1>=4 then
		local g=Duel.GetDecktopGroup(tp,4)
		Duel.ConfirmCards(tp,g)
		if g:IsExists(cm.filter1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,cm.filter1,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		Duel.SortDecktop(tp,tp,3)
		else Duel.SortDecktop(tp,tp,4) 
		end
	end
	if cm2>=4 then
		  local g=Duel.GetDecktopGroup(1-tp,4)
		  Duel.ConfirmCards(tp,g)
		  if g:IsExists(cm.filter1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		  local sg=g:FilterSelect(tp,cm.filter1,1,1,nil)
		  Duel.DisableShuffleCheck()
		  Duel.SendtoHand(sg,tp,REASON_EFFECT)
		  Duel.ConfirmCards(1-tp,sg)
		  Duel.ShuffleHand(tp)
		  Duel.SortDecktop(tp,1-tp,3)
		  else Duel.SortDecktop(tp,1-tp,4) 
		  end				
	end
end
