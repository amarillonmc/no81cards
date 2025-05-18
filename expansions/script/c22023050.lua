--人理之基 保罗·班扬
function c22023050.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22023050,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,22023050)
	e1:SetCondition(c22023050.spcon1)
	e1:SetTarget(c22023050.sptg1)
	e1:SetOperation(c22023050.spop1)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22023050,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c22023050.atkop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22023050,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,22023051)
	e3:SetCondition(c22023050.spcon)
	e3:SetTarget(c22023050.sptg)
	e3:SetOperation(c22023050.spop)
	c:RegisterEffect(e3)
end
c22023050.effect_with_darkguda=true
function c22023050.cfilter(c)
	return c:IsFaceup() and c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK 
end
function c22023050.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c22023050.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c22023050.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22023050.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function c22023050.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.SelectOption(tp,aux.Stringid(22023050,2))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e1:SetValue(3000)
		c:RegisterEffect(e1)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() and not c:IsLevel(10) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CHANGE_LEVEL)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		e2:SetValue(10)
		c:RegisterEffect(e2)
	end
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e3=Effect.CreateEffect(c)
		e3:SetDescription(aux.Stringid(22023050,1))
		e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_PIERCE)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e3)
	end
end
function c22023050.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and r==REASON_FUSION and c:GetReasonCard():IsSetCard(0xff1)
end
function c22023050.spfilter(c,e,tp)
	return c:IsCode(22020000) and c:GetOriginalAttribute()==ATTRIBUTE_DARK and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22023050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c22023050.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c22023050.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c22023050.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end