local m=15000384
local cm=_G["c"..m]
cm.name="星极零场"
function cm.initial_effect(c)
	--activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(cm.acop)
	c:RegisterEffect(e0)
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(15000384)
	e1:SetRange(LOCATION_FZONE)
	c:RegisterEffect(e1)
	--when Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(4179255)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,15000384)
	e2:SetCondition(cm.thcon)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--Activate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	if not cm.global_effect then
		cm.global_effect=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVING)
		ge1:SetCondition(cm.chcon)
		ge1:SetOperation(cm.chop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(e:GetHandler(),4179255,e,0,tp,tp,Duel.GetCurrentChain())
end
function cm.chcon(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return rc:IsType(TYPE_PENDULUM) and rc:GetLeftScale()==0 and rc:GetRightScale()==0 and re:IsActivated() and re:GetOperation() and not re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetOwner()
	local rc=re:GetHandler()
	local op=re:GetOperation()
	local g1=Duel.GetMatchingGroup(cm.selfilter,0,LOCATION_FZONE,0,nil)
	local g2=Duel.GetMatchingGroup(cm.selfilter,1,LOCATION_FZONE,0,nil)
	if #g1==0 and #g2==0 then return end
	local x=0
	if #g1~=0 and #g2==0 then
		if Duel.IsPlayerCanDraw(0,1) then
			if Duel.SelectEffectYesNo(0,rc,aux.Stringid(m,7)) then
				x=1
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e0:SetCode(15000385)
				e0:SetTargetRange(1,0)
				e0:SetDescription(aux.Stringid(m,0))
				e0:SetReset(RESET_PHASE+PHASE_END,1)
				Duel.RegisterEffect(e0,0)
			end
		end
	end
	if #g1==0 and #g2~=0 then
		if Duel.IsPlayerCanDraw(1,1) then
			if Duel.SelectEffectYesNo(1,rc,aux.Stringid(m,7)) then
				x=1
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e0:SetCode(15000385)
				e0:SetTargetRange(1,0)
				e0:SetDescription(aux.Stringid(m,0))
				e0:SetReset(RESET_PHASE+PHASE_END,1)
				Duel.RegisterEffect(e0,1)
			end
		end
	end
	if #g1~=0 and #g2~=0 then
		if Duel.IsPlayerCanDraw(0,1) then
			if Duel.SelectEffectYesNo(0,rc,aux.Stringid(m,7)) then
				x=1
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e0:SetCode(15000385)
				e0:SetTargetRange(1,0)
				e0:SetDescription(aux.Stringid(m,0))
				e0:SetReset(RESET_PHASE+PHASE_END,1)
				Duel.RegisterEffect(e0,0)
			end
		end
		if Duel.IsPlayerCanDraw(1,1) then
			if Duel.SelectEffectYesNo(1,rc,aux.Stringid(m,7)) then
				x=1
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_FIELD)
				e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
				e0:SetCode(15000385)
				e0:SetTargetRange(1,0)
				e0:SetDescription(aux.Stringid(m,0))
				e0:SetReset(RESET_PHASE+PHASE_END,1)
				Duel.RegisterEffect(e0,1)
			end
		end
	end
	if x==1 then
		local p=rc:GetControler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(15000384)
		e1:SetTargetRange(1,0)
		e1:SetOperation(op)
		e1:SetLabelObject(re)
		e1:SetLabel(p)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,0)
		Duel.ChangeChainOperation(ev,cm.repop)
	end
end
function cm.selfilter(c)
	return c:GetEffectCount(15000384)~=0 and not Duel.IsPlayerAffectedByEffect(c:GetControler(),15000385) and not c:IsDisabled()
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local se=Duel.IsPlayerAffectedByEffect(0,15000384)
	if not se then se=Duel.IsPlayerAffectedByEffect(1,15000384) end
	local op=nil
	local p=0
	if se then
		local x=1
		for _,i in ipairs{Duel.IsPlayerAffectedByEffect(0,15000384)} do
			if i:GetLabelObject()==e and x~=0 then
				op=i:GetOperation()
				p=i:GetLabel()
				i:Reset()
				x=0
			end
		end
	end
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	if Duel.IsExistingMatchingCard(nil,p,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		Duel.BreakEffect()
		Duel.Hint(HINT_CARD,1-p,15000384)
		Duel.Draw(p,1,REASON_EFFECT)
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:IsActiveType(TYPE_FIELD) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()==e:GetHandler()
end
function cm.thfilter(c)
	return c:IsSetCard(0xaf30) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
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
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function cm.filter(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true) and c:IsCode(15000382)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil,tp) end
	if not Duel.CheckPhaseActivity() then e:SetLabel(1) else e:SetLabel(0) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil,tp)
	Duel.ResetFlagEffect(tp,15248873)
	local tc=g:GetFirst()
	if tc then
		local te=tc:GetActivateEffect()
		if e:GetLabel()==1 then Duel.RegisterFlagEffect(tp,15248873,RESET_CHAIN,0,1) end
		local b2=te:IsActivatable(tp,true,true)
		Duel.ResetFlagEffect(tp,15248873)
		if b2 then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			te:UseCountLimit(tp,1,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end