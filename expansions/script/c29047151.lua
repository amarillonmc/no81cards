--方舟骑士-推进之王·摧城
local m=29047151
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,29065500)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,aux.TRUE,2,2)
	--Effect 1
	local e0=Effect.CreateEffect(c)  
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCountLimit(1,m)
	e0:SetCost(cm.cost)
	e0:SetTarget(cm.tg)
	e0:SetOperation(cm.op)
	c:RegisterEffect(e0)  
end
function cm.mfilter(c,xyzc)
	local b1=(c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight))
	local b2=c:IsXyzLevel(xyzc,5)
	local b3=c:IsXyzLevel(xyzc,6)
	return b1 and (b2 or b3)
end
--Effect 1
function cm.f(c)
	local b1=aux.IsCodeListed(c,29065500) and c:IsType(TYPE_MONSTER)
	return b1 and c:IsAbleToHand() 
end
function cm.f1(c)
	return c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function cm.f2(c,tp)
	return c:IsCode(29065554) and c:IsAbleToHand() and Duel.IsExistingMatchingCard(cm.f3,tp,LOCATION_DECK,0,1,c)
end
function cm.f3(c)
	local b1=c:IsRace(RACE_BEASTWARRIOR) and c:IsAttribute(ATTRIBUTE_EARTH)
	local b2=c:IsType(TYPE_RITUAL)
	return b1 and b2 and c:IsAbleToHand() 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetMatchingGroup(cm.f,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.f1,tp,LOCATION_DECK,0,nil)
	local g3=Duel.GetMatchingGroup(cm.f2,tp,LOCATION_DECK,0,nil,tp)
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x10ae,1,REASON_COST) and #g1>0
	local b2=Duel.IsCanRemoveCounter(tp,1,0,0x10ae,2,REASON_COST) and #g2>0
	local b3=Duel.IsCanRemoveCounter(tp,1,0,0x10ae,3,REASON_COST) and #g3>0
	if chk==0 then return b1 end
	local ct=0
	if b1 then
		ct=ct+1
	end
	if b1 and b2 then
		ct=ct+1
	end
	if b1 and b2 and b3 then
		ct=ct+1
	end
	if ct==0 then return end
	local tbl={}
	for i=1,ct do
		table.insert(tbl,i)
	end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local num=Duel.AnnounceNumber(tp,table.unpack(tbl))
	Duel.RemoveCounter(tp,1,0,0x10ae,num,REASON_COST)
	e:SetLabel(num)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	if ct==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,4,tp,LOCATION_DECK)
	elseif ct==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
	else
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g1=Duel.GetMatchingGroup(cm.f,tp,LOCATION_DECK,0,nil)
	local g2=Duel.GetMatchingGroup(cm.f1,tp,LOCATION_DECK,0,nil)
	local g3=Duel.GetMatchingGroup(cm.f2,tp,LOCATION_DECK,0,nil,tp)
	if ct==0 then return end
	if ct==3 then 
		if #g1==0 or #g2==0 or #g3==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg2=g2:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg3=g3:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg4=Duel.SelectMatchingCard(tp,cm.f3,tp,LOCATION_DECK,0,1,1,tc3)
		if #tg1==0 or #tg2==0 or #tg3==0 or #tg4==0 then return end
		local mg=Group.CreateGroup() 
		mg:Merge(tg1)
		mg:Merge(tg2)
		mg:Merge(tg3)
		mg:Merge(tg4)
		if #mg<3 then return end
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	elseif ct==2 then
		if #g1==0 or #g2==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg2=g2:Select(tp,1,1,nil)
		if #tg1==0 or #tg2==0 then return end
		local mg=Group.CreateGroup() 
		mg:Merge(tg1)
		mg:Merge(tg2)
		if #mg<1 then return end
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	else
		if #g1==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local mg=g1:Select(tp,1,1,nil)
		if #mg==0 then return end
		Duel.SendtoHand(mg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,mg)
	end
end