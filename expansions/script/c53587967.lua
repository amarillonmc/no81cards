--北极天熊-七政
function c53587967.initial_effect(c)
	--c:SetUniqueOnField(1,0,53587967)
	--
	if c:GetOriginalCode()==53587967 then

	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(c53587967.adjustop)
	c:RegisterEffect(e01)
	if not c53587967.global_activate_check then
		c53587967.global_activate_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c53587967.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	end
	
end
function c53587967.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=53587968 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(53587967)==0 then
		rc:RegisterFlagEffect(53587967,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c53587967.thfilter(c,e,tp,ft)
	return c:IsSetCard(0x163) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c53587967.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53587967.thfilter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(53587967,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c53587967.filter(c)
	return c:IsSetCard(0x163) and not c:IsCode(53587967)
end
function c53587967.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return ((te:GetValue()==53587967 or te:GetValue()==53587969) and (not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),53587967) or tc:GetFlagEffect(53587967)~=0))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==53587968 and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),53587967) and not (te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_SZONE)) and not tc:IsLocation(LOCATION_DECK)) 
	--prevent quick activating on field
	or (te:GetValue()==53587969 and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE))
	--unique check 
	or (te:GetValue()==53587969 and tc:IsCode(32692693) and tc:CheckUniqueOnField(tc:GetControler())==false)
end
function c53587967.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c53587967.globle_check then
		local c=e:GetHandler()
		--local token=Duel.CreateToken(tp,53587967)
		--Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		--Debug.Message(c:CheckUniqueOnField(tp))
		Duel.ConfirmCards(0,c)
		Duel.Hint(HINT_CARD,0,53587967)
		--change effect type
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
		e01:SetCode(53587967)
		e01:SetTargetRange(1,1)
		Duel.RegisterEffect(e01,0)
		--activate from hand
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x163))
		e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
		Duel.RegisterEffect(e1,0)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
		Duel.RegisterEffect(e2,0)
		--SpecialSummon from ex
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_FREE_CHAIN)
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e3:SetHintTiming(TIMING_DRAW_PHASE+TIMING_BATTLE_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_BATTLE_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
		e3:SetTarget(c53587967.sptarget)
		e3:SetOperation(c53587967.spactivate)
		Duel.RegisterEffect(e3,0)
		local e4=e3:Clone()
		Duel.RegisterEffect(e4,1)
		--
		c53587967.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c53587967.actarget)
		Duel.RegisterEffect(ge0,0)
		--Activate to field
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c53587967.actarget2)
		ge1:SetOperation(c53587967.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local g=Duel.GetMatchingGroup(c53587967.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		csetuniqueonfield=Card.SetUniqueOnField
		cenablecounterpermit=Card.EnableCounterPermit
		ecreateeffect=Effect.CreateEffect
		esetcountLimit=Effect.SetCountLimit
		table_effect={}
		table_countlimit_flag=0
		table_countlimit_count=0
		Ursarctic_unit=nil
		Ursarctic_Creating=false
		Effect.CreateEffect=function(card)
			Ursarctic_Creating=true
			return ecreateeffect(card)
		end
		Effect.SetCountLimit=function(effect,count,flag)
			if not Ursarctic_Creating and count==1 and flag~=0 then
				local eff=table_effect[#table_effect-1]
				return esetcountLimit(eff,1,0)
			end
			table_countlimit_flag=flag
			table_countlimit_count=count
			return esetcountLimit(effect,count,flag)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				local con=eff:GetCondition()
				if not effect:IsHasType(EFFECT_TYPE_CONTINUOUS) and (
				   (table_countlimit_flag~=0 and table_countlimit_count==1) 
				   or effect:IsHasType(EFFECT_TYPE_IGNITION) 
				   or (con and effect:IsHasType(EFFECT_TYPE_QUICK_O) and effect:GetCode()==EVENT_FREE_CHAIN) 
				   or (effect:IsHasType(EFFECT_TYPE_SINGLE) and effect:IsHasType(EFFECT_TYPE_TRIGGER_O) and effect:GetCode()==EVENT_SPSUMMON_SUCCESS) 
				   or (effect:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_QUICKPLAY)) 
				   ) then
					eff:SetValue(53587968)
					--effect edit
					local eff2=effect:Clone()
					--id remove
					if table_countlimit_flag~=0 and table_countlimit_count==1 then
						esetcountLimit(eff2,1,0)
					end
					--spell speed 2
					if eff2:IsHasType(EFFECT_TYPE_IGNITION) then
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					--spell speed 2
					if con and eff2:IsHasType(EFFECT_TYPE_QUICK_O) and eff2:GetCode()==EVENT_FREE_CHAIN then
						eff2:SetCondition(
						function(e,tp,eg,ep,ev,re,r,rp)
							Ursarctic_GetCurrentPhase=Duel.GetCurrentPhase
							Duel.GetCurrentPhase=function() return PHASE_MAIN1 end
							local Ursarctic_boolean=con(e,tp,eg,ep,ev,re,r,rp)
							Duel.GetCurrentPhase=Ursarctic_GetCurrentPhase
							return Ursarctic_boolean
						end)
						eff2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					--release activate 
					if (eff2:IsHasType(EFFECT_TYPE_SINGLE) and eff2:IsHasType(EFFECT_TYPE_TRIGGER_O) and eff2:GetCode()==EVENT_SPSUMMON_SUCCESS) then
						local eff3=eff2:Clone()
						eff3:SetCode(EVENT_RELEASE)
						eff3:SetValue(53587967)
						table.insert(table_effect,eff3)
					end
					eff2:SetValue(53587967)
					--spell activate in hand
					if eff2:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_QUICKPLAY) then
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetRange(LOCATION_HAND)
						eff2:SetValue(53587969)
						eff2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			table_countlimit_flag=0
			table_countlimit_count=0
			Ursarctic_Creating=false
			return 
		end
		Card.SetUniqueOnField=function(card,s,o,int,location)
			Ursarctic_Unique=true
			return
		end
		Card.EnableCounterPermit=function(card,countertype,location)
			Ursarctic_Counter=countertype
			return
		end
		for tc in aux.Next(g) do
			table_effect={}
			Ursarctic_Counter=0
			Ursarctic_Unique=false
			tc:ReplaceEffect(53587967,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
			if Ursarctic_Counter~=0 then cenablecounterpermit(tc,Ursarctic_Counter) end
			if Ursarctic_Unique then csetuniqueonfield(tc,1,0,tc:GetOriginalCode()) end
		end
		Card.RegisterEffect=cregister
		Card.SetUniqueOnField=csetuniqueonfield
		Card.EnableCounterPermit=cenablecounterpermit
		Effect.CreateEffect=ecreateeffect
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function c53587967.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x163) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL)
end
function c53587967.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	local te2=te:Clone()
	tc:RegisterEffect(te2)
	te2:UseCountLimit(tp)
	te:SetType(EFFECT_TYPE_ACTIVATE)
	--tc:SetStatus(STATUS_EFFECT_ENABLED,true)
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
	end
	local ge3=Effect.CreateEffect(tc)
	ge3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	ge3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	ge3:SetCode(EVENT_CHAIN_SOLVED)
	ge3:SetLabelObject(te)
	ge3:SetReset(RESET_PHASE+PHASE_END)
	ge3:SetOperation(c53587967.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c53587967.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		e:Reset()
		re:Reset()
	end
end
function c53587967.sfilter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x163) and c:IsSpecialSummonable()
end
function c53587967.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c53587967.sfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c53587967.spactivate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c53587967.sfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummonRule(tp,sg:GetFirst())
	end
end
