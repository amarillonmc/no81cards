--聖なる鎖
function c49811420.initial_effect(c)
	--globalcheck
	if c49811420.globalcheck==nil then
		c49811420.globalcheck=true
		c49811420.tableA={}
		c49811420.tableE={}
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e0:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e0:SetOperation(c49811420.resetcount)
		Duel.RegisterEffect(e0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetOperation(c49811420.addcounta)
		Duel.RegisterEffect(e1,0)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_CHAINING)
		e2:SetOperation(c49811420.addcounte)
		Duel.RegisterEffect(e2,0)
	end
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49811420,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e3:SetCountLimit(1,49811420)
	e3:SetCondition(c49811420.spcon)
	e3:SetCost(c49811420.cost)
	e3:SetTarget(c49811420.sptg)
	e3:SetOperation(c49811420.spop)	
	c:RegisterEffect(e3)
	--to deck and draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49811420,1))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c49811420.tdcon)
	e4:SetTarget(c49811420.tdtg)
	e4:SetOperation(c49811420.tdop)
	c:RegisterEffect(e4)
end
function c49811420.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c49811420.tableA={}
	c49811420.tableE={}
end
function c49811420.addcounta(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			local code=tc:GetCode()
			table.insert(c49811420.tableA,code)
			--Debug.Message(#c49811420.tableA)
		end
		tc=eg:GetNext()
	end
end
function c49811420.addcounte(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and re:IsActiveType(TYPE_MONSTER) then
			local code=tc:GetCode()
			table.insert(c49811420.tableE,code)
			--Debug.Message(#c49811420.tableE)
		end
		tc=eg:GetNext()
	end
end
function c49811420.spcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp then return false end
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) or ph==PHASE_MAIN2
end
function c49811420.filter(c)
	return c:IsCode(49811420,63515678) and c:IsAbleToRemoveAsCost()
end
function c49811420.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811420.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c49811420.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,1,e:GetHandler())
	e:SetLabelObject(g:GetFirst())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c49811420.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49811420.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local acount=#c49811420.tableA
	local ecount=#c49811420.tableE
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
	    if tc:IsType(TYPE_NORMAL) then
	    	--Debug.Message(acount)
	    	--Debug.Message(ecount)
	    	if acount>0 then
		    	--can not active effect before
		    	local e1=Effect.CreateEffect(c)
		    	e1:SetType(EFFECT_TYPE_FIELD)
		    	e1:SetCode(EFFECT_CANNOT_TRIGGER)
		    	e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		    	e1:SetReset(RESET_PHASE+PHASE_END)
		    	e1:SetTarget(c49811420.acttarget)
		    	Duel.RegisterEffect(e1,tp)
	    	end
	    	if ecount>0 then
	    		--Debug.Message(#c49811420.tableE)
		    	--cannot attack before
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_FIELD)
				e2:SetCode(EFFECT_CANNOT_ATTACK)
				e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
				e2:SetReset(RESET_PHASE+PHASE_END)
				e2:SetTarget(c49811420.atktarget)
				Duel.RegisterEffect(e2,tp)
			end
			--can not active effect later
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e3:SetCode(EVENT_ATTACK_ANNOUNCE)
			e3:SetLabelObject(c)
			e3:SetReset(RESET_PHASE+PHASE_END)
			e3:SetOperation(c49811420.actlimit)
			Duel.RegisterEffect(e3,0)
			--can not attack later
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
			e4:SetCode(EVENT_CHAINING)
			e4:SetLabelObject(c)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetOperation(c49811420.atklimit)
			Duel.RegisterEffect(e4,0)
		end
	end
end
function c49811420.atktarget(e,c)
	return c:IsCode(table.unpack(c49811420.tableE))
end
function c49811420.acttarget(e,c)
	return c:IsCode(table.unpack(c49811420.tableA))
end
function c49811420.actlimit(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			local code=tc:GetCode()
			--can not active effect
			local e1=Effect.CreateEffect(c)
		    e1:SetType(EFFECT_TYPE_FIELD)
		    e1:SetCode(EFFECT_CANNOT_TRIGGER)
		    e1:SetProperty(EFFECT_FLAG_IGNORE_RANGE)
		    e1:SetReset(RESET_PHASE+PHASE_END)
		    e1:SetLabel(code)
		    e1:SetTarget(c49811420.acttarget2)
		    Duel.RegisterEffect(e1,0)
		end
		tc=eg:GetNext()
	end
end
function c49811420.atklimit(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and re:IsActiveType(TYPE_MONSTER) then
			local code=tc:GetCode()
			--cannot attack
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_ATTACK)
			e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
			e2:SetReset(RESET_PHASE+PHASE_END)
			e2:SetLabel(code)
			e2:SetTarget(c49811420.atktarget2)
			Duel.RegisterEffect(e2,0)
		end
		tc=eg:GetNext()
	end
end
function c49811420.atktarget2(e,c)
	local code=e:GetLabel()
	return c:IsCode(code)
end
function c49811420.acttarget2(e,c)
	local code=e:GetLabel()
	return c:IsCode(code)
end
function c49811420.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c49811420.tdfilter(c,sc,attr)
	return c:IsAbleToDeck() and c:IsType(TYPE_NORMAL)
end
function c49811420.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811420.tdfilter,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_REMOVED)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c49811420.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c49811420.tdfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	if g:GetCount()==0 then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 then
		Duel.Draw(p,d,REASON_EFFECT)
	end
end