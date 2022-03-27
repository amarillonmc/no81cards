--千恋觅星
function c9910855.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c9910855.target)
	e1:SetOperation(c9910855.activate)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMING_BATTLE_START)
	e2:SetCondition(c9910855.sumcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910855.sumtg)
	e2:SetOperation(c9910855.sumop)
	c:RegisterEffect(e2)
end
function c9910855.sumfilter(c)
	return c:IsSetCard(0xa951) and c:IsSummonable(true,nil)
end
function c9910855.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lab=Duel.GetFlagEffectLabel(tp,9910855)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and (not lab or bit.band(lab,1)==0)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and (not lab or bit.band(lab,2)==0)
	local b3=not lab or bit.band(lab,4)==0
	if chk==0 then return b1 or b2 or b3 end
end
function c9910855.thfilter(c)
	return c:IsSetCard(0xa951) and c:IsAbleToHand()
end
function c9910855.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=1
	if Duel.GetFlagEffect(tp,9910863)~=0 then ct=2 end
	local lab=Duel.GetFlagEffectLabel(tp,9910855)
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5 and (not lab or bit.band(lab,1)==0)
	local b2=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
		and (not lab or bit.band(lab,2)==0)
	local b3=not lab or bit.band(lab,4)==0
	if not (b1 or b2 or b3) then return end
	local sel=0
	local off=0
	repeat
		local ops={}
		local opval={}
		off=1
		if b1 then
			ops[off]=aux.Stringid(9910855,0)
			opval[off-1]=1
			off=off+1
		end
		if b2 then
			ops[off]=aux.Stringid(9910855,1)
			opval[off-1]=2
			off=off+1
		end
		if b3 then
			ops[off]=aux.Stringid(9910855,2)
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
	until ct==0 or off<3 or not Duel.SelectYesNo(tp,aux.Stringid(9910855,3))
	if bit.band(sel,1)~=0 then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:IsExists(c9910855.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9910855,4)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,c9910855.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
		end
		Duel.ShuffleDeck(tp)
		if not lab then
			lab=1
			Duel.RegisterFlagEffect(tp,9910855,RESET_PHASE+PHASE_END,0,1,1)
		else
			lab=lab+1
			Duel.SetFlagEffectLabel(tp,9910855,lab)
		end
	end
	if bit.band(sel,2)~=0 then
		local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		if Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)~=0 and sg:GetFirst():IsLocation(LOCATION_REMOVED) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local g2=Duel.SelectMatchingCard(tp,c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			local tc=g2:GetFirst()
			if tc then Duel.Summon(tp,tc,true,nil) end
		end
		if not lab then
			lab=2
			Duel.RegisterFlagEffect(tp,9910855,RESET_PHASE+PHASE_END,0,1,2)
		else
			lab=lab+2
			Duel.SetFlagEffectLabel(tp,9910855,lab)
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
		Duel.RegisterFlagEffect(tp,9910863,0,0,1)
		if not lab then
			lab=4
			Duel.RegisterFlagEffect(tp,9910855,RESET_PHASE+PHASE_END,0,1,4)
		else
			lab=lab+4
			Duel.SetFlagEffectLabel(tp,9910855,lab)
		end
	end
end
function c9910855.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c9910855.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function c9910855.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910855.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
