--无垢的机械天使
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetProperty(0,EFFECT_FLAG2_COF)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	--e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetHintTiming(TIMING_BATTLE_PHASE,TIMING_BATTLE_PHASE)
	c:RegisterEffect(e2)
	--
	if not s.global_effect then
		s.global_effect=true
		--
		local Effect_IsHasType=Effect.IsHasType
		function Effect.IsHasType(e,type)
			if e:GetDescription() and e:GetDescription()==aux.Stringid(id,3) then 
				return type&(EFFECT_TYPE_FIELD+EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_ACTIONS)~=0
			end
			return Effect_IsHasType(e,type)
		end
		--
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_ACTIVATE_COST)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
		ge1:SetCost(s.costchk)
		ge1:SetTargetRange(1,0)
		ge1:SetTarget(s.actarget)
		ge1:SetOperation(s.costop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		Duel.RegisterEffect(ge2,1)
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
		and e:GetHandler():IsLocation(LOCATION_HAND) and Duel.GetCurrentChain()==0
end
function s.filter(c)
	return c:IsSetCard(0x2093) and c:GetType()&0x81==0x81 and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelAbove(0) and c:IsAbleToDeck()
		and c:IsFaceupEx()
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		local tc=g:GetFirst()
		if not tc then return false end
		local tdg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		if tc:IsLocation(LOCATION_HAND) and tdg:CheckWithSumGreater(Card.GetLevel,tc:GetLevel(),1,#tdg)
			and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=tdg:SelectWithSumGreater(tp,Card.GetLevel,tc:GetLevel(),1,#tdg)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end

-------------------------------Global Effect-------------------------------

function s.costchk(e,te_or_c,tp)
	local ph=Duel.GetCurrentPhase()
	local b1=ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE 
	local b2=e:GetHandler():IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b3=Duel.GetCurrentChain()==0
	return b1 and b2 and b3
end
function s.actarget(e,te,tp)
	local tc=te:GetHandler()
	if te:GetDescription() and te:GetDescription()==(aux.Stringid(id,3)) and tc:IsLocation(LOCATION_HAND) then
		e:SetLabelObject(te)
		return true
	end
	return false
end
function s.costop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local tc=te:GetHandler()
	local tp=te:GetHandlerPlayer()
	--
	if tc:IsType(TYPE_FIELD) then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	else
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,false)
		if not tc:IsType(TYPE_CONTINUOUS) then
			tc:CancelToGrave(false)
		end
	end
end
