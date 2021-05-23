--死守者的回望
function c9910345.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetCondition(c9910345.condition)
	e1:SetCost(c9910345.cost)
	e1:SetTarget(c9910345.target)
	e1:SetOperation(c9910345.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,9910345)
	e2:SetCondition(c9910345.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c9910345.sptg)
	e2:SetOperation(c9910345.spop)
	c:RegisterEffect(e2)
end
function c9910345.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp~=ep and Duel.GetCurrentChain()==0
end
function c9910345.rfilter(c)
	return c:IsSetCard(0x956) and c:IsType(TYPE_SYNCHRO)
end
function c9910345.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c9910345.rfilter,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c9910345.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c9910345.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
end
function c9910345.rmfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove(tp)
end
function c9910345.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local g2=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
	local g3=eg:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	Duel.NegateSummon(eg)
	local loc=0
	if g1 and g1:IsExists(Card.IsStatus,1,nil,STATUS_SUMMON_DISABLED) then loc=loc+LOCATION_HAND end
	if g2 and g2:IsExists(Card.IsStatus,1,nil,STATUS_SUMMON_DISABLED) then loc=loc+LOCATION_GRAVE end
	if g3 and g3:IsExists(Card.IsStatus,1,nil,STATUS_SUMMON_DISABLED) then loc=loc+LOCATION_EXTRA end
	if Duel.Destroy(eg,REASON_EFFECT)==0 or loc==0 then return end
	local g=Duel.GetMatchingGroup(c9910345.rmfilter,1-tp,loc,0,nil,1-tp)
	if g:GetCount()>0 and Duel.IsPlayerCanRemove(1-tp) and Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_REMOVED) then
		local c=e:GetHandler()
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		local tc=og:GetFirst()
		while tc do
			tc:RegisterFlagEffect(9910345,RESET_EVENT+RESETS_STANDARD,0,1)
			tc=og:GetNext()
		end
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(og)
		e1:SetCountLimit(1)
		e1:SetCondition(c9910345.retcon)
		e1:SetOperation(c9910345.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c9910345.retfilter(c)
	return c:GetFlagEffect(9910345)~=0
end
function c9910345.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():IsExists(c9910345.retfilter,1,nil)
end
function c9910345.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg1=g:Filter(c9910345.retfilter,nil,e:GetLabel())
	g:DeleteGroup()
	local g1=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_HAND)
	local g2=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_GRAVE)
	local sg2=sg1:Filter(Card.IsPreviousLocation,nil,LOCATION_EXTRA)
	local g3=sg2:Filter(Card.IsPreviousPosition,nil,POS_FACEUP)
	local g4=sg2:Filter(Card.IsPreviousPosition,nil,POS_FACEDOWN)
	if g1:GetCount()>0 then Duel.SendtoHand(g1,1-tp,REASON_EFFECT) end
	if g2:GetCount()>0 then Duel.SendtoGrave(g2,REASON_EFFECT+REASON_RETURN) end
	if g3:GetCount()>0 then Duel.SendtoExtraP(g3,1-tp,REASON_EFFECT) end
	if g4:GetCount()>0 then Duel.SendtoDeck(g4,1-tp,2,REASON_EFFECT) end
end
function c9910345.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c9910345.spfilter(c,e,tp)
	return c:IsLevelBelow(8) and c:IsRace(RACE_PLANT)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c9910345.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910345.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910345.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9910345.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910345.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
