--风雨协奏曲
local cm,m=GetID()
function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11451631,5))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e3=e1:Clone()
	e3:SetDescription(aux.Stringid(m,0))
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
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCode(EVENT_CUSTOM+11451409)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e2:SetCondition(cm.actcon)
	e2:SetCost(aux.bfgcost)
	e2:SetOperation(cm.actop)
	c:RegisterEffect(e2)
	--change code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e5:SetCondition(function(e) return e:GetHandler():GetSequence()<5 end)
	e5:SetTarget(function(e,c) return aux.GetColumn(c) and math.abs(aux.GetColumn(c)-aux.GetColumn(e:GetHandler()))==0 end) --and c~=e:GetHandler() end)
	e5:SetValue(11451631)
	e5:SetRange(LOCATION_SZONE)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetCode(EFFECT_ADD_CODE)
	e6:SetRange(LOCATION_DECK)
	e6:SetValue(11451631)
	c:RegisterEffect(e6)
	--spsummon
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(m,1))
	e7:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e7:SetCode(EVENT_REMOVE)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCondition(function(e) return e:GetHandler():GetSequence()<5 end)
	e7:SetTarget(cm.adtg)
	e7:SetOperation(cm.adop)
	c:RegisterEffect(e7)
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
	if not PNFL_TOFIELD_CHECK then
		PNFL_TOFIELD_CHECK=true
		local _Equip=Duel.Equip
		Duel.Equip=function(p,c,...)
			if not (c:IsControler(p) and c:IsLocation(LOCATION_SZONE)) then c:RegisterFlagEffect(11451409,RESET_CHAIN,0,1) c:RegisterFlagEffect(11451409,RESET_CHAIN,0,1) end
			local res=_Equip(p,c,...)
			if c:IsHasEffect(EFFECT_EQUIP_LIMIT) then
				c:ResetFlagEffect(11451409)
				cm.desop21(e,0,Group.FromCards(c),0,0,e,0,0)
			end
			return res
		end
		local _CRegisterEffect=Card.RegisterEffect
		function Card.RegisterEffect(c,e,bool)
			local res=_CRegisterEffect(c,e,bool)
			if e:GetCode()==EFFECT_EQUIP_LIMIT and c:GetFlagEffect(11451409)>0 then
				c:ResetFlagEffect(11451409)
				cm.desop21(e,0,Group.FromCards(c),0,0,e,0,0)
			end
			return res
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetCondition(cm.descon1)
		e1:SetOperation(cm.desop21)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(e2,0)
		local e11=e1:Clone()
		e11:SetCode(EVENT_SUMMON_NEGATED)
		Duel.RegisterEffect(e11,0)
		local e21=e1:Clone()
		e21:SetCode(EVENT_SPSUMMON_NEGATED)
		Duel.RegisterEffect(e21,0)
		local e3=e1:Clone()
		e3:SetCode(EVENT_MOVE)
		Duel.RegisterEffect(e3,0)
		local e4=e1:Clone()
		e4:SetCode(EVENT_CHAINING)
		e4:SetCondition(cm.descon31)
		e4:SetOperation(cm.desop31)
		Duel.RegisterEffect(e4,0)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetCode(EFFECT_CANNOT_SUMMON)
		e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e5:SetTargetRange(1,1)
		e5:SetTarget(cm.costchk1)
		Duel.RegisterEffect(e5,0)
	end
end
function cm.costchk1(e,c,tp,st)
	if bit.band(st,SUMMON_TYPE_DUAL)~=SUMMON_TYPE_DUAL then return false end
	if c:GetFlagEffect(11451409)==0 then c:RegisterFlagEffect(11451409,RESET_EVENT+RESETS_STANDARD,0,1) end
	return false
end
function cm.filter12(c,e)
	if not (c:IsOnField() and (c:IsFacedown() or c:IsStatus(STATUS_EFFECT_ENABLED))) or c:GetFlagEffect(11451409)>1 then return false end
	if e:GetCode()==EVENT_MOVE then
		local b1,g1=Duel.CheckEvent(EVENT_SUMMON_SUCCESS,true)
		local b2,g2=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
		return (not b1 or not g1:IsContains(c)) and (not b2 or not g2:IsContains(c)) and not c:IsPreviousLocation(LOCATION_ONFIELD)
	end
	return not ((e:GetCode()==EVENT_SUMMON_SUCCESS or e:GetCode()==EVENT_SUMMON_NEGATED) and c:GetFlagEffect(11451409)>0) and not c:IsPreviousLocation(LOCATION_SZONE)
end
function cm.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter12,1,nil,e)
end
function cm.desop21(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()>0 and Duel.GetFlagEffect(0,11451409)==0 then
		cm.desop31(e,tp,eg,ep,ev,re,r,rp)
	else
		Duel.RaiseEvent(eg,EVENT_CUSTOM+11451409,re,r,rp,ep,ev)
	end
end
function cm.descon31(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():GetFieldID()==re:GetHandler():GetRealFieldID()
end
function cm.desop31(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+11451409,re,r,rp,ep,ev)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetDecktopGroup(e:GetHandlerPlayer(),1):IsContains(e:GetHandler())
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local te=Duel.IsPlayerAffectedByEffect(tp,11451677)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return te and ft>0 end
	te:UseCountLimit(tp)
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
function cm.actfilter(c)
	return c:GetPreviousLocation()&LOCATION_ONFIELD==0 and c:IsOnField() and c:IsFaceup() and c:IsCode(11451631) --c:IsLocation(LOCATION_SZONE) and c:GetSequence()==5 and c:IsType(TYPE_FIELD) and 
end
function cm.actcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.actfilter,1,nil)
end
function cm.bfgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=eg:Filter(cm.actfilter,nil)
	if chk==0 then return #g>0 and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
	local tc=g:GetFirst()
	if #g>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		tc=g:Select(tp,1,1,nil)
	end
	Duel.HintSelection(Group.FromCards(tc))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(11451631)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x979)
end
function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetCountLimit(1)
	if Duel.GetCurrentPhase()==PHASE_STANDBY then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	end
	e1:SetCondition(cm.descon2)
	e1:SetTarget(cm.destg2)
	e1:SetOperation(cm.desop2)
	Duel.RegisterEffect(e1,tp)
end
function cm.descon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function cm.spfilter2(c,e,tp)
	for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
		if c:IsSpecialSummonable(sumtype) then return true end
	end
	return false
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,0xff,0,nil,e,tp)
	if chk==0 then return e:GetHandler():GetSequence()<5 and #sg>0 end
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter2),tp,0xff,0,nil,e,tp)
	if not c:IsRelateToEffect(e) or c:GetSequence()>=5 or #sg==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=sg:Select(tp,1,1,nil):GetFirst()
	for _,sumtype in pairs({0,SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK,SUMMON_TYPE_SPECIAL,SUMMON_VALUE_SELF}) do
		if tc:IsSpecialSummonable(sumtype) then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			c:RegisterEffect(e1)
			Duel.MoveSequence(c,5)
			--c:SetStatus(STATUS_EFFECT_ENABLED,true)
			Duel.SpecialSummonRule(tp,tc,sumtype)
			break
		end
	end
end