--混沌病毒-美比乌斯
function c49951012.initial_effect(c)
--xyz summon
	aux.AddXyzProcedure(c,nil,1,3,c49951012.ovfilter,aux.Stringid(49951012,0),99,c49951012.xyzop)
	c:EnableReviveLimit() 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49951012,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,49951012)
	e1:SetCondition(c49951012.thcon)
	e1:SetTarget(c49951012.thtg)
	e1:SetOperation(c49951012.thop)
	c:RegisterEffect(e1)
	 local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(49951012,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,499510013)
	e2:SetCondition(c49951012.spcon2)
	e2:SetTarget(c49951012.sptg2)
	e2:SetOperation(c49951012.spop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49951012,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,499510014)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.exccon)
	e3:SetTarget(c49951012.destg)
	e3:SetOperation(c49951012.desop)
	c:RegisterEffect(e3)
end
function c49951012.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823) and c:IsLevel(1) and not c:IsCode(c49951012)
end
function c49951012.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,c49951012)==0 end
	Duel.RegisterFlagEffect(tp,c49951012,RESET_PHASE+PHASE_END,0,1)
end
function c49951012.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c49951012.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c49951012.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c49951012.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c49951012.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,nil)end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c49951012.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_HAND)
end
function c49951012.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
	if #g==0 then return end
	 local tc=Duel.GetFirstTarget()
	 if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c49951012.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c49951012.thfilter(c,e,tp)
	return c:IsSetCard(0x823) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c49951012.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c49951012.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c49951012.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c49951012.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c49951012.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x823)
end
function c49951012.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c49951012.sfilter(chkc,ft) end
	if chk==0 then return ft>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c49951012.sfilter,tp,LOCATION_MZONE,0,1,nil,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c49951012.sfilter,tp,LOCATION_MZONE,0,1,1,nil,ft)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c49951012.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end