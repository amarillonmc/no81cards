--决斗怪兽试验场3
function c98942050.initial_effect(c)
	if c:GetOriginalCode()==98942050 then
	--show
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_INITIAL)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(0xff)
	e1:SetCountLimit(1,98942050+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c98942050.op)
	c:RegisterEffect(e1)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(c98942050.adjustop)
	c:RegisterEffect(e01)
	if not c98942050.global_activate_check then
		c98942050.global_activate_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c98942050.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	end
end
function c98942050.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,98942050)
end
function c98942050.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=98942051 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(98942050)==0 then
		rc:RegisterFlagEffect(98942050,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c98942050.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return ((te:GetValue()==98942050 or te:GetValue()==98942051) and (not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),98942050) or tc:GetFlagEffect(98942050)~=0))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==98942051 and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),98942050) and not (te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_SZONE)) and not tc:IsLocation(LOCATION_DECK)) 
	--prevent quick activating on field
	or (te:GetValue()==98942051 and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE))
	--unique check 
	or (te:GetValue()==98942051 and tc:IsCode(32692693) and tc:CheckUniqueOnField(tc:GetControler())==false)
end
function c98942050.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c98942050.globle_check then
		local c=e:GetHandler()
		--Debug.Message(c:CheckUniqueOnField(tp))
		--change effect type
		local e01=Effect.CreateEffect(c)
		e01:SetType(EFFECT_TYPE_FIELD)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
		e01:SetCode(98942050)
		e01:SetTargetRange(1,1)
		Duel.RegisterEffect(e01,0)
		--
		c98942050.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c98942050.actarget)
		Duel.RegisterEffect(ge0,0)
		local g=Duel.GetMatchingGroup(c98942050.filter,0,0xff,0xff,nil)
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
				if not effect:IsHasType(EFFECT_TYPE_CONTINUOUS) and con and effect:IsHasType(EFFECT_TYPE_QUICK_O) and effect:GetCode()==EVENT_FREE_CHAIN  then
					eff:SetValue(98942051)
					--effect edit
					local eff2=effect:Clone()
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
			tc:ReplaceEffect(98942050,0)
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
function c98942050.filter(c)
	return not c:IsCode(98942050) and not c:IsType(TYPE_SYNCHRO)
end