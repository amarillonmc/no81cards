--妖仙兽的罡风
local s,id,o=GetID()
function s.initial_effect(c)
	--adjust
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e01:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e01:SetCode(EVENT_ADJUST)
	e01:SetRange(0xff)
	e01:SetOperation(s.adjustop)
	c:RegisterEffect(e01)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	if not s.global_check then
		s.global_check=true
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_TO_HAND)
		e3:SetOperation(s.check)
		Duel.RegisterEffect(e3,0)
	end
end
function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==0
end
function s.filter(c,e,tp)
	return c:IsSetCard(0xb3) and (c:IsSummonable(true,nil) or (c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0))
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		if tc:IsSummonable(true,nil) and (not tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or Duel.SelectOption(tp,aux.Stringid(id,3),aux.Stringid(id,4))==0) then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.SpecialSummon(tc,SUMMON_TYPE_PENDULUM,tp,tp,false,false,POS_FACEUP)
		end
	end
	if Duel.GetTurnPlayer()==1-tp then
		--change effect type
		local e02=Effect.CreateEffect(e:GetHandler())
		e02:SetType(EFFECT_TYPE_FIELD)
		e02:SetCode(id)
		e02:SetTargetRange(LOCATION_MZONE,0)
		e02:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e02,tp)
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function s.cfilter(c,tp)
	return c:IsSetCard(0xb3) and c:IsPreviousControler(tp)
		and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function s.check(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(s.cfilter,1,nil,p) then Duel.RegisterFlagEffect(p,id,RESET_PHASE+PHASE_END,0,1) end
	end
end
function s.adjfilter(c)
	return c:IsSetCard(0xb3) and c:IsType(TYPE_MONSTER)
end
function s.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return (te:GetValue()==id and not tc:IsHasEffect(id))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==id+1 and tc:IsHasEffect(id)) 
end
function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		local c=e:GetHandler()
		--
		s.globle_check=true
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(s.actarget)
		Duel.RegisterEffect(ge0,0)
		local g=Duel.GetMatchingGroup(s.adjfilter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				--local eff=effect:Clone()
				local con=effect:GetCondition()
				if effect:IsHasType(EFFECT_TYPE_IGNITION) 
				   or (con and effect:IsHasType(EFFECT_TYPE_QUICK_O) and effect:GetCode()==EVENT_FREE_CHAIN) then
					--eff:SetValue(id+1)
					--effect edit
					local eff2=effect:Clone()
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
							Blacklotus_Yosenju_GetCurrentPhase=Duel.GetCurrentPhase
							Duel.GetCurrentPhase=function() return PHASE_MAIN1 end
							local Blacklotus_Yosenju_boolean=con(e,tp,eg,ep,ev,re,r,rp)
							Duel.GetCurrentPhase=Blacklotus_Yosenju_GetCurrentPhase
							return Blacklotus_Yosenju_boolean
						end)
						eff2:SetHintTiming(TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER,TIMING_DRAW_PHASE+TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
					end
					eff2:SetValue(id)
					table.insert(table_effect,eff2)
				end
				--table.insert(table_effect,eff)
			end
			return 
		end

		for tc in aux.Next(g) do
			table_effect={}
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
	end
	e:Reset()
end
