--幻梦灵兽 沙奈朵
function c33200107.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33200107)
	e1:SetCondition(c33200107.spcon1)
	e1:SetTarget(c33200107.sptg)
	e1:SetOperation(c33200107.spop)
	c:RegisterEffect(e1) 
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(c33200107.spcon2)
	c:RegisterEffect(e2)  
	--change type
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(33200107,0))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c33200107.cgtg)
	e3:SetOperation(c33200107.cgop)
	c:RegisterEffect(e3) 
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetCode(EVENT_CHAINING)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(c33200107.negcon)
	e4:SetTarget(c33200107.negtg)
	e4:SetOperation(c33200107.negop)
	c:RegisterEffect(e4)  
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,33200107)
	e5:SetCost(c33200107.thcost)
	e5:SetTarget(c33200107.thtg)
	e5:SetOperation(c33200107.thop)
	c:RegisterEffect(e5)
end

--e1
function c33200107.spfilter(c,e,tp,ft)
	return c:IsFaceup() and c:IsSetCard(0x324) and not c:IsCode(33200107) and c:IsAbleToHand()
		and (ft>0 or c:GetSequence()<5) and not c:IsType(TYPE_XYZ)
end
function c33200107.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingTarget(c33200107.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and not Duel.IsPlayerAffectedByEffect(tp,33200100)
end
function c33200107.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingTarget(c33200107.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft)
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	and Duel.IsPlayerAffectedByEffect(tp,33200100) 
end
function c33200107.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c33200107.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c33200107.spfilter,tp,LOCATION_MZONE,0,1,c,e,tp,ft) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c33200107.spfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,ft)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,tp,LOCATION_HAND)
end
function c33200107.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc and tc:IsRelateToEffect(e) and ft>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end

--e3
function c33200107.cgfilter(c,mc)
	return not c:IsAttribute(mc:GetAttribute()) and c:IsFaceup()
end
function c33200107.cgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c33200107.cgfilter(chkc,c) end
	if chk==0 then return 
	Duel.IsExistingTarget(c33200107.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler(),c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c33200107.cgfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler(),c)
end
function c33200107.cgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local att=tc:GetAttribute()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(att)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end

--e4
function c33200107.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsAttribute(e:GetHandler():GetAttribute()) 
		and Duel.IsChainNegatable(ev)
end
function c33200107.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.nbcon(tp,re) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c33200107.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

--e5
function c33200107.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x324) and c:IsAbleToGraveAsCost() and not c:IsCode(33200107)
end
function c33200107.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33200107.thfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c33200107.thfilter,1,1,REASON_COST)
end
function c33200107.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c33200107.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end