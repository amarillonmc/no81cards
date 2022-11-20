--芳香法师-水仙
function c22174899.initial_effect(c)
	--
	if c:GetOriginalCode()==22174899 then

	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(22174899,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE+TIMING_DRAW_PHASE)
	e0:SetCost(c22174899.spcost)
	e0:SetCondition(c22174899.spcon)
	e0:SetTarget(c22174899.sptg)
	e0:SetOperation(c22174899.spop)
	c:RegisterEffect(e0)
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(0xff)
	e1:SetOperation(c22174899.adjustop)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(22174899)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c22174899.adcon)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--summon
	--local e3=Effect.CreateEffect(c)
	--e3:SetCategory(CATEGORY_SUMMON)
	--e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	--e3:SetCode(EVENT_RECOVER)
	--e3:SetRange(LOCATION_MZONE)
	--e3:SetCountLimit(1)
	--e3:SetValue(22174898)
	--e3:SetCondition(c22174899.sumcon)
	--e3:SetTarget(c22174899.sumtg)
	--e3:SetOperation(c22174899.sumop)
	--c:RegisterEffect(e3)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetValue(22174898)
	e3:SetCondition(c22174899.immcon)
	e3:SetTarget(c22174899.immtg)
	e3:SetOperation(c22174899.immop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCountLimit(-1)
	e4:SetValue(22174899)
	c:RegisterEffect(e4)

	end
end

function c22174899.filter(c)
	return c:IsSetCard(0xc9) and c:IsType(TYPE_MONSTER) and not c:IsCode(22174899)
end
function c22174899.actarget(e,te,tp)
	--prevent activating
	local tc=te:GetHandler()
	return (te:GetValue()==22174899 and not Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),22174899))  
	--prevent normal activating beside S&T on field
	or (te:GetValue()==22174898 and Duel.IsPlayerAffectedByEffect(te:GetHandlerPlayer(),22174899)) 
end
function c22174899.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not c22174899.globle_check then
		c22174899.globle_check=true
		--
		local ge0=Effect.CreateEffect(e:GetHandler())
		ge0:SetType(EFFECT_TYPE_FIELD)
		ge0:SetCode(EFFECT_ACTIVATE_COST)
		ge0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge0:SetCost(aux.FALSE)
		ge0:SetTargetRange(1,1)
		ge0:SetTarget(c22174899.actarget)
		Duel.RegisterEffect(ge0,0)
		--
		local g=Duel.GetMatchingGroup(c22174899.filter,0,0xff,0xff,nil)
		cregister=Card.RegisterEffect
		table_effect={}
		Card.RegisterEffect=function(card,effect,flag)
			if effect then
				local eff=effect:Clone()
				if effect:GetCode()==EVENT_RECOVER then
					eff:SetValue(22174898)
					--effect edit
					local eff2=effect:Clone()
					--id remove
					eff2:SetCountLimit(-1,0)
					--
					eff2:SetValue(22174899)
					table.insert(table_effect,eff2)
				end
				table.insert(table_effect,eff)
			end
			return 
		end
		for tc in aux.Next(g) do
			table_effect={}
			tc:ReplaceEffect(22174899,0)
			Duel.CreateToken(0,tc:GetOriginalCode())
			for key,eff in ipairs(table_effect) do
				cregister(tc,eff)
			end
		end
		Card.RegisterEffect=cregister
		--setcard mentioned
		--local g=Duel.GetMatchingGroup(aux.TRUE,0,0xff,0xff,nil)
		--cregister=Card.RegisterEffect
		--csetcard=Card.IsSetCard
		--table_effect={}
		--Aroma_setcard_player=0
		--Aroma_setcard_ev=ev
		--Aroma_setcard_code=0
		--Aroma_setcard=false
		--Card.RegisterEffect=function(card,effect,flag)
		--  if effect and (effect:IsHasType(EFFECT_TYPE_IGNITION) or 
		--	effect:IsHasType(EFFECT_TYPE_ACTIVATE) or 
		--	effect:IsHasType(EFFECT_TYPE_QUICK_O) or 
		--	effect:IsHasType(EFFECT_TYPE_QUICK_F) or 
		--	effect:IsHasType(EFFECT_TYPE_TRIGGER_O) or 
		--	effect:IsHasType(EFFECT_TYPE_TRIGGER_F)) then
		--	local cost=effect:GetCost()
		--	local con=effect:GetCondition()
		--	local tg=effect:GetTarget()
		--	local eg=Group.CreateGroup()
		--	local re=Effect.CreateEffect(Aroma_setcard_handler)
		--	cregister(Aroma_setcard_handler,effect)
		--	if cost then cost(effect,Aroma_setcard_player,eg,0,Aroma_setcard_ev,re,r,0,0) end
		--	if con then con(effect,Aroma_setcard_player,eg,0,Aroma_setcard_ev,re,r,0) end
		--	if tg then tg(effect,Aroma_setcard_player,eg,0,Aroma_setcard_ev,re,r,0,0) end
		--	effect:Reset()
		--  end
		--  return 
		--end
		--Card.IsSetCard=function(card,setname)
		--  if bit.band(setname,0xc9)~=0 then
		--	Aroma_setcard=true 
		--  end
		--  return 
		--end
		--for tc in aux.Next(g) do
			--g:Remove(Card.IsCode,nil,tc:GetOriginalCode())
		--  Aroma_setcard_handler=tc
		--  Aroma_setcard_player=tc:GetControler()
		--  Duel.CreateToken(0,tc:GetOriginalCode())
		--  if Aroma_setcard then
		--	Aroma_setcard_code=Aroma_setcard_code|tc:GetOriginalCode()
		--	Aroma_setcard=false 
		--  end
		--end
		--Card.RegisterEffect=cregister
		--Card.IsSetCard=csetcard
	end
	e:Reset()
end

function c22174899.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22174899)==0 end
	c:RegisterFlagEffect(22174899,RESET_CHAIN,0,1)
end
function c22174899.spcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()~=tp and Duel.GetLP(tp)<=Duel.GetLP(1-tp)
end
function c22174899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22174899.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		Duel.Recover(tp,500,REASON_EFFECT)
	end
end
function c22174899.adcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function c22174899.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22174899.filter2(c)
	return c:IsRace(RACE_PLANT) and c:IsSummonable(true,nil)
end
function c22174899.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c22174899.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c22174899.filter2,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		--limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		e1:SetOperation(c22174899.limitop)
		Duel.RegisterEffect(e1,tp)
		--reset when negated
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_SUMMON_NEGATED)
		e2:SetOperation(c22174899.rstop)
		e2:SetLabelObject(e1)
		e2:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterEffect(e2,tp)
		--
		Duel.Summon(tp,g:GetFirst(),true,nil)
	end
end
function c22174899.limitop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c22174899.sumlimit)
	e1:SetLabel(tc:GetOriginalCode())
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	e:Reset()
end
function c22174899.sumlimit(e,c)
	return c:IsCode(e:GetLabel())
end
function c22174899.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
function c22174899.chainlm(e,ep,tp)
	return tp==ep
end
function c22174899.immcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c22174899.immtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c22174899.chainlm)
end
function c22174899.immop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(0xff,0xff)
	e1:SetTarget(c22174899.etarget)
	e1:SetValue(c22174899.efilter)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c22174899.etarget(e,c)
	return (c:IsSetCard(0xc9) and c:IsFaceup() and c:IsType(TYPE_MONSTER)) or 
		   (c:IsFaceup() and c:IsCode(5050644,15177750,16759958,22174899,28265983,29189613,40663548,92266279,96789758))
end
function c22174899.efilter(e,re)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
