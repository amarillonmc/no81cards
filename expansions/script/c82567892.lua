--方舟骑士·嗜斗刃鬼 炎客
function c82567892.initial_effect(c)
	--add conter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,82567892)
	e1:SetCondition(c82567892.con)
	e1:SetOperation(c82567892.ctop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,82567892)
	e2:SetCondition(c82567892.con)
	e2:SetOperation(c82567892.ctop)
	c:RegisterEffect(e2)
	--release
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,82567992)
	e3:SetCost(c82567892.cost)
	e3:SetTarget(c82567892.target)
	e3:SetOperation(c82567892.activate)
	c:RegisterEffect(e3)
	--tograve
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_RELEASE)
	e4:SetCountLimit(1,82567992)
	e4:SetCondition(c82567892.tgcon)
	e4:SetTarget(c82567892.tgtg)
	e4:SetOperation(c82567892.tgop)
	c:RegisterEffect(e4)
end
function c82567892.cfilter(c)
	return c:IsFaceup() 
end
function c82567892.dwfilter(c)
	return c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567892.dwfilter2(c)
	return not c:IsSetCard(0x825) and c:IsFaceup()
end
function c82567892.grfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c82567892.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c82567892.dwfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
		  and not Duel.IsExistingMatchingCard(c82567892.dwfilter2,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c82567892.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gr=Duel.GetMatchingGroupCount(c82567892.grfilter,tp,0,LOCATION_GRAVE,nil)
	local val=gr*100
	if c:IsFaceup() and c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c82567892.cfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82567892,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c82567892.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	tc:AddCounter(0x5825,1)
end
end
end
function c82567892.filter(c)
	return not (c:IsHasEffect(EFFECT_UNRELEASABLE_SUM) and c:IsHasEffect(EFFECT_UNRELEASABLE_NONSUM)) and c:GetCounter(0x5825)>0 and c:IsFaceup()
end
function c82567892.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCurrentPhase()~=PHASE_MAIN2 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c82567892.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c82567892.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82567892.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82567892.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c82567892.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_RELEASE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c82567892.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SUMMON)
end
function c82567892.tgfilter(c)
	return c:IsFaceup() and c:GetCounter(0x5825)>0 and c:IsAbleToGrave()
end
function c82567892.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c82567892.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
end
function c82567892.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c82567892.filter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
