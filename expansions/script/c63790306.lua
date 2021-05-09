--Brightless Dagron Rose
function c63790306.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,63790306)
	e1:SetTarget(c63790306.sptg)
	e1:SetOperation(c63790306.spop)
	c:RegisterEffect(e1)
	--tohand
local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c63790306.thcon)
	e2:SetDescription(aux.Stringid(63790306,0))
	e2:SetCountLimit(1,63790307)
	e2:SetTarget(c63790306.thtg)
	e2:SetOperation(c63790306.thop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c63790306.tkcon)
	e3:SetDescription(aux.Stringid(63790306,1))
	e3:SetTarget(c63790306.tktg)
	e3:SetOperation(c63790306.tkop)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(c63790306.starget)
	e4:SetOperation(c63790306.soperation)
	c:RegisterEffect(e4)
end
function c63790306.tdfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x123) and not c:IsCode(63790306) and c:IsAbleToDeck()
end
function c63790306.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c63790306.tdfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c63790306.tdfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c63790306.tdfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c63790306.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end
function c63790306.thfilter(c)
	return c:IsSetCard(0X123) and c:IsAbleToHand() and not c:IsCode(63790306)
end
function c63790306.cfilter(c)
	return c:IsFaceup() and c:IsCode(71645242)
end
function c63790306.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c63790306.cfilter,tp,LOCATION_FZONE+LOCATION_GRAVE,0,1,nil)
end
function c63790306.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c63790306.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c63790306.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c63790306.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c63790306.wfilter(c)
	return c:IsFaceup() and c:IsCode(84335863)
	end
function c63790306.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c63790306.wfilter,tp,LOCATION_FZONE+LOCATION_GRAVE,0,1,nil)
end
function c63790306.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71645243,0,0x4011,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c63790306.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,71645243,0,0x4011,800,800,2,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_ATTACK) then
		local token=Duel.CreateToken(tp,76524507)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
function c63790306.sufilter(c,e,tp)
	return  c:IsSetCard(0x1123) and c:IsSummonable(true,nil)
end
function c63790306.starget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c63790306.sufilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c63790306.soperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
				local sg=Duel.SelectMatchingCard(tp,c63790306.sufilter,tp,LOCATION_HAND,0,1,1,nil)
				local sc=sg:GetFirst()
				if sc then
				Duel.Summon(tp,sc,true,nil)
	end
end
