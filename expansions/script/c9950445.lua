--fate·超越X
function c9950445.initial_effect(c)
	c:SetUniqueOnField(1,0,9950445)
	 --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WARRIOR),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,9950445)
	e1:SetCondition(c9950445.spcon)
	e1:SetOperation(c9950445.spop)
	c:RegisterEffect(e1)
  --search
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,99504450)
	e1:SetTarget(c9950445.thtg)
	e1:SetOperation(c9950445.thop)
	c:RegisterEffect(e1)
	--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950445.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
	Duel.AddCustomActivityCounter(9950445,ACTIVITY_CHAIN,c9950445.chainfilter)
end
function c9950445.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950445,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950445,1))
end
function c9950445.chainfilter(re,tp,cid)
	return not (re:GetHandler():IsSetCard(0x9ba6) and re:IsActiveType(TYPE_MONSTER)
		and Duel.GetChainInfo(cid,CHAININFO_TRIGGERING_LOCATION)==LOCATION_HAND)
end
function c9950445.spfilter(c,tp)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) and c:IsSetCard(0x9ba6) and 
	c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and Duel.GetMZoneCount(tp,c)>0
end
function c9950445.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return (Duel.GetCustomActivityCount(9950445,tp,ACTIVITY_CHAIN)~=0
		or Duel.GetCustomActivityCount(9950445,1-tp,ACTIVITY_CHAIN)~=0)
		and Duel.IsExistingMatchingCard(c9950445.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,c,tp)
end
function c9950445.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c9950445.spfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,c,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c9950445.thfilter(c)
	return c:IsCode(9950528,9950555) and c:IsAbleToHand()
end
function c9950445.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950445.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950445.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9950445.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end