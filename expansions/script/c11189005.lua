--湮潮的永颂
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x452)
	aux.AddCodeList(c,0x452)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetTarget(s.target)
	e0:SetOperation(s.activate)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.tdcon)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1193)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.rmfilter(c)
	return aux.IsCodeListed(c,0x452) and c:IsAbleToRemove()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x5454) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceupEx()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,2,nil) and Duel.GetFlagEffect(tp,id+o)==0
	local b2=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,id+o*2)==0
	if chk==0 then return (b1 or b2) and Duel.GetFlagEffect(tp,id)==0 end
	Duel.RegisterFlagEffect(tp,id+3,RESET_PHASE+PHASE_END,0,1)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK,0,2,nil) and Duel.GetFlagEffect(tp,id+o)==0
	local b2=Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,id+o*2)==0
	if not (b1 or b2) then return end
	local op=aux.SelectFromOptions(tp,{b1,1102},{b2,1152})
	if op==1 then
		Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK,0,2,2,nil)
		if #g==2 then
			Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,5))
			local pos=Duel.SelectOption(tp,aux.Stringid(id,6),aux.Stringid(id,7))
			if pos==0 then
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			else
				Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
			end
		end
		Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.RegisterFlagEffect(tp,id+o*2,RESET_PHASE+PHASE_END,0,1)
	end
end
function s.cfilter(c,tp)
	return c:IsSetCard(0x5454) and c:IsType(TYPE_MONSTER) and c:IsSummonLocation(LOCATION_EXTRA)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) and Duel.GetFlagEffect(tp,id+3)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,1-tp,LOCATION_ONFIELD)
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
function s.tdfilter(c)
	return c:IsSetCard(0x5454) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
	if #g==2 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		local og=Duel.GetOperatedGroup()
		if og:IsExists(Card.IsLocation,2,nil,LOCATION_DECK+LOCATION_EXTRA) then
			if c:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
				Duel.BreakEffect()
				c:AddCounter(0x5454,1)
			end
		end
	end
end