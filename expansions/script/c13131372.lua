--煎稽蛋
local m=13131372
local c13131372=_G["c"..m]
function c13131372.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c13131372.sptg)
	e1:SetOperation(c13131372.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY) 
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c13131372.ctcon)
	e3:SetTarget(c13131372.cttg)
	e3:SetOperation(c13131372.ctop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_REMOVE)
	e5:SetProperty(EFFECT_FLAG_DELAY) 
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,13131372)
	e5:SetCondition(c13131372.thcon)
	e5:SetTarget(c13131372.thtg)
	e5:SetOperation(c13131372.thop)
	c:RegisterEffect(e5)
end
function c13131372.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsCode,1,nil,13131370)
end
function c13131372.thgfil(c)
	return c:IsSetCard(0x3b00) and c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c13131372.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c13131372.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,tp,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c13131372.thgfil,tp,LOCATION_REMOVED,0,nil)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

function c13131372.spfilter(c,e,tp)
	return c:IsCode(13131370) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c13131372.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c13131372.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c13131372.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c13131372.spfilter),tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c13131372.ctfilter(c,tp)
	return c:IsFaceup() and c:IsCode(13131370)
end
function c13131372.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(c13131372.ctfilter,1,nil,tp)
end
function c13131372.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c13131372.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,13131370))
	e1:SetValue(100)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	Duel.RegisterEffect(e2,tp)
end