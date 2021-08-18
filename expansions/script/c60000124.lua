--休瓦尔扎
function c60000124.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c60000124.matfilter,2,2)   
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(60000124,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,60000124)
	e1:SetTarget(c60000124.thtg)
	e1:SetOperation(c60000124.thop)
	c:RegisterEffect(e1)
	--atk up 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c60000124.apcon)
	e2:SetValue(c60000124.apval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e3:SetCondition(c60000124.incon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c60000124.matfilter(c)
	return (c:IsLevel(1) and c:IsAttribute(ATTRIBUTE_EARTH)) or c:IsSetCard(0x56a9)
end
function c60000124.thfilter(c)
	return c:IsSetCard(0x36a0) and c:IsAbleToHand()
end
function c60000124.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000124.thfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetFlagEffect(tp,60000119)~=0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c60000124.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60000124.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60000124.apcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,60000124)>=3 and Duel.GetFlagEffect(tp,60000119)~=0 
end
function c60000124.apval(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(Card.IsCode,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,60000124)*1000
end
function c60000124.incon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFlagEffect(tp,60000119)~=0 
end





