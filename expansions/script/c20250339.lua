--禁钉圣迹救赎机
function c20250339.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20250339,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,20250339)
	e1:SetCondition(c20250339.addcc)
	e1:SetTarget(c20250339.addct)
	e1:SetOperation(c20250339.addc)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c20250339.tctg)
	e2:SetOperation(c20250339.tcop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c) 
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(0)
	e4:SetCondition(c20250339.dckcon) 
	e4:SetOperation(c20250339.dckop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20250339,1)) 
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_CUSTOM+20250339) 
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,20250340)
	e5:SetCondition(c20250339.descon)
	e5:SetTarget(c20250339.target)
	e5:SetOperation(c20250339.activate)
	c:RegisterEffect(e5)
	--immune
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetOperation(c20250339.imop)
	c:RegisterEffect(e6)
end
function c20250339.imop(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():AddCounter(0x154a,2)
end
function c20250339.addcc(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c20250339.adfilter(c)
	return c:IsSetCard(0x54a) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c20250339.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20250339.adfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20250339.addc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c20250339.adfilter),tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20250339.tctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
	and Duel.IsCanRemoveCounter(tp,1,0,0x154a,1,REASON_EFFECT) end
end
function c20250339.tcop(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(20250339,2)) then
		Duel.RemoveCounter(tp,1,0,0x154a,1,REASON_EFFECT)
	end
end
function c20250339.dckcon(e,tp,eg,ep,ev,re,r,rp)
	local x=e:GetHandler():GetFlagEffect(20250339)
	return x~=e:GetHandler():GetCounter(0x154a)
end 
function c20250339.dckop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	c:ResetFlagEffect(20250339)
		local ct=c:GetCounter(0x154a)
		for i=1,ct do
		c:RegisterFlagEffect(20250339,RESET_EVENT+0x1fe0000,0,1)
	end
		if e:GetHandler():GetCounter(0x154a)==0 then
		Duel.RaiseEvent(e:GetHandler(),EVENT_CUSTOM+20250339,e,0,0,tp,0) 
	end
end
function c20250339.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetCounter(0x154a)==0 
end
function c20250339.filter(c,e,tp)
	return c:IsSetCard(0x54a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c20250339.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20250339.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c20250339.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=math.min((Duel.GetLocationCount(tp,LOCATION_MZONE)),2)
	if ft<=0 then return end
	local c=e:GetHandler()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c20250339.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)
	local g=Duel.GetMatchingGroup(Card.IsCanAddCounter,tp,LOCATION_MZONE,0,nil,0x154a,1)
	if ct==0 or g:GetCount()==0 then return end
		for i=1,ct do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local sg=g:Select(tp,1,1,nil)
			sg:GetFirst():AddCounter(0x154a,1)
		end
	end
end  