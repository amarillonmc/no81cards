--无我荒途
local cm,m,o=GetID()
function cm.initial_effect(c)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_TO_HAND)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(cm.op0)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--salvage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.op0(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFieldID()<=172 then return end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function cm.handcon(e)
	return e:GetHandler():GetFlagEffect(m)~=0
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then return end
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.RegisterFlagEffect(tp,60000036,0,0,1)
		Duel.RegisterFlagEffect(tp,60000037,RESET_PHASE+PHASE_END,0,1)
		local b1=true
		local b2=true
		local b3=true
		if Duel.GetFlagEffect(tp,m+10000000)~=0 then
			b1=false
			if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
		end
		if Duel.GetFlagEffect(tp,m+20000000)~=0 then
			b2=false
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if Duel.GetFlagEffect(tp,m+30000000)~=0 then
			b3=false
			if Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_MZONE,0,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
				Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
			end
		end
		local op=0
		if b1 or b2 or b3 then op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)},{b3,aux.Stringid(m,3)}) end
		if op==1 then Duel.RegisterFlagEffect(tp,m+10000000,0,0,1) 
		elseif op==2 then Duel.RegisterFlagEffect(tp,m+20000000,0,0,1) 
		elseif op==3 then Duel.RegisterFlagEffect(tp,m+30000000,0,0,1) end
	end
end
function cm.pfil(c,e,tp)
	return not c:IsPosition(POS_FACEUP_DEFENSE)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.IsPlayerCanNormalDraw(tp) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.IsPlayerCanNormalDraw(tp) then return end
	aux.GiveUpNormalDraw(e,tp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
		if Duel.GetFlagEffect(tp,m+10000000)~=0 then
			--b1=false
			if Duel.IsPlayerCanDraw(tp,1) then Duel.Draw(tp,1,REASON_EFFECT) end
		end
		if Duel.GetFlagEffect(tp,m+20000000)~=0 then
			--b2=false
			if Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
		if Duel.GetFlagEffect(tp,m+30000000)~=0 then
			--b3=false
			if Duel.IsExistingMatchingCard(cm.pfil,tp,LOCATION_MZONE,0,1,nil) then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
				local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_MZONE,0,1,1,nil)
				Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
			end
		end
	end
end