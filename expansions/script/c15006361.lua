local m=15006361
local cm=_G["c"..m]
cm.name="无忧结界折折界"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf45)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCondition(cm.ctcon)
	e2:SetOperation(cm.ctop)
	c:RegisterEffect(e2)
	--act limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_FZONE)
	e4:SetOperation(cm.chainop)
	c:RegisterEffect(e4)
end
function cm.thfilter(c)
	return c:IsSetCard(0x5f45) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.ctfilter(c)
	return (c:IsPreviousPosition(POS_FACEDOWN) and c:IsFaceup() and (not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet())
		or c:IsPreviousPosition(POS_FACEUP) and c:IsFacedown())
end
function cm.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ctfilter,1,nil) and e:GetHandler():GetFlagEffect(15006361)==0
end
function cm.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0xf45,1)
end
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:GetCounter(0xf45)>=4 and re:IsActivated() and rc:IsSetCard(0x5f45) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		local ct=c:GetCounter(0xf45)
		c:RemoveCounter(tp,0xf45,ct,REASON_EFFECT)
		Duel.SetChainLimit(cm.chainlm)
		--change
		local op=re:GetOperation()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(15006361)
		e1:SetTargetRange(1,0)
		e1:SetOperation(op)
		e1:SetLabel(ct)
		e1:SetLabelObject(re)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
		Duel.ChangeChainOperation(ev,cm.repop)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end
function cm.facedfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition()
end
function cm.faceufilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=Duel.IsPlayerAffectedByEffect(0,15006361)
	if not se then se=Duel.IsPlayerAffectedByEffect(1,15006361) end
	local op=nil
	local ct=0
	local rrc=nil
	if se then
		local x=1
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(0,15006361)} do
			if i:GetLabelObject()==e and x~=0 then
				op=i:GetOperation()
				ct=i:GetLabel()
				rrc=i:GetOwner()
				i:Reset()
				x=0
			end
		end
	end
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local b1=ct%2~=0 and Duel.IsExistingMatchingCard(cm.facedfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	local b2=ct%2==0 and Duel.IsExistingMatchingCard(cm.faceufilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.Hint(HINT_CARD,0,15006361)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,cm.facedfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #sg>0 then
			if rrc then rrc:RegisterFlagEffect(15006361,RESET_CHAIN,0,1) end
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
			if rrc then rrc:ResetFlagEffect(15006361) end
		end
	end
	if b2 and Duel.SelectYesNo(tp,aux.Stringid(m,4)) then
		Duel.Hint(HINT_CARD,0,15006361)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local sg=Duel.SelectMatchingCard(tp,cm.faceufilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #sg>0 then
			if rrc then rrc:RegisterFlagEffect(15006361,RESET_CHAIN,0,1) end
			Duel.HintSelection(sg)
			Duel.ChangePosition(sg,POS_FACEDOWN_DEFENSE)
			if rrc then rrc:ResetFlagEffect(15006361) end
		end
	end
end