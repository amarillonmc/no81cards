--星遗物所承载的未来
function c98940010.initial_effect(c)
	c:SetUniqueOnField(1,0,98940010)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c98940010.cost)
	e1:SetCountLimit(1,98940010)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_DECK)
	e2:SetOperation(c98940010.acop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetRange(LOCATION_HAND)   
	c:RegisterEffect(e3)
--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940010,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c98940010.condition2)
	e2:SetTarget(c98940010.target2)
	e2:SetOperation(c98940010.operation2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
--draw
	local e12=Effect.CreateEffect(c)
	e12:SetCategory(CATEGORY_TOHAND+CATEGORY_DRAW)
	e12:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EVENT_SUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_DELAY)
	e12:SetCondition(c98940010.drcon)
	e12:SetTarget(c98940010.drtg)
	e12:SetOperation(c98940010.drop)
	c:RegisterEffect(e12)
	local e13=e12:Clone()
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e13)
end
function c98940010.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940010.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c98940010.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
	end
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function c98940010.filter3(c,tp)
	return c:GetSummonPlayer()==tp
end
function c98940010.cfilter(c)
	return c:IsSetCard(0xfe) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost() and c:IsLocation(LOCATION_HAND)
end
function c98940010.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98940010.filter3,1,nil,1-tp) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c98940010.spfilter(c,e,sp)
	return c:IsSetCard(0xfe) and c:IsCanBeSpecialSummoned(e,0,sp,false,false)
end
function c98940010.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98940010.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c98940010.operation2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98940010.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabel(tc:GetCode())
		e1:SetTarget(c98940010.sumlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function c98940010.sumlimit(e,c,se,sump,sumtype,sumpos,targetp)
	return c:IsCode(e:GetLabel())
end
function c98940010.sumlimit1(e,c)
	return c:IsCode(e:GetLabel())
end
function c98940010.acop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft>0 then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function c98940010.filter5(c,tp)
	return c:GetSummonPlayer()==tp
end
function c98940010.setfilter(c)
	if not (c:IsSetCard(0xfe) and c:IsType(TYPE_TRAP+TYPE_SPELL) and not c:IsCode(98940010)) then return false end
	return c:IsSSetable()
end
function c98940010.drcon(e,tp,eg,ep,ev,re,r,rp)
	local ec=eg:GetFirst()
	return eg:IsExists(c98940010.filter5,1,nil,tp)
end
function c98940010.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98940010.setfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
end
function c98940010.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98940010.setfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsSSetable() then
			Duel.SSet(tp,tc)
			if tc:IsType(TYPE_TRAP) then
			  local e1=Effect.CreateEffect(e:GetHandler())
			  e1:SetType(EFFECT_TYPE_SINGLE)
			  e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			  e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			  tc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_QUICKPLAY) then
			   local e1=Effect.CreateEffect(e:GetHandler())
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			   e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			   e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			   tc:RegisterEffect(e1)
			else
			   local eff=tc:GetActivateEffect()
			   local eff2=eff:Clone()
			   eff:SetDescription(aux.Stringid(98940010,2))
			   eff2:SetProperty(eff2:GetProperty(),EFFECT_FLAG2_COF)
			   eff2:SetHintTiming(TIMING_END_PHASE,TIMING_END_PHASE)
			   eff2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			   tc:RegisterEffect(eff2)
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_CANNOT_SSET)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetTarget(c98940010.sumlimit1)
			e1:SetLabel(tc:GetCode())
			e1:SetTargetRange(1,0)
			Duel.RegisterEffect(e1,tp)
	end
end