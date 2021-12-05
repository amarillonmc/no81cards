--煌闪骑士团 莉诺
function c72412500.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,72412500+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c72412500.sprcon)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(72412500,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,72412501)
	e2:SetTarget(c72412500.thtg)
	e2:SetOperation(c72412500.thop)
	c:RegisterEffect(e2)
end
function c72412500.sprfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6727) 
end
function c72412500.sprfilter2(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_DARK)
end
function c72412500.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and ( Duel.IsExistingMatchingCard(c72412500.sprfilter,tp,LOCATION_MZONE,0,1,nil) or  Duel.IsExistingMatchingCard(c72412500.sprfilter2,tp,0,LOCATION_MZONE,1,nil))
end
function c72412500.thfilter(c)
	return not c:IsCode(72412500) and c:IsSetCard(0xe727) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()  
end
function c72412500.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412500.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c72412500.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c72412500.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
