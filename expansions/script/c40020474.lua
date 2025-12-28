--天人-主天使高达
local s,id=GetID()
--CB
s.named_with_CelestialBeing=1
function s.CelestialBeing(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CelestialBeing
end

function s.TransAm(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_TransAm
end
s.named_with_Kyrios=1
function s.Kyrios(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Kyrios
end
function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_BATTLE_START)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(TIMING_BATTLE_START,TIMING_BATTLE_START)
	e2:SetCondition(s.ritcon)
	e2:SetCost(s.ritcost)
	e2:SetTarget(s.rittg)
	e2:SetOperation(s.ritop)
	c:RegisterEffect(e2)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,3))
	e4:SetCategory(CATEGORY_EQUIP)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetTarget(s.eqtg)
	e4:SetOperation(s.eqop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e5)
end
function s.cfilter(c)
	return s.CelestialBeing(c) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local b1 = (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and Duel.GetTurnPlayer()==tp
	local b2 = (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE) and Duel.GetTurnPlayer()~=tp
	if not (b1 or b2) then return false end
	return Duel.GetMatchingGroupCount(s.cfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,nil)>=2
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.ritcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()

	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end

function s.ritcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHandAsCost() end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end

function s.ritfilter(c,e,tp)
	return s.TransAm(c) and bit.band(c:GetType(),TYPE_RITUAL+TYPE_MONSTER)==TYPE_RITUAL+TYPE_MONSTER
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end

function s.rittg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.ritfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp,e:GetHandler())>0 
		and Duel.IsExistingTarget(s.ritfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.ritfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.ritop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function s.eqfilter(c,tp)
	return c:IsLevel(3) and s.CelestialBeing(c) and c:IsType(TYPE_UNION) 
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end

function s.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,s.eqfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and aux.CheckUnionEquip(tc,c) and Duel.Equip(tp,ec,tc) then
		aux.SetUnionState(tc)
	end
end

function s.eqlimit(e,c)
	return c==e:GetOwner()
end


