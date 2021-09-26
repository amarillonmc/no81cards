--AKL-Missy.诗怀雅
function c82568080.initial_effect(c)
	--AddCounter
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_COUNTER+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,82568080)
	e2:SetCost(c82568080.ctcost)
	e2:SetTarget(c82568080.cttg)
	e2:SetOperation(c82568080.ctop)
	c:RegisterEffect(e2)
	--revive
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,82568180)
	e3:SetCondition(c82568080.spcon)
	e3:SetTarget(c82568080.sptg)
	e3:SetOperation(c82568080.spop)
	c:RegisterEffect(e3)
	--revive
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,82568180)
	e4:SetCondition(c82568080.spcon)
	e4:SetTarget(c82568080.sptg2)
	e4:SetOperation(c82568080.spop)
	c:RegisterEffect(e4)
end
function c82568080.tkfilter(c)
	return c:IsFaceup()
end
function c82568080.ctcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,400) end
	Duel.PayLPCost(tp,400)
end
function c82568080.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c82568080.tkfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c82568080.tkfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,1,0x5825,1)
end
function c82568080.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e)
  then  tc:AddCounter(0x5825,1)
	local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c82568080.lmfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3826) and not c:IsCode(82568080)
end
function c82568080.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c82568080.lmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c82568080.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(c82568080.lmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function c82568080.sptg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(c82568080.lmfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c82568080.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	 Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end