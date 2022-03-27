--千恋触雪
function c9910856.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_REMOVE+CATEGORY_DISABLE)
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
function c9910856.cfilter1(c)
	return c:IsSetCard(0xa951) and c:IsDiscardable(REASON_EFFECT)
end
function c9910856.cfilter2(c)
	return c:IsSetCard(0xa951) and c:IsAbleToRemove()
end
function c9910856.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lab=Duel.GetFlagEffectLabel(tp,9910856)
	local b1=Duel.IsExistingMatchingCard(c9910856.cfilter1,tp,LOCATION_HAND,0,1,c)
		and Duel.IsPlayerCanDraw(tp,1) and (not lab or bit.band(lab,1)==0)
	local b2=Duel.IsExistingMatchingCard(c9910856.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c)
		and Duel.IsExistingMatchingCard(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,nil)
		and (not lab or bit.band(lab,2)==0)
	local b3=not lab or bit.band(lab,4)==0
	if chk==0 then return b1 or b2 or b3 end
end
function c9910856.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=1
	if Duel.GetFlagEffect(tp,9910864)~=0 then ct=2 end
	local dg=Duel.GetMatchingGroup(aux.NegateAnyFilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local lab=Duel.GetFlagEffectLabel(tp,9910856)
	local b1=Duel.IsExistingMatchingCard(c9910856.cfilter1,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsPlayerCanDraw(tp,2) and (not lab or bit.band(lab,1)==0)
	local b2=Duel.IsExistingMatchingCard(c9910856.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
		and dg:GetCount()>0 and (not lab or bit.band(lab,2)==0)
	local b3=not lab or bit.band(lab,4)==0
	if not (b1 or b2 or b3) then return end
	local sel=0
	local off=0
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(9910856,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(9910856,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(9910856,2)
			opval[off-1]=3
			off=off+1
		end
		local op=Duel.SelectOption(tp,table.unpack(ops))
		if opval[op]==1 then
			sel=sel+1
			b1=false
		elseif opval[op]==2 then
			sel=sel+2
			b2=false
		else
			sel=sel+4
			b3=false
		end
		ct=ct-1
	until ct==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(9910856,3))
	if bit.band(sel,1)~=0 then
		if Duel.DiscardHand(tp,c9910856.cfilter1,1,1,REASON_EFFECT+REASON_DISCARD,nil)~=0 then
			Duel.Draw(tp,2,REASON_EFFECT)
		end
		if not lab then
			lab=1
			Duel.RegisterFlagEffect(tp,9910856,RESET_PHASE+PHASE_END,0,1,1)
		else
			lab=lab+1
			Duel.SetFlagEffectLabel(tp,9910856,lab)
		end
	end
	if bit.band(sel,2)~=0 then
		local dct=dg:GetCount()
		if dct>2 then dct=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c9910856.cfilter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,dct,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local rct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_REMOVED)
		if rct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
			local sg=dg:Select(tp,rct,rct,nil)
			Duel.HintSelection(sg)
			local tc=sg:GetFirst()
				while tc do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e3)
				end
				tc=sg:GetNext()
			end
		end
		if not lab then
			lab=2
			Duel.RegisterFlagEffect(tp,9910856,RESET_PHASE+PHASE_END,0,1,2)
		else
			lab=lab+2
			Duel.SetFlagEffectLabel(tp,9910856,lab)
		end
	end
	if bit.band(sel,4)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetTargetRange(0xff,0)
		e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,9910850))
		e1:SetValue(-1)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,9910864,0,0,1)
		if not lab then
			lab=4
			Duel.RegisterFlagEffect(tp,9910856,RESET_PHASE+PHASE_END,0,1,4)
		else
			lab=lab+4
			Duel.SetFlagEffectLabel(tp,9910856,lab)
		end
	end
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
