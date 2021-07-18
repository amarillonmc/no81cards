--巡天望远镜 视界星痕号
function c9910647.initial_effect(c)
	--spsummon1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910647)
	e1:SetCost(c9910647.spcost)
	e1:SetTarget(c9910647.sptg)
	e1:SetOperation(c9910647.spop)
	c:RegisterEffect(e1)
	--spsummon2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910648)
	e2:SetTarget(c9910647.sptg2)
	e2:SetOperation(c9910647.spop2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c9910647.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c9910647.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910647.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c9910647.spfilter(c,e,tp)
	return c:IsCode(9910647) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910647.thfilter(c)
	return (c:IsCode(9910647) or aux.IsCodeListed(c,9910647) and c:IsType(TYPE_MONSTER)) and c:IsAbleToHand()
end
function c9910647.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c9910647.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
			or Duel.IsPlayerCanDraw(tp,1)
	end
end
function c9910647.spop2(e,tp,eg,ep,ev,re,r,rp)
	local sel=1
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,1-tp,LOCATION_HAND,0,nil,e,0,1-tp,false,false)
	Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(9910647,0))
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
		sel=Duel.SelectOption(1-tp,1213,1214)
	else
		sel=Duel.SelectOption(1-tp,1214)+1
	end
	if sel==0 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local sg=g:Select(1-tp,1,1,nil)
		if Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)~=0
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local pg=Duel.SelectMatchingCard(tp,c9910647.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
			if pg:GetCount()>0 then
				Duel.SpecialSummon(pg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	else
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
