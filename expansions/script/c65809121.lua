--策略 殖民开垦
function c65809121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c65809121.cost)
	e1:SetTarget(c65809121.target)
	e1:SetOperation(c65809121.activate)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65809121,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCountLimit(1,65809121)
	e2:SetTarget(c65809121.tdtg)
	e2:SetOperation(c65809121.tdop)
	c:RegisterEffect(e2)
end
function c65809121.costfilter(c)
	return c:IsSetCard(0xca30) and c:IsType(TYPE_MONSTER)
end
function c65809121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function c65809121.spfilter(c,e,tp)
	return c:GetOwner()==1-tp and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65809121.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c65809121.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c65809121.costfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c65809121.costfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	e:SetLabel(g:GetFirst():GetOriginalCodeRule())
	Duel.ShuffleHand(tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c65809121.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65809121.spfilter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
	if g:GetCount()==0 then return end
	local code=e:GetLabel()
	for sc in aux.Next(g) do
		Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		sc:RegisterEffect(e1)
		sc:ReplaceEffect(code,RESET_EVENT+RESETS_STANDARD)
	end
	Duel.SpecialSummonComplete()
end
function c65809121.cfilter(c,e,tp,ft)
	return c:IsSetCard(0xaa30) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c65809121.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65809121.cfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and e:GetHandler():IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
end
function c65809121.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,c65809121.cfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if tc then
			if Duel.GetMZoneCount(tp)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false)
				and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,1152)==1) then
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			else
				Duel.SendtoHand(tc,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,tc)
			end
		end
	end
end
