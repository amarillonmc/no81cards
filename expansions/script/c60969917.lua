--朋克世纪末主题演奏
function c60969917.initial_effect(c)
	--
	if c:GetOriginalCode()==60969917 then

	c:SetUniqueOnField(1,0,60969917)
	--activate from hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e0)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(c60969917.adjustop)
	c:RegisterEffect(e01)
	--change effect type
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD)
	e02:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e02:SetCode(60969917)
	e02:SetRange(LOCATION_SZONE)
	e02:SetTargetRange(1,0)
	c:RegisterEffect(e02)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetOperation(c60969917.activate)
	c:RegisterEffect(e1)
	--activate from hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x171))
	e2:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	if not c60969917.global_activate_check then
		c60969917.global_activate_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c60969917.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	end
end
function c60969917.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetValue()~=60969918 then return end
	if rc:IsLocation(LOCATION_MZONE) and rc:GetFlagEffect(60969917)==0 then
		rc:RegisterFlagEffect(60969917,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end
function c60969917.thfilter(c,e,tp,ft)
	return c:IsSetCard(0x171) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60969917.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60969917.thfilter,tp,LOCATION_DECK,0,nil,e,tp,ft)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60969917,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c60969917.filter(c)
	return c:IsSetCard(0x171) and not c:IsCode(60969917)
end
function c60969917.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return ((te:GetValue()==60969917 or te:GetValue()==60969919) and (not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),60969917) or tc:GetFlagEffect(60969917)~=0))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==60969918 and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),60969917) and not (te:IsHasType(EFFECT_TYPE_ACTIVATE) and tc:IsLocation(LOCATION_SZONE))) 
	--prevent quick activating on field
	or (te:GetValue()==60969919 and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_SZONE))
end
function c60969917.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c60969917.globle_check then
		c60969917.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c60969917.actarget)
		Duel.RegisterEffect(ge0,0)
		--Activate to field
		local ge1=Effect.CreateEffect(e:GetHandler())
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(c60969917.actarget2)
		ge1:SetOperation(c60969917.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
		local g=Duel.GetMatchingGroup(c60969917.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		esetcountLimit=Effect.SetCountLimit
		table_effect={}
		table_countlimit_flag=0
		table_countlimit_count=0
		Effect.SetCountLimit=function(effect,count,flag)
			table_countlimit_flag=flag
			table_countlimit_count=count
			return esetcountLimit(effect,count,flag)
		end
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if (table_countlimit_flag~=0 and table_countlimit_count==1) or effect:IsHasType(EFFECT_TYPE_IGNITION) or 
				(effect:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_QUICKPLAY)) then
					eff:SetValue(60969918)
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
						eff2:SetHintTiming(TIMING_END_PHASE,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					eff2:SetValue(60969917)
					--spell activate in hand
					if eff2:IsHasType(EFFECT_TYPE_ACTIVATE) and not card:IsType(TYPE_TRAP) and not card:IsType(TYPE_QUICKPLAY) then
						eff2:SetType(EFFECT_TYPE_QUICK_O)
						eff2:SetCode(EVENT_FREE_CHAIN)
						eff2:SetRange(LOCATION_HAND)
						eff2:SetValue(60969919)
						eff2:SetHintTiming(TIMING_END_PHASE,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			table_countlimit_flag=0
			table_countlimit_count=0
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(60969917,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		Effect.SetCountLimit=esetcountLimit
	end
	e:Reset()
end
function c60969917.actarget2(e,te,tp)
	local tc=te:GetHandler()
	e:SetLabelObject(te)
	return tc:IsSetCard(0x171) and te:IsHasType(EFFECT_TYPE_QUICK_O) and tc:IsLocation(LOCATION_HAND) and tc:IsType(TYPE_SPELL)
end
function c60969917.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	te:SetType(EFFECT_TYPE_ACTIVATE)
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
	ge3:SetOperation(c60969917.resetop)
	Duel.RegisterEffect(ge3,tp)
	local ge4=ge3:Clone()
	ge4:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(ge4,tp)
end
function c60969917.resetop(e,tp,eg,ep,ev,re,r,rp)
	if re==e:GetLabelObject() and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		re:SetType(EFFECT_TYPE_QUICK_O)
		e:Reset()
	end
end
