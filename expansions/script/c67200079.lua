--异域公主 北河灯里
function c67200079.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,67200061,67200062,true,true)  
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c67200079.target)
	e1:SetOperation(c67200079.operation)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67200079,2))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,67200079)
	e2:SetCondition(c67200079.thcon)
	e2:SetTarget(c67200079.thtg)
	e2:SetOperation(c67200079.thop)
	c:RegisterEffect(e2)
	--disable field
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_DISABLE_FIELD)
	e4:SetValue(c67200079.disval)
	c:RegisterEffect(e4)  
end
--spsummon
function c67200079.filter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x673) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c67200079.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c67200079.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c67200079.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c67200079.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c67200079.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c67200079.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_MZONE)
end
function c67200079.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x673) and c:IsAbleToHand()
end
function c67200079.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c67200079.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c67200079.thfilter,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c67200079.thfilter,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c67200079.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
--
function c67200079.disval(e)
	local c=e:GetHandler()
	return c:GetColumnZone(LOCATION_ONFIELD,0)
end

