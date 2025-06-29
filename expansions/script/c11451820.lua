--海造贼-深溟之黑莲号
local cm,m=GetID()
function cm.initial_effect(c)
	if c:GetOriginalCode()==m then
		--adjust
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e01:SetCode(EVENT_ADJUST)
		e01:SetRange(0xff)
		e01:SetOperation(cm.adjustop)
		c:RegisterEffect(e01)
		if not cm.global_check then
			cm.global_check=true
			cm.activate_sequence={}
			local _GetActivateLocation=Effect.GetActivateLocation
			local _GetActivateSequence=Effect.GetActivateSequence
			local _NegateActivation=Duel.NegateActivation
			function Effect.GetActivateLocation(e)
				if e:GetDescription()==aux.Stringid(m,0) then
					return _GetActivateLocation(e)
				end
				return _GetActivateLocation(e)
			end
			function Effect.GetActivateSequence(e)
				if e:GetDescription()==aux.Stringid(m,0) then
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
end
function cm.filter(c)
	return c:IsSetCard(0x13f) and c:GetOriginalCode()~=m
end
function cm.immtg(e,c)
	return c:GetEquipCount()>0 and c:GetEquipGroup():IsExists(Card.IsSetCard,1,nil,0x13f)
end
function cm.immval(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.atttg(e,c)
	return c:IsOriginalSetCard(0x13f) and c:IsType(TYPE_MONSTER)
end
function cm.attval(e,re)
	local tp=e:GetHandlerPlayer()
	local wg=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() end,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return att
end
function cm.chtg(e,c)
	local tp=e:GetHandlerPlayer()
	local wg=Duel.GetMatchingGroup(function(c) return c:IsType(TYPE_MONSTER) and c:IsFaceupEx() end,tp,LOCATION_MZONE,0,nil)
	local wbc=wg:GetFirst()
	local att=0
	while wbc do
		att=att|wbc:GetAttribute()
		wbc=wg:GetNext()
	end
	return c:IsAttribute(att)
end
function cm.costfilter1(c)
	return c:IsSetCard(0x13f) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	if not cm[tp] then
		cm[tp]=true
		local c=e:GetHandler()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,nil)
		if #g==0 then e:Reset() return end
		Duel.ConfirmCards(1-tp,c)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.Hint(HINT_CARD,0,m)
		--immune
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(cm.immtg)
		e1:SetValue(cm.immval)
		--Duel.RegisterEffect(e1,tp)
		--Attribute
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ADD_ATTRIBUTE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(cm.atttg)
		e1:SetValue(cm.attval)
		Duel.RegisterEffect(e1,tp)
		--setname
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_ADD_SETCODE)
		e1:SetTargetRange(0xff,0xff)
		e1:SetTarget(cm.chtg)
		e1:SetValue(0x13f)
		Duel.RegisterEffect(e1,tp)
		--activate from hand
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x13f))
		e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		Duel.RegisterEffect(e2,0)
		--change effect type
		local g=Duel.GetMatchingGroup(cm.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		esetcountLimit=Effect.SetCountLimit
		Effect.SetCountLimit=function(effect,count,flag)
			return esetcountLimit(effect,1,(flag or 0)&EFFECT_COUNT_CODE_CHAIN)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect:IsActivated() and effect:GetRange()&(LOCATION_ONFIELD+LOCATION_HAND+LOCATION_PZONE+LOCATION_FZONE)==effect:GetRange() and not ((effect:GetCode()==EVENT_TO_GRAVE or effect:GetCode()==EVENT_LEAVE_FIELD) and effect:IsHasType(EFFECT_TYPE_SINGLE)) then
				--if cm.cloneeffects[effect] then return end
				local eff=effect:Clone()
				if eff:IsHasType(EFFECT_TYPE_QUICK_O) and eff:GetCode()==EVENT_FREE_CHAIN then
					if eff:GetRange()&LOCATION_MZONE>0 and card:GetOriginalCode()~=20248755 and card:GetOriginalCode()~=99953655 and card:GetOriginalCode()~=15000111 then eff:SetDescription(aux.Stringid(m,8)) end
					if eff:GetRange()&LOCATION_SZONE>0 and card:GetOriginalCode()~=17016131 then eff:SetDescription(aux.Stringid(m,1)) end
					eff:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
					local con=eff:GetCondition() or aux.TRUE
					eff:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
										local cons=false
										local _GetTurnPlayer=Duel.GetTurnPlayer
										local _GetCurrentPhase=Duel.GetCurrentPhase
										for i=0,1 do
											for _,j in ipairs({PHASE_DRAW,PHASE_STANDBY,PHASE_MAIN1,PHASE_BATTLE_START,PHASE_BATTLE,PHASE_MAIN2,PHASE_END}) do
												Duel.GetTurnPlayer=function() return i end
												Duel.GetCurrentPhase=function() return j end
												if con(e,tp,eg,ep,ev,re,r,rp) then cons=true break end
											end
										end
										Duel.GetTurnPlayer=_GetTurnPlayer
										Duel.GetCurrentPhase=_GetCurrentPhase
										return cons
									end)
				elseif eff:IsHasType(EFFECT_TYPE_IGNITION) then
					if eff:GetRange()&LOCATION_PZONE>0 then eff:SetDescription(aux.Stringid(m,2)) end
					if eff:GetRange()&LOCATION_HAND>0 then eff:SetDescription(aux.Stringid(m,3)) end
					if eff:GetRange()&LOCATION_MZONE>0 then eff:SetDescription(aux.Stringid(m,4)) end
					if eff:GetRange()&LOCATION_SZONE>0 then eff:SetDescription(aux.Stringid(m,5)) end
					if eff:GetRange()&LOCATION_FZONE>0 then eff:SetDescription(aux.Stringid(m,13)) end
					if card:GetOriginalCode()~=80621422 then eff:SetRange(LOCATION_ONFIELD+LOCATION_HAND) end
					eff:SetType(EFFECT_TYPE_QUICK_O)
					eff:SetCode(EVENT_FREE_CHAIN)
				elseif (eff:IsHasType(EFFECT_TYPE_TRIGGER_O) or eff:IsHasType(EFFECT_TYPE_TRIGGER_F)) and eff:IsHasType(EFFECT_TYPE_FIELD) and card:GetOriginalCode()~=20248755 then
					if eff:GetRange()&LOCATION_MZONE>0 then eff:SetDescription(aux.Stringid(m,6)) end
					if eff:GetRange()&LOCATION_SZONE>0 then eff:SetDescription(aux.Stringid(m,7)) end
					eff:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
					eff:SetType(EFFECT_TYPE_QUICK_O)
					eff:SetCode(EVENT_FREE_CHAIN)
					eff:SetCondition(aux.TRUE)
				elseif eff:IsHasType(EFFECT_TYPE_TRIGGER_O) and eff:IsHasType(EFFECT_TYPE_SINGLE) and eff:GetCode()==EVENT_SPSUMMON_SUCCESS then
					if eff:GetRange()&LOCATION_MZONE>0 then eff:SetDescription(aux.Stringid(m,12)) end
					eff:SetRange(LOCATION_ONFIELD+LOCATION_HAND)
					eff:SetType(EFFECT_TYPE_QUICK_O)
					eff:SetCode(EVENT_FREE_CHAIN)
					eff:SetCondition(aux.TRUE)
				elseif eff:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_QUICKPLAY) then
					eff:SetDescription(aux.Stringid(m,10))
					local eff2=eff:Clone()
					--spell activate in hand
					eff2:SetDescription(aux.Stringid(m,0))
					eff2:SetType(EFFECT_TYPE_QUICK_O)
					eff2:SetCode(EVENT_FREE_CHAIN)
					eff2:SetRange(LOCATION_HAND)
					eff2:SetValue(m)
					cregister(card,eff2,flag)
				elseif eff:IsHasType(EFFECT_TYPE_ACTIVATE) then
					eff:SetDescription(aux.Stringid(m,10))
				end
				return cregister(card,eff,flag)
			end
			return cregister(card,effect,flag)
		end
		for tc in aux.Next(g) do
			cm.proeffects={}
			cm.cloneeffects={}
			local _SetProperty=Effect.SetProperty
			local _Clone=Effect.Clone
			Effect.SetProperty=function(pe,prop1,prop2)
				if not prop2 then prop2=0 end
				if prop1&EFFECT_FLAG_UNCOPYABLE~=0 then
					cm.proeffects[pe]={prop1,prop2}
					prop1=prop1&(~EFFECT_FLAG_UNCOPYABLE)
				else
					cm.proeffects[pe]=nil
				end
				return _SetProperty(pe,prop1,prop2)
			end
			Effect.Clone=function(pe)
				local ce=_Clone(pe)
				cm.cloneeffects[ce]=true
				if cm.proeffects[pe] then
					cm.proeffects[ce]=cm.proeffects[pe]
				end
				return ce
			end
			tc:ReplaceEffect(tc:GetOriginalCode(),0)
			tc:SetStatus(STATUS_EFFECT_REPLACED,false)
			Effect.SetProperty=_SetProperty
			Effect.Clone=_Clone
			for ke,vp in pairs(cm.proeffects) do
				local prop1,prop2=table.unpack(vp)
				ke:SetProperty(prop1|EFFECT_FLAG_UNCOPYABLE,prop2)
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountLimit
		--Activate to field
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTargetRange(1,1)
		ge1:SetTarget(cm.actarget2)
		ge1:SetCost(cm.costchk)
		ge1:SetOperation(cm.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(e:GetHandler())
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_CHAINING)
		ge2:SetOperation(cm.op)
		Duel.RegisterEffect(ge2,0)
	end
	e:Reset()
end
function cm.costchk(e,te,tp)
	local tc=te:GetHandler()
	return (Duel.GetLocationCount(tp,LOCATION_SZONE)>0 or tc:IsType(TYPE_FIELD)) and tc:CheckActivateEffect(false,false,false)~=nil and (not tc:IsType(TYPE_PENDULUM) or Duel.CheckLocation(tp,LOCATION_SZONE,0) or Duel.CheckLocation(tp,LOCATION_SZONE,4))
end
function cm.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x13f) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and te:GetValue()==m
end
function cm.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	elseif tc:IsType(TYPE_PENDULUM) then
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	cm.activate_sequence[te]=tc:GetSequence()
	tc:CreateEffectRelation(te)
	if not tc:IsType(TYPE_EQUIP+TYPE_FIELD+TYPE_CONTINUOUS+TYPE_PENDULUM) then tc:CancelToGrave(false) end
	local te2=te:Clone()
	e:SetLabelObject(te2)
	te:SetType(26)
	tc:RegisterEffect(te2,true)
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(tc)
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
	re:Reset()
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local tp=rc:GetControler()
	--Debug.Message(re:GetDescription()-aux.Stringid(m,0))
	if rc:IsOriginalSetCard(0x13f) and rc:IsRelateToEffect(re) then
		rc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,11))
	end
	if rc:IsOriginalSetCard(0x13f) and rc:IsLocation(LOCATION_HAND) and rc:IsRelateToEffect(re) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(m,9))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e1,true)
		Duel.ConfirmCards(1-tp,rc)
	end
end