--战车道少女·岛田爱里寿
function c9910145.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910145)
	e1:SetCost(c9910145.spcost)
	e1:SetTarget(c9910145.sptg)
	e1:SetOperation(c9910145.spop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910146)
	e2:SetTarget(c9910145.thtg)
	e2:SetOperation(c9910145.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910145.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c9910145.spfilter(c,e,tp)
	return c:IsSetCard(0x952) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910145.xfilter(c)
	return c9910145.spfilter(c) and c:IsType(TYPE_XYZ)
end
function c9910145.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and (c:IsAbleToDeck() or Duel.IsExistingTarget(c9910145.xfilter,tp,LOCATION_GRAVE,0,1,nil))
		and Duel.IsExistingMatchingCard(c9910145.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp) end
end
function c9910145.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local g=Duel.GetDecktopGroup(tp,1)
	local tc=g:GetFirst()
	if tc:IsSetCard(0x952) and tc:IsType(TYPE_MONSTER) then
		if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0
			and not tc:IsForbidden() then
			Duel.DisableShuffleCheck()
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c9910145.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,c,e,tp)
		local sc=g:GetFirst()
		if not sc or Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
		if not c:IsRelateToEffect(e) then return end
		Duel.BreakEffect()
		if not sc:IsType(TYPE_XYZ) then
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		else
			if c:IsAbleToDeck()
				and Duel.SelectOption(tp,aux.Stringid(9910145,0),aux.Stringid(9910145,1))==0 then
				Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
				Duel.Overlay(sc,Group.FromCards(c))
			end
		end
	end
end
function c9910145.thfilter(c)
	return c:IsSetCard(0x952) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and c:IsLevelBelow(6)
end
function c9910145.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910145.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910145.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910145.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
