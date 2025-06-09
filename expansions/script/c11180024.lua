--幻殇·噎裔
function c11180024.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,11180024)
	e0:SetTarget(c11180024.settg)
	e0:SetOperation(c11180024.setop)
	c:RegisterEffect(e0)
	--sp summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11180024,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11180024+1000)
	e1:SetTarget(c11180024.tgtg)
	e1:SetOperation(c11180024.tgop)
	c:RegisterEffect(e1)
	--to deck
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_EXTRA+LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,11180024+2000)
	e2:SetTarget(c11180024.tdtg)
	e2:SetOperation(c11180024.tdop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_REMOVE)
	e3:SetCountLimit(1,11180024+3000)
	e3:SetCondition(c11180024.spcon)
	e3:SetTarget(c11180024.sptg)
	e3:SetOperation(c11180024.spop)
	c:RegisterEffect(e3)
end
function c11180024.setfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11180024.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11180024.setfilter,tp,LOCATION_REMOVED,0,1,nil) end
end
function c11180024.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local tc=Duel.SelectMatchingCard(tp,c11180024.setfilter,tp,LOCATION_REMOVED,0,1,1,nil):GetFirst()
	if tc then Duel.SSet(tp,tc) end
end
function c11180024.tgfilter(c)
	return c:IsAbleToGrave() or c:IsAbleToRemove()
		and Duel.IsExistingMatchingCard(c11180024.thfilter,tp,LOCATION_DECK,0,1,nil,c)
end
function c11180024.thfilter(c,tc)
	local type=tc:GetType()&0x7
	return c:IsSetCard(0x3450,0x6450) and not c:IsType(type) and (c:IsAbleToHand() or c:IsSSetable())
end
function c11180024.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(c11180024.tgfilter,tp,LOCATION_HAND,0,1,c) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c11180024.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local g=Duel.SelectMatchingCard(tp,c11180024.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
		local tc=g:GetFirst()
		local ck=0
		if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
			if Duel.SendtoGrave(tc,REASON_EFFECT)>0 and tc:IsLocation(0x10) then ck=1 end
		else
			if Duel.Remove(tc,POS_FACEUP,0x40)>0 and tc:IsLocation(0x20) then ck=1 end
		end
		if ck==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,c11180024.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc)
			local tc2=g2:GetFirst()
			if tc2 then
				Duel.BreakEffect()
				Duel.SendtoHand(tc2,nil,0x40)
				Duel.ConfirmCards(1-tp,tc2)
			end
		end
	end
end
function c11180024.tdfilter(c,tp,loc,sc)
	return c:IsSetCard(0x3450) and c:IsFaceup() and c:IsAbleToDeck()
		and (Duel.GetMZoneCount(tp,c)>0 and loc&(LOCATION_REMOVED)>0
			or Duel.GetLocationCountFromEx(tp,tp,c,sc)>0 and loc&(LOCATION_EXTRA)>0)
end
function c11180024.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c11180024.tdfilter(chkc) end
	local c=e:GetHandler()
	local loc=c:GetLocation()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c11180024.tdfilter,tp,LOCATION_ONFIELD,0,1,nil,tp,loc,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c11180024.tdfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp,loc,c)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11180024.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0
		and tc:IsLocation(LOCATION_DECK+LOCATION_EXTRA)
		and c:IsRelateToEffect(e) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c11180024.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetOwner():IsSetCard(0x3450,0x6450)
end
function c11180024.spfilter(c,e,tp)
	return c:IsSetCard(0x3450) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11180024.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11180024.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11180024.filter2(c,tp)
	return c:IsAbleToGrave() or c:IsAbleToRemove()
end
function c11180024.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c11180024.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
		local tg=Duel.GetMatchingGroup(c11180024.filter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
		if #tg>0 and Duel.SelectYesNo(tp,aux.Stringid(11180024,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=tg:Select(tp,1,1,nil):GetFirst()
			Duel.BreakEffect()
			if tc and tc:IsAbleToGrave() and (not tc:IsAbleToRemove() or Duel.SelectOption(tp,1191,1192)==0) then
				Duel.SendtoGrave(tc,REASON_EFFECT)
			else
				Duel.Remove(tc,POS_FACEUP,0x40)
			end
		end
	end
end