--结缘的永夏 鸣濑白羽
function c9910964.initial_effect(c)
	c:EnableCounterPermit(0x6954)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910964,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910964)
	e1:SetCondition(c9910964.spcon)
	e1:SetTarget(c9910964.sptg)
	e1:SetOperation(c9910964.spop)
	c:RegisterEffect(e1)
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,9910994)
	e2:SetCondition(c9910964.rmcon)
	e2:SetTarget(c9910964.rmtg)
	e2:SetOperation(c9910964.rmop)
	c:RegisterEffect(e2)
end
function c9910964.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsReason,1,nil,REASON_EFFECT)
end
function c9910964.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local pchk=0
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then pchk=1 end
	e:SetLabel(pchk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910964.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 and e:GetLabel()==1 then
		Duel.BreakEffect()
		c:AddCounter(0x6954,1)
	end
end
function c9910964.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_MONSTER) and (LOCATION_HAND+LOCATION_GRAVE)&loc~=0
end
function c9910964.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	if bit.band(loc,LOCATION_HAND)~=0 then loc=LOCATION_HAND
	elseif bit.band(loc,LOCATION_GRAVE)~=0 then loc=LOCATION_GRAVE
	else loc=0 end
	if chk==0 then return loc>0 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,loc,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,loc,1,nil) end
	e:SetLabel(loc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,0,loc)
end
function c9910964.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=e:GetLabel()
	if not loc or bit.band(loc,LOCATION_HAND+LOCATION_GRAVE)==0 then return end
	local rg=Group.CreateGroup()
	if loc==LOCATION_HAND then
		local g1=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND,0,nil)
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_HAND,nil)
		if #g1>0 and #g2>0 then
			rg=g1:RandomSelect(tp,1)
			local sg2=g2:RandomSelect(tp,1)
			rg:Merge(sg2)
		end
	else
		local g3=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_GRAVE,0,nil)
		local g4=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,nil)
		if #g3>0 and #g4>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			rg=g3:Select(tp,1,1,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local sg4=g4:Select(tp,1,1,nil)
			rg:Merge(sg4)
			Duel.HintSelection(rg)
		end
	end
	if #rg>0 and Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
		local fid=c:GetFieldID()
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
			oc:RegisterFlagEffect(9910964,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,fid)
			oc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		if Duel.GetCurrentPhase()==PHASE_STANDBY then
			e1:SetLabel(fid,Duel.GetTurnCount())
			e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		else
			e1:SetLabel(fid,0)
			e1:SetReset(RESET_PHASE+PHASE_STANDBY)
		end
		e1:SetLabelObject(og)
		e1:SetCondition(c9910964.retcon)
		e1:SetOperation(c9910964.retop)
		Duel.RegisterEffect(e1,tp)
		if c:IsRelateToChain() and c:GetCounter(0x6954)>0
			and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(9910964,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,1,nil,nil)
			Duel.SynchroSummon(tp,g:GetFirst(),nil)
		end
	end
end
function c9910964.retfilter(c,fid)
	return c:GetFlagEffectLabel(9910964)==fid
end
function c9910964.retcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	if not g:IsExists(c9910964.retfilter,1,nil,lab1) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return Duel.GetTurnCount()~=lab2 end
end
function c9910964.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local lab1,lab2=e:GetLabel()
	local sg=g:Filter(c9910964.retfilter,nil,lab1)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		local loc=tc:GetPreviousLocation()
		if loc==LOCATION_HAND then
			Duel.SendtoHand(tc,tc:GetPreviousControler(),REASON_EFFECT)
		end
		if loc==LOCATION_GRAVE then
			Duel.SendtoGrave(tc,REASON_EFFECT+REASON_RETURN)
		end
		tc=sg:GetNext()
	end
end
