--栖夜姬的换装巡游
local m=33300207
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--search
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetDescription(aux.Stringid(m,0))
	e1_1:SetCategory(CATEGORY_DESTROY)
	e1_1:SetType(EFFECT_TYPE_QUICK_O)
	e1_1:SetCode(EVENT_FREE_CHAIN)
	e1_1:SetRange(LOCATION_SZONE)
	e1_1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1_1:SetCountLimit(1,m)
	e1_1:SetTarget(cm.thtg)
	e1_1:SetOperation(cm.thop)
	c:RegisterEffect(e1_1) 
	--set self
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.atttg)
	e2:SetOperation(cm.attop)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsSSetable() and c:IsSetCard(0x561) and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tgfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x561)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and cm.tgfilter(chkc,tp) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 end
	if chk==0 then return Duel.IsExistingTarget(cm.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,cm.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g)
			local dc=g:GetFirst()
			if dc:IsType(TYPE_QUICKPLAY) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				dc:RegisterEffect(e1)
			end
			if dc:IsType(TYPE_TRAP) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
				e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				dc:RegisterEffect(e1)
			end
			if tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_ONFIELD) and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then   
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
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
	if chk==0 then return e:GetHandler():IsSSetable() and Duel.GetLocationCount(tp,LOCATION_SZONE,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function cm.attop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and e:GetLabel()==1 then
		Duel.SSet(tp,c)
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