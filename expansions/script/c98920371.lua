--真传导恐兽
function c98920371.initial_effect(c)
	--spsummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98920371,0))
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_HAND)
	e0:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e0:SetCountLimit(1,98920371)
	e0:SetCost(c98920371.spcost)
	e0:SetCondition(c98920371.con)
	e0:SetTarget(c98920371.sptg)
	e0:SetOperation(c98920371.spop)
	c:RegisterEffect(e0)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920371,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98920372)
	e1:SetTarget(c98920371.thtg1)
	e1:SetOperation(c98920371.thop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
--pierce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e3)
end
function c98920371.thfilter(c)
	return c:IsRace(RACE_DINOSAUR) and c:IsLevelAbove(7) and c:IsAbleToHand()
end
function c98920371.thtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920371.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c98920371.thop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c98920371.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c98920371.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK)
end
function c98920371.con(e,c)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c98920371.filter,tp,0,LOCATION_MZONE,1,nil)
end
function c98920371.rfilter(c,tp)
	return Duel.GetMZoneCount(tp,c)>0 and c:IsRace(RACE_DINOSAUR)
end
function c98920371.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c98920371.rfilter,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,c98920371.rfilter,1,1,nil,tp)
	Duel.Release(g,REASON_COST)
end
function c98920371.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920371.posfilter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c98920371.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local g=Duel.GetMatchingGroup(c98920371.posfilter,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
		   Duel.ChangePosition(g,POS_FACEUP_DEFENSE)
		end
	end
end