--千恋魂刃
function c9910862.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCondition(aux.dscon)
	e1:SetTarget(c9910862.target)
	e1:SetOperation(c9910862.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCondition(c9910862.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910862.sumtg)
	e2:SetOperation(c9910862.sumop)
	c:RegisterEffect(e2)
end
function c9910862.filter(c)
	return c:IsSetCard(0xa951) and c:IsFaceup()
end
function c9910862.setfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c9910862.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local lab=Duel.GetFlagEffectLabel(tp,9910862)
	local b1=Duel.IsExistingMatchingCard(c9910862.setfilter,tp,0,LOCATION_MZONE,1,nil)
		and (not lab or bit.band(lab,1)==0)
	local b2=not lab or bit.band(lab,2)==0
	local b3=not lab or bit.band(lab,4)==0
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9910862.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910862.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		and (b1 or b2 or b3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910862.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c9910862.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1500)
	tc:RegisterEffect(e1)
	local ct=1
	if Duel.GetFlagEffect(tp,9910859)~=0 then ct=2 end
	local lab=Duel.GetFlagEffectLabel(tp,9910862)
	local b1=Duel.IsExistingMatchingCard(c9910862.setfilter,tp,0,LOCATION_MZONE,1,nil)
		and (not lab or bit.band(lab,1)==0)
	local b2=not lab or bit.band(lab,2)==0
	local b3=not lab or bit.band(lab,4)==0
	if not (b1 or b2 or b3) then return end
	Duel.BreakEffect()
	local sel=0
	local off=0
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(9910862,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(9910862,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(9910862,2)
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
	until ct==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(9910862,3))
	if bit.band(sel,1)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,c9910862.setfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		if not lab then
			lab=1
			Duel.RegisterFlagEffect(tp,9910862,RESET_PHASE+PHASE_END,0,1,1)
		else
			lab=lab+1
			Duel.SetFlagEffectLabel(tp,9910862,lab)
		end
	end
	if bit.band(sel,2)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910862.descon)
		e1:SetOperation(c9910862.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		if not lab then
			lab=2
			Duel.RegisterFlagEffect(tp,9910862,RESET_PHASE+PHASE_END,0,1,2)
		else
			lab=lab+2
			Duel.SetFlagEffectLabel(tp,9910862,lab)
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
		Duel.RegisterFlagEffect(tp,9910859,0,0,1)
		if not lab then
			lab=4
			Duel.RegisterFlagEffect(tp,9910862,RESET_PHASE+PHASE_END,0,1,4)
		else
			lab=lab+4
			Duel.SetFlagEffectLabel(tp,9910862,lab)
		end
	end
end
function c9910862.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil)
end
function c9910862.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,9910862)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c9910862.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c9910862.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910862.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910862.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910862.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910862.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
