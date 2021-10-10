--栖夜姬的寝具偷盗
local m=33300206
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+1000)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.atttg)
	e2:SetOperation(cm.attop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
		tc=eg:GetNext()
	end
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x561)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,0,0)
end
function cm.thfilter(c)
	return c:GetFlagEffect(m)>0 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.thcon)
	e1:SetOperation(cm.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.thfilter,tp,0,LOCATION_GRAVE,nil,tp)>0
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,0,LOCATION_GRAVE,nil,tp)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
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