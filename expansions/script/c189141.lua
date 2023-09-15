local m=189141
local cm=_G["c"..m]
cm.name="逻辑工作室"
function cm.initial_effect(c)
	aux.AddCodeList(c,189131)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--extra attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,m)
	e2:SetCondition(aux.bpcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.atktg)
	e2:SetOperation(cm.atkop)
	c:RegisterEffect(e2)
end
function cm.hfilter(c)
	return c:IsPublic()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.hfilter,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(1-tp,1) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	local x=0
	while ct<=3 do
		if Duel.IsExistingMatchingCard(cm.hfilter,tp,0,LOCATION_HAND,1,nil) and Duel.IsPlayerCanDraw(1-tp,1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,cm.hfilter,tp,0,LOCATION_HAND,1,1,nil)
			if Duel.Destroy(g,REASON_EFFECT)==0 then return end
			if g:GetFirst():IsType(TYPE_SPELL+TYPE_TRAP) then x=1 end
			Duel.BreakEffect()
			local ag=Duel.GetDecktopGroup(1-tp,1)
			if Duel.Draw(1-tp,1,REASON_EFFECT)~=0 then
				Duel.ConfirmCards(tp,ag)
				Duel.ShuffleHand(1-tp)
			end
		end
		ct=ct+1
		if ct<=3 and ((not Duel.IsExistingMatchingCard(cm.hfilter,tp,0,LOCATION_HAND,1,nil)) or (not Duel.IsPlayerCanDraw(1-tp,1))) then
			break
		end
		if ct<=3 and not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			break
		end
	end
	if x==1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,aux.ExceptThisCard(e),tp,POS_FACEUP,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,aux.ExceptThisCard(e),tp,POS_FACEUP,REASON_EFFECT)
		if #rg~=0 then
			Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.atkfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c,189131) and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(cm.ftarget)
		e2:SetLabel(tc:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function cm.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end