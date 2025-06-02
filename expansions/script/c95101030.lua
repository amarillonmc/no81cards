--受诅的罪人 格蕾特
function c95101030.initial_effect(c)
	aux.AddCodeList(c,95101001)
	--pendulum summon
	aux.EnablePendulumAttribute(c,false)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1160)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetCost(c95101030.regop)
	c:RegisterEffect(e0)
	--set/spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,95101030)
	e1:SetCondition(c95101030.spcon)
	e1:SetTarget(c95101030.sptg)
	e1:SetOperation(c95101030.spop)
	c:RegisterEffect(e1)
end
function c95101030.regop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(95101030,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c95101030.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(95101030)~=0
end
function c95101030.penfilter(c)
	return c:IsCode(95101031) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c95101030.spfilter(c,e,tp)
	return aux.IsCodeListed(c,95101001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c95101030.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,95101031)
	if chk==0 then return ((Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) and Duel.IsExistingMatchingCard(c95101030.penfilter,tp,LOCATION_DECK,0,1,nil) and not check) or (check and Duel.IsExistingMatchingCard(c95101030.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil)) end
end
function c95101030.spop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_PZONE,0,1,nil,95101031)
	if check then
		if Duel.GetMZoneCount(tp)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,c95101030.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
		if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
			if not g then return end
			Duel.BreakEffect()
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	else
		if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c95101030.penfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
