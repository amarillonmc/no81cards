--末氏空骨 孤冠
function c33330501.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c33330501.atkcost1)
	e1:SetTarget(c33330501.atktg)
	e1:SetOperation(c33330501.atkop1)
	c:RegisterEffect(e1)
	--overskeleton!!!
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,33330501)
	e2:SetCondition(c33330501.skcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c33330501.sktg)
	e2:SetOperation(c33330501.skop)
	c:RegisterEffect(e2)
end
function c33330501.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33330501.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5552)
end
function c33330501.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33330501.atkfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33330501.atkfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33330501.atkfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33330501.atkop1(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c33330501.skconfil(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c33330501.skcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c33330501.skconfil,tp,LOCATION_MZONE,0,1,nil)
end
function c33330501.skfil(c,e,tp)
	return c:IsSetCard(0x5552) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33330501.sktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33330501.skfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c33330501.skop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c33330501.skfil,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end