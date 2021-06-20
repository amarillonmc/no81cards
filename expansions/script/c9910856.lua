--千恋触雪
function c9910856.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c9910856.target)
	e1:SetOperation(c9910856.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCondition(c9910856.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910856.sumtg)
	e2:SetOperation(c9910856.sumop)
	c:RegisterEffect(e2)
end
function c9910856.cfilter1(c,dg)
	if not c:IsSetCard(0xa951) or not c:IsAbleToGrave() or dg:GetCount()==0 then return false end
	local res=true
	if c:IsType(TYPE_MONSTER) then res=dg:IsExists(Card.IsLocation,1,nil,LOCATION_MZONE)
	elseif c:IsType(TYPE_SPELL) then res=dg:IsExists(Card.IsType,1,nil,TYPE_SPELL)
	else res=dg:IsExists(Card.IsType,1,nil,TYPE_TRAP) end
	return res
end
function c9910856.cfilter2(c)
	return c:IsSetCard(0xa951) and c:IsAbleToHand()
end
function c9910856.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local b1=Duel.IsExistingMatchingCard(c9910856.cfilter1,tp,LOCATION_DECK,0,1,nil,dg)
	local b2=Duel.IsExistingMatchingCard(c9910856.cfilter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		if Duel.GetTurnPlayer()==tp then
			op=Duel.SelectOption(tp,aux.Stringid(9910856,0),aux.Stringid(9910856,1),aux.Stringid(9910856,2))
		else
			op=Duel.SelectOption(tp,aux.Stringid(9910856,0),aux.Stringid(9910856,1))
		end
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9910856,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9910856,1))+1
	end
	e:SetLabel(op)
	if op~=0 then
		if op==1 then
			e:SetCategory(CATEGORY_TOHAND)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
		else
			e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE+CATEGORY_TOHAND)
			Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
			Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,0,0,0)
			Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
		end
	else
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DISABLE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,dg,0,0,0)
	end
end
function c9910856.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dg=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local op=e:GetLabel()
	if op~=1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,c9910856.cfilter1,tp,LOCATION_DECK,0,1,1,nil,dg)
		local tc=g:GetFirst()
		if tc and Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_GRAVE) then
			local sg=Group.CreateGroup()
			if tc:IsType(TYPE_MONSTER) then sg=dg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
			elseif tc:IsType(TYPE_SPELL) then sg=dg:Filter(Card.IsType,nil,TYPE_SPELL)
			else sg=dg:Filter(Card.IsType,nil,TYPE_TRAP) end
			local sc=sg:GetFirst()
			while sc do
				Duel.NegateRelatedChain(sc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e2)
				if sc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
					sc:RegisterEffect(e3)
				end
				sc=sg:GetNext()
			end
		end
	end
	if op~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910856.cfilter2),tp,LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
			local type1=tc:GetType()&0x7
			--inactivatable
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_INACTIVATE)
			e1:SetValue(c9910856.effectfilter)
			e1:SetLabel(type1)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_DISEFFECT)
			e2:SetValue(c9910856.effectfilter)
			e2:SetLabel(type1)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
			local d=math.log(type1,2)+3
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(9910856,d))
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e3:SetTargetRange(1,1)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
	if op==2 and Duel.GetTurnPlayer()==tp then
		Duel.BreakEffect()
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,1)
		Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	end
end
function c9910856.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local type1=e:GetLabel()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:IsActiveType(type1)
end
function c9910856.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c9910856.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910856.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910856.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910856.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910856.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
