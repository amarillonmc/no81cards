--宇宙机灵
local s,id,o=GetID()
function c98920799.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--repeat attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920799,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCountLimit(1,id)
	e1:SetCost(c98920799.drcost)
	e1:SetTarget(c98920799.thtg)
	e1:SetOperation(c98920799.thop)
	c:RegisterEffect(e1)
end
function s.cfilter1(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_CYBERSE) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c98920799.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,150) end
	Duel.PayLPCost(tp,150)
end
function c98920799.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if chk==0 then return tc and tc:IsAbleToHand() and not tc:IsRace(RACE_CYBERSE) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tc,1,0,0)
end
function c98920799.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end