--孤星壳·刃锋
function c192.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xaa),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_DARK),1,63,true) 
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetCondition(c192.thcon)
	e1:SetTarget(c192.thtg)
	e1:SetOperation(c192.thop)  
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c192.efilter)
	e2:SetCondition(c192.imcon)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetCountLimit(1)
	e3:SetTarget(c192.tgtg)
	e3:SetOperation(c192.tgop)
	c:RegisterEffect(e3)
end
function c192.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c192.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_DECK)
end
function c192.thop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end

function c192.efilter(e,te)
	return te:GetOwner():GetControler()~=e:GetOwner():GetControler()
end
function c192.fil(c)
	return c:IsType(TYPE_FUSION)
end
function c192.imcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return  c:GetMaterial():IsExists(c192.fil,1,nil)
end
function c192.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,tp,LOCATION_DECK)
end
function c192.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local tc=Duel.GetFirstTarget()
	if not Duel.SendtoGrave(tc,REASON_EFFECT) then return end
	if tc:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_MONSTER) then 
	local x=Duel.SelectMatchingCard(1-tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_MONSTER)
	Duel.SendtoGrave(x,REASON_EFFECT+REASON_RULE)
	elseif tc:IsType(TYPE_SPELL) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL) then
	local x=Duel.SelectMatchingCard(1-tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL)
	Duel.SendtoGrave(x,REASON_EFFECT+REASON_RULE)
	elseif tc:IsType(TYPE_TRAP) and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_TRAP) then
	local x=Duel.SelectMatchingCard(1-tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_TRAP)
	Duel.SendtoGrave(x,REASON_EFFECT+REASON_RULE)
end
end
