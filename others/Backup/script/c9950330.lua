--神之指引
function c9950330.initial_effect(c)
	aux.AddCodeList(c,10000000,10000010,10000020)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950330,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c9950330.target)
	e2:SetOperation(c9950330.operation)
	c:RegisterEffect(e2)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_DIVINE))
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950330,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,9950330)
	e1:SetTarget(c9950330.thtg)
	e1:SetOperation(c9950330.thop)
	c:RegisterEffect(e1)
end
function c9950330.filter2(c,e,tp)
	return c:IsRace(RACE_DIVINE) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c9950330.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c9950330.filter2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c9950330.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9950330.filter2),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local grav=g:GetFirst():IsLocation(LOCATION_GRAVE)
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		if grav then Duel.Destroy(e:GetHandler(),REASON_EFFECT) end
	end
end
function c9950330.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,3,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950330.filter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c9950330.thop(e,tp,eg,ep,ev,re,r,rp)
	local t1=Duel.GetFirstMatchingCard(c9950330.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,10000000)
	if not t1 then return end
	local t2=Duel.GetFirstMatchingCard(c9950330.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,10000010)
	if not t2 then return end
	local t3=Duel.GetFirstMatchingCard(c9950330.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil,10000020)
	if not t3 then return end
	local g=Group.FromCards(t1,t2,t3)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end

