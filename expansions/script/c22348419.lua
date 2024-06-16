--落穴扫尾
local m=22348419
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(c22348419.target)
	e1:SetOperation(c22348419.activate)
	c:RegisterEffect(e1)
	
end
function c22348419.thfilter(c)
	return c:IsSetCard(0x108a) and c:IsAbleToHand()
end
function c22348419.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c22348419.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348419.sumfilter,tp,LOCATION_HAND,0,1,nil,e)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348419.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	if chk==0 then return b1 or b2 or b3 end
end
function c22348419.sumfilter(c,e)
	return c:IsSetCard(0x108a) and (c:IsSummonable(true,nil) or c:IsMSetable(true,nil))
end
function c22348419.spfilter(c,e,tp)
	return c:IsSetCard(0x108a) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end


function c22348419.dcfilter2(c)
	return c:GetType()==TYPE_TRAP and c:IsDiscardable() and Duel.IsExistingMatchingCard(c22348419.sumfilter,tp,LOCATION_HAND,0,1,c,e)
end
function c22348419.dcfilter1(c,e,tp)
	return c:GetType()==TYPE_TRAP and c:IsDiscardable() and Duel.IsExistingMatchingCard(c22348419.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
end
function c22348419.activate(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c22348419.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b3=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348419.sumfilter,tp,LOCATION_HAND,0,1,nil,e)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c22348419.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
	local op=0
	if b1 then
		if (not b2 and not b3) or Duel.SelectYesNo(tp,aux.Stringid(22348419,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g=Duel.SelectMatchingCard(tp,c22348419.thfilter,tp,LOCATION_DECK,0,1,1,nil)
			if g:GetCount()>0 then
				Duel.SendtoHand(g,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g)
			end
			op=1
		end
	end
	if op~=0 and Duel.IsExistingMatchingCard(c22348419.dcfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) and (not b3 or Duel.SelectYesNo(tp,aux.Stringid(22348419,2))) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,c22348419.dcfilter1,1,1,REASON_DISCARD+REASON_EFFECT,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22348419.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		op=1
	end
	if op==0 and b2 and (not b3 or Duel.SelectYesNo(tp,aux.Stringid(22348419,2))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c22348419.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		op=1
	end
	if op~=0 and Duel.IsExistingMatchingCard(c22348419.dcfilter2,tp,LOCATION_HAND,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(22348419,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		Duel.DiscardHand(tp,c22348419.dcfilter2,1,1,REASON_DISCARD+REASON_EFFECT,nil,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,c22348419.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		local s1=tc and tc:IsSummonable(true,nil)
		local s2=tc and tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
		op=1
	end
	if op==0 and b3 and Duel.SelectYesNo(tp,aux.Stringid(22348419,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local tc=Duel.SelectMatchingCard(tp,c22348419.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
		local s1=tc and tc:IsSummonable(true,nil)
		local s2=tc and tc:IsMSetable(true,nil)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end


