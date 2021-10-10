--灵刀姬 露世pendulum
function c60001012.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--tohand(p1)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60001012,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1,60001012)
	e3:SetTarget(c60001012.target)
	e3:SetOperation(c60001012.operation)
	c:RegisterEffect(e3)
	--spsummon(p2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001012,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,60001012)
	e1:SetCondition(c60001012.spcon)
	e1:SetTarget(c60001012.sptg)
	e1:SetOperation(c60001012.spop)
	c:RegisterEffect(e1)
	--spsummon(m1)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(60001012,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e5:SetCountLimit(1,90001012)
	e5:SetCondition(c60001012.spcon1)
	e5:SetTarget(c60001012.sptg)
	e5:SetOperation(c60001012.spop1)
	c:RegisterEffect(e5)
	local e4=e5:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--spsummon(m2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60001012,3))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,90001012)
	e1:SetTarget(c60001012.lktg)
	e1:SetOperation(c60001012.lkop)
	c:RegisterEffect(e1)
end
function c60001012.filter(c)
	return c:IsSetCard(0x1624) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60001012.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60001012.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60001012.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60001012.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60001012.spfil(c)
	return c:GetSequence()<5
end
function c60001012.spcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c60001012.spfil,tp,LOCATION_MZONE,0,1,nil)
end
function c60001012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60001012.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60001012.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x1624) and not c:IsCode(60001012)
end
function c60001012.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60001012.cfilter1,1,nil)
end
function c60001012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c60001012.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c60001012.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60001012.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
