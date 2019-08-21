--异位魔的威信
function c10106013.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0x1e0)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10106013,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,10106013)
	e2:SetTarget(c10106013.thtg)
	e2:SetOperation(c10106013.thop)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10106013,1))
	e3:SetCategory(CATEGORY_SUMMON) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c10106013.sumcon)
	e3:SetTarget(c10106013.sumtg)
	e3:SetOperation(c10106013.sumop)
	c:RegisterEffect(e3)
end
function c10106013.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c10106013.cfilter2,1,nil,tp)
end
function c10106013.cfilter2(c,tp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsControler(tp)
end
function c10106013.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10106013.sumfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c10106013.sumfilter(c)
	return c:IsSetCard(0x3338) and c:IsSummonable(true,nil)
end
function c10106013.sumop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,c10106013.sumfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	if tc then
	   Duel.Summon(tp,tc,true,nil)
	end
end
function c10106013.cfilter(c)
	return c:IsSetCard(0x3338) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c10106013.thfilter(c,ec)
	return c:IsAbleToHand() and c:IsLevel(ec:GetLevel()) and not c:IsCode(ec:GetCode()) and c:IsSetCard(0x3338)
end
function c10106013.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
	   local ec=eg:GetFirst()
	   return eg:GetCount()==1 and ec:IsControler(tp) and ec:IsFaceup() and ec:IsSetCard(0x3338) and Duel.IsExistingMatchingCard(c10106013.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,ec)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c10106013.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10106013.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,eg:GetFirst())
	if g:GetCount()>0 then
	   Duel.SendtoHand(g,nil,REASON_EFFECT)
	   Duel.ConfirmCards(1-tp,g)
	end
end