--异位魔的威压
function c10106012.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10106012,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,10106012)
	e2:SetTarget(c10106012.sptg)
	e2:SetOperation(c10106012.spop)
	c:RegisterEffect(e2) 
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10106012,1))
	e3:SetCategory(CATEGORY_TOHAND) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10106012.thcon)
	e3:SetTarget(c10106012.thtg)
	e3:SetOperation(c10106012.thop)
	c:RegisterEffect(e3)
end
function c10106012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10106012.cfilter,1,nil,tp)
end
function c10106012.cfilter(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c10106012.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_ONFIELD)
end
function c10106012.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
	   Duel.HintSelection(g)
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end
function c10106012.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 or Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,1-tp,0x10,0,1,nil,e,0,1-tp,false,false,POS_FACEUP,1-tp)) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	--has bug in ocgcore (find in 2018.7.12)
	--Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_GRAVE+LOCATION_HAND)
end
function c10106012.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetMatchingGroup(Card.IsCanBeSpecialSummoned,1-tp,0x12,0,nil,e,0,1-tp,false,false,POS_FACEUP,1-tp)
	if g:GetCount()>0 then
	   Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	   local sg=g:Select(1-tp,1,1,nil)
	   Duel.HintSelection(sg)
	   Duel.SpecialSummon(sg,0,1-tp,1-tp,false,false,POS_FACEUP)
	end
end
