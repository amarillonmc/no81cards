--栖夜姬的威胁
local m=33300203
local cm=_G["c"..m]
function cm.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.atttg)
	e2:SetOperation(cm.attop)
	c:RegisterEffect(e2)
end
function cm.filter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x561)
end
function cm.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.rmfilter(c,link)
	return c:IsType(TYPE_MONSTER) and c:IsLink(link) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,0,LOCATION_MZONE,1,nil,tp) and Duel.IsExistingMatchingCard(cm.thfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,cm.filter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local sg=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_ONFIELD,nil)
	if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
		if not tc:IsRelateToEffect(e) then return end
		if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function cm.filter1(c)
	return c:IsFacedown()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil) and c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	if sg:GetFirst():IsSetCard(0x561) then
		local tc=sg:GetFirst()
		e:SetLabel(1)
		e:SetLabelObject(tc)
	end
end
function cm.atttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_ONFIELD) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,1,tp,LOCATION_ONFIELD)
end
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
		Duel.Destroy(tc,REASON_EFFECT)
		local tc=e:GetLabelObject()
		local op=2
		if tc:IsPosition(POS_FACEDOWN) then
			op=Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))
		elseif tc:IsPosition(POS_FACEUP_ATTACK) then
			op=Duel.SelectOption(tp,aux.Stringid(m,4))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,3))
		end
		if op==0 then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
		if op==1 then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
end