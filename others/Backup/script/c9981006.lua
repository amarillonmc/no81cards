--烦人的神明-诹访子
function c9981006.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,99810060)
	e1:SetCondition(c9981006.spcon)
	c:RegisterEffect(e1)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9981006,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,9981006)
	e1:SetCondition(c9981006.descon)
	e1:SetCost(c9981006.descost)
	e1:SetTarget(c9981006.destg)
	e1:SetOperation(c9981006.desop)
	c:RegisterEffect(e1)
end
function c9981006.filter0(c)
	return c:IsFaceup() and c:GetLevel()==3 and c:IsAttribute(ATTRIBUTE_WATER) and not c:IsCode(9981006)
end
function c9981006.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9981006.filter0,c:GetControler(),LOCATION_MZONE,0,1,nil)
end
function c9981006.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5bc1) and c:IsType(TYPE_MONSTER)
end
function c9981006.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c9981006.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9981006.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),c,nil,1,REASON_COST)
end
function c9981006.filter(c)
	 return c:IsSetCard(0x5bc1) and c:IsType(TYPE_MONSTER) and c:GetCode()~=9981006 and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c9981006.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9981006.filter,tp,LOCATION_DECK,0,1,nil) end
end
function c9981006.desop(e,tp,eg,ep,ev,re,r,rp)
   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9981006.filter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc and tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectYesNo(tp,aux.Stringid(9981006,1))) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
