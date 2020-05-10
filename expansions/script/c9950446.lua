--fate·超越X·Alter
function c9950446.initial_effect(c)
	aux.AddCodeList(c,9950555)
	c:SetUniqueOnField(1,0,9950446)
	  --synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsSetCard,0xba5),1)
	c:EnableReviveLimit()
 --special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,9950446)
	e2:SetCondition(c9950446.spcon)
	e2:SetOperation(c9950446.spop)
	c:RegisterEffect(e2)
 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950446,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,99504460)
	e1:SetTarget(c9950446.thtg)
	e1:SetOperation(c9950446.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
 --spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950446.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950446.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950446,0))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(9950446,1))
end
function c9950446.spfilter(c)
	return c:IsSetCard(0x9ba6) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c9950446.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return false end
	local g=Duel.GetMatchingGroup(c9950446.spfilter,tp,LOCATION_HAND,0,c)
	return g:CheckWithSumGreater(Card.GetLevel,8)
end
function c9950446.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9950446.spfilter,tp,LOCATION_HAND,0,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=g:SelectWithSumGreater(tp,Card.GetLevel,8)
	Duel.SendtoGrave(mg,nil,REASON_COST)
end
function c9950446.thfilter(c)
	return (aux.IsCodeListed(c,9950555) or c:IsCode(9950555)) and not c:IsCode(9950446)
		and c:IsAbleToHand()
end
function c9950446.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950446.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9950446.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950446.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end