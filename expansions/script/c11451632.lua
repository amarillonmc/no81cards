--风雨征程 燎原火种
--22.06.22
local cm,m=GetID()
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451631,5))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetRange(LOCATION_DECK)
	e3:SetCondition(cm.condition)
	e3:SetCost(cm.cost)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_ACTIVATE_COST)
	e4:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	e4:SetTarget(cm.actarget)
	e4:SetOperation(cm.costop)
	c:RegisterEffect(e4)
	local e5=e1:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.cost2)
	c:RegisterEffect(e5)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11451631,6))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(cm.actcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.actg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetDecktopGroup(e:GetHandlerPlayer(),1):IsContains(e:GetHandler()) and cm.handcon(e)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=Duel.IsPlayerAffectedByEffect(tp,11451677)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return te and ft>0 end
	te:UseCountLimit(tp)
end
function cm.refilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=Duel.IsPlayerAffectedByEffect(tp,11451673)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return te and ft>0 and Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DisableShuffleCheck()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	local te=e:GetLabelObject()
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(cm.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function cm.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function cm.filter(c,tp)
	return c:IsCode(11451631) and not c:IsForbidden() and c:CheckUniqueOnField(tp) --and (c:GetActivateEffect():IsActivatable(tp,true,true) or c:CheckActivateEffect(false,false,false)~=nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.IsPlayerAffectedByEffect(tp,11451676) or Duel.SelectOption(tp,aux.Stringid(11451631,3),aux.Stringid(11451631,4))==0 then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			if fc and tc:IsLocation(LOCATION_FZONE) then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				Duel.RaiseEvent(e:GetHandler(),11451675,e,m,tp,tp,Duel.GetCurrentChain())
			end
		else
			local fc=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			if fc and tc:IsLocation(LOCATION_FZONE) then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				Duel.RaiseEvent(e:GetHandler(),11451675,e,m,tp,tp,Duel.GetCurrentChain())
			end
		end
		--[[local te=tc:GetActivateEffect()
		if te:IsActivatable(tp,true,true) and (not tc:CheckActivateEffect(false,false,false) or Duel.SelectOption(tp,aux.Stringid(11451631,3),aux.Stringid(11451631,4))==0) then
			local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if fc and tc:IsLocation(LOCATION_FZONE) then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				Duel.RaiseEvent(e:GetHandler(),11451675,e,m,tp,tp,Duel.GetCurrentChain())
			end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		else
			local fc=Duel.GetFieldCard(1-tp,LOCATION_FZONE,0)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,1-tp,LOCATION_FZONE,POS_FACEUP,true)
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			if fc and tc:IsLocation(LOCATION_FZONE) then
				tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				Duel.RaiseEvent(e:GetHandler(),11451675,e,m,tp,tp,Duel.GetCurrentChain())
			end
			Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
		end--]]
	end
end
function cm.actfilter(c)
	local code1,code2=c:GetPreviousCodeOnField()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and (code1==11451631 or code2==11451631)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.actfilter,1,nil) and (not eg:IsContains(e:GetHandler()) or e:GetHandler():IsLocation(LOCATION_HAND))
end
function cm.setfilter(c)
	return c:IsSetCard(0x979) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetCurrentChain()<=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end