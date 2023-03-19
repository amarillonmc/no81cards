--战斗型机天使接合体
function c18155031.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c18155031.mfilter1,c18155031.mfilter2,true)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(18155031,1))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,18155031)
	e1:SetTarget(c18155031.settg)
	e1:SetOperation(c18155031.setop)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(18155031,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,18155032)
	e2:SetCondition(c18155031.thcon)
	e2:SetTarget(c18155031.thtg)
	e2:SetOperation(c18155031.thop)
	c:RegisterEffect(e2)
end
c18155031.material_type=TYPE_SYNCHRO
function c18155031.mfilter1(c)
	return c:IsFusionType(TYPE_SYNCHRO) and c:IsSetCard(0x7bc2)
end
function c18155031.mfilter2(c)
	return c:IsFusionType(TYPE_RITUAL) and c:IsSetCard(0x7bc2)
end
function c18155031.filter(c)
	return c:IsCode(36484016) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c18155031.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c18155031.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
end
function c18155031.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c18155031.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.SSet(tp,tc)
	end
end
function c18155031.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO or c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION 
end
function c18155031.thfilter(c)
	return c:IsSetCard(0x7bc2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c18155031.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c18155031.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c18155031.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c18155031.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end