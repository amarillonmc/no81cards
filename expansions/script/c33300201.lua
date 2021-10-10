--栖夜姬的出逃
local m=33300201
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(cm.cost)
	e2:SetCountLimit(1,m+1000)
	e2:SetTarget(cm.atttg)
	e2:SetOperation(cm.attop)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return c:IsSetCard(0x561) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.filter1(c)
	return c:IsFacedown()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,sg)
	if sg:GetFirst():IsSetCard(0x561) then
		local tc=sg:GetFirst()
		e:SetLabel(1)
		e:SetLabelObject(tc)
	end
end
function cm.atttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		local tc=e:GetLabelObject()
		local op=2
		if tc:IsPosition(POS_FACEDOWN) then
			op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		elseif tc:IsPosition(POS_FACEUP_ATTACK) then
			op=Duel.SelectOption(tp,aux.Stringid(m,3))+1
		else
			op=Duel.SelectOption(tp,aux.Stringid(m,2))
		end
		if op==0 then
			Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
		end
		if op==1 then
			Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		end
	end
end