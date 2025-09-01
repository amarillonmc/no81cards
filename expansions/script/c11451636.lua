--风雨征程 沉浮与共
--22.06.26
local cm,m=GetID()
function cm.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	e0:SetDescription(aux.Stringid(m,3))
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
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	local e21=aux.AddThisCardInGraveAlreadyCheck(c)
	e2:SetLabelObject(e21)
	e2:SetCondition(cm.actcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.actg)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.activate_sequence={}
		local _GetActivateLocation=Effect.GetActivateLocation
		local _GetActivateSequence=Effect.GetActivateSequence
		local _NegateActivation=Duel.NegateActivation
		function Effect.GetActivateLocation(e)
			if e:GetDescription()==aux.Stringid(11451631,5) then
				return _GetActivateLocation(e)
			end
			return _GetActivateLocation(e)
		end
		function Effect.GetActivateSequence(e)
			if e:GetDescription()==aux.Stringid(11451631,5) then
				return cm.activate_sequence[e]
			end
			return _GetActivateSequence(e)
		end
		function Duel.NegateActivation(ev)
			local re=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
			local res=_NegateActivation(ev)
			if res and aux.GetValueType(re)=="Effect" then
				local rc=re:GetHandler()
				if rc and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) and re:GetDescription()==aux.Stringid(m,0) then
					rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
				end
			end
			return res
		end
	end
end
function cm.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_GRAVE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)
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
	if chk==0 then return te and ft>0 and Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.actarget(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler() and te:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local te=e:GetLabelObject()
	Duel.DisableShuffleCheck()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	cm.activate_sequence[te]=c:GetSequence()
	c:CreateEffectRelation(te)
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
	return c:IsCode(11451631) and not c:IsForbidden() and c:CheckUniqueOnField(tp) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or Duel.IsPlayerAffectedByEffect(tp,11451676)) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
	Duel.RaiseEvent(e:GetHandler(),11451675,e,m,tp,tp,Duel.GetCurrentChain())
end
function cm.GetCardsInZone(tp,fd)
	if fd==0x400020 then return Duel.GetFieldCard(tp,LOCATION_MZONE,5) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,6) end
	if fd==0x200040 then return Duel.GetFieldCard(tp,LOCATION_MZONE,6) or Duel.GetFieldCard(1-tp,LOCATION_MZONE,5) end
	local seq=math.log(fd,2)
	local p=tp
	if seq>=16 then
		p=1-tp
		seq=seq-16
	end
	local loc=LOCATION_MZONE
	if seq>=8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	return Duel.GetFieldCard(p,loc,math.floor(seq+0.5))
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		local sp=tp
		local op=1
		if Duel.IsPlayerAffectedByEffect(tp,11451676) then
			local a1=(tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)>0)
			local a2=(tc:IsType(TYPE_FIELD) or Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0)
			local b1=tc:GetActivateEffect():IsActivatable(tp,true,true)
			local b2=tc:IsSSetable(true)
			op=aux.SelectFromOptions(tp,{a1 and b1,aux.Stringid(11451631,3)},{a2 and b1,aux.Stringid(11451631,4)},{a1 and b2,aux.Stringid(11451631,8)},{a2 and b2,aux.Stringid(11451631,9)})
			if op==2 or op==4 then sp=1-tp end
		end
		if op<=2 then
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(sp,LOCATION_FZONE,0)
				if fc then
					if Duel.IsPlayerAffectedByEffect(tp,11451676) then
						Duel.Destroy(fc,REASON_RULE)
					else
						Duel.SendtoGrave(fc,REASON_RULE)
						Duel.BreakEffect()
					end
				end
				Duel.MoveToField(tc,tp,sp,LOCATION_FZONE,POS_FACEUP,true)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if fc and tc:IsLocation(LOCATION_FZONE) then
					tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
				end
				Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451675,0))
				local fd=0xff
				if Duel.IsPlayerAffectedByEffect(tp,11451676) then
					if sp==tp then
						fd=Duel.SelectField(tp,1,LOCATION_SZONE,0,0x20002000)
					else
						fd=Duel.SelectField(tp,1,0,LOCATION_SZONE,0x20002000)
					end
					local fc=cm.GetCardsInZone(tp,fd)
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fd=fd>>8
					if sp~=tp then fd=fd>>16 end
				end
				Duel.MoveToField(tc,tp,sp,LOCATION_SZONE,POS_FACEUP,true,fd)
				local te=tc:GetActivateEffect()
				local tep=tc:GetControler()
				local cost=te:GetCost()
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			end
		else
			if tc:IsType(TYPE_FIELD) then
				local fc=Duel.GetFieldCard(sp,LOCATION_FZONE,0)
				if fc and Duel.IsPlayerAffectedByEffect(tp,11451676) then
					Duel.Destroy(fc,REASON_RULE)
				end
				Duel.SSet(tp,tc,sp)
			else
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11451675,0))
				local fd=0xff
				if Duel.IsPlayerAffectedByEffect(tp,11451676) then
					if sp==tp then
						fd=Duel.SelectField(tp,1,LOCATION_SZONE,0,0x20002000)
					else
						fd=Duel.SelectField(tp,1,0,LOCATION_SZONE,0x20002000)
					end
					local fc=cm.GetCardsInZone(tp,fd)
					if fc then Duel.Destroy(fc,REASON_RULE) end
					fd=fd>>8
					if sp~=tp then fd=fd>>16 end
				end
				Duel.MoveToField(tc,tp,sp,LOCATION_SZONE,POS_FACEDOWN,false,fd)
				Duel.ConfirmCards(1-sp,tc)
				tc:SetStatus(STATUS_SET_TURN,true)
				Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,ev)
			end
		end
	end
end
function cm.actfilter(c,se)
	if not (se==nil or c:GetReasonEffect()~=se) then return false end
	local code1,code2=c:GetPreviousCodeOnField()
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP) and (code1==11451631 or code2==11451631)
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.actfilter,1,nil,se)
end
function cm.thfilter(c,e,tp)
	return c:GetTurnID()==Duel.GetTurnCount() and not c:IsReason(REASON_RETURN) and (c:IsControler(1-tp) or c:IsAbleToHand() or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function cm.actg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cm.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,e:GetHandler(),e,tp) end
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp):GetFirst()
	if tc then
		local th=tc:IsAbleToHand()
		local sp=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
		local op=0
		if th and sp then op=Duel.SelectOption(tp,1190,1152)
		elseif th then op=0
		else op=1 end
		if op==0 then
			Duel.SendtoHand(tc,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end