--折纸使 六号实验体
function c9910046.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c9910046.sptg1)
	e1:SetOperation(c9910046.spop1)
	c:RegisterEffect(e1)
	--spsummon from hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910046,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,9910046)
	e2:SetCondition(c9910046.spcon)
	e2:SetTarget(c9910046.sptg2)
	e2:SetOperation(c9910046.spop2)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	e3:SetValue(c9910046.tnval)
	c:RegisterEffect(e3)
end
function c9910046.filter(c,ec,e,tp)
	if not c:IsCode(9910031) and not (c:IsSetCard(0x3950) and c:IsType(TYPE_MONSTER)) then return false end
	local g=Group.FromCards(c,ec)
	return g:IsExists(c9910046.ofilter,1,nil,g,e,tp)
end
function c9910046.ofilter(c,g,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and g:IsExists(Card.IsAbleToRemove,1,c)
end
function c9910046.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9910046.filter(chkc,c,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910046.filter,tp,LOCATION_GRAVE,0,1,nil,c,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectTarget(tp,c9910046.filter,tp,LOCATION_GRAVE,0,1,1,nil,c,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9910046.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local fg=(Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)+e:GetHandler()):Filter(Card.IsRelateToEffect,nil,e)
	if fg:GetCount()~=2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=fg:FilterSelect(tp,c9910046.ofilter,1,1,nil,fg,e,tp)
	if Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)>0 then Duel.Remove(fg-sg,POS_FACEUP,REASON_EFFECT) end
end
function c9910046.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2
	local b2=c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:GetFlagEffect(9910001)~=0
	return b1 or b2
end
function c9910046.spfilter(c)
	return c:IsSetCard(0x3950) and c:IsFaceup()
end
function c9910046.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c9910046.spfilter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9910046.spfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c9910046.spfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c9910046.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsAbleToHand() and Duel.SelectOption(tp,aux.Stringid(9910046,1),1104)==1 then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	else
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c9910046.tnval(e,c)
	return e:GetHandler():IsControler(c:GetControler()) and c:IsSetCard(0x3950)
end
