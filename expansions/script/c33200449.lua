--魔力联合 山茶花
function c33200449.initial_effect(c)
	--send to grave
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,33200449)
	e1:SetTarget(c33200449.sptg)
	e1:SetOperation(c33200449.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,33200450)
	e3:SetTarget(c33200449.tgtg)
	e3:SetOperation(c33200449.tgop)
	c:RegisterEffect(e3) 
end

--e1
function c33200449.spfilter(c,e,tp)
	return c:IsSetCard(0x329) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33200449.tdfilter(c,e,tp)
	return c:IsSetCard(0x3329) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c33200449.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c33200449.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0
		and Duel.IsExistingTarget(c33200449.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c33200449.tdfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c33200449.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,0)
end
function c33200449.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.GetMZoneCount(tp,e:GetHandler())>0 and Duel.IsExistingMatchingCard(c33200449.tdfilter,tp,LOCATION_MZONE,0,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,c33200449.tdfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if g:GetCount()>0 then 
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT) then 
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) 
			end
		end
	end
end

--e3
function c33200449.tgfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGrave()
end
function c33200449.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_DECK+LOCATION_HAND)
end
function c33200449.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMatchingGroupCount(c33200433.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,nil,TYPE_SPELL)>=2 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(1-tp,c33200433.tgfilter,1-tp,LOCATION_DECK+LOCATION_HAND,0,2,2,nil)
		if g:GetCount()~=0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	else
		if c:IsRelateToEffect(e) and c:IsAbleToHand() then
			Duel.SendtoHand(c,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,c)
		end
	end
end