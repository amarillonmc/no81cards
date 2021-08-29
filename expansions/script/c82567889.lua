--方舟骑士·特异剪刀 卡夫卡
function c82567889.initial_effect(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,82567889)
	e1:SetCost(c82567889.adcost)
	e1:SetOperation(c82567889.adop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetCountLimit(1,82567889)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCost(c82567889.adcost)
	e2:SetOperation(c82567889.adop)
	c:RegisterEffect(e2)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567889,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_ATKCHANGE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,82567989)
	e4:SetTarget(c82567889.target2)
	e4:SetOperation(c82567889.operation2)
	c:RegisterEffect(e4)
	--xyz summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567889,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,82567988)
	e5:SetTarget(c82567889.target)
	e5:SetOperation(c82567889.operation)
	c:RegisterEffect(e5)
end
function c82567889.cfilter(c)
	return c:IsFaceup() 
end
function c82567889.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,1,REASON_COST)
end
function c82567889.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	Duel.BreakEffect()
	if Duel.IsExistingMatchingCard(c82567889.cfilter,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(82567889,2))  then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,c82567889.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	tc:AddCounter(0x5825,1)
end
end
end
function c82567889.xyzmfilter(e,c)
	return c:GetCounter(0x5825)>0
end
function c82567889.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x825) and c:IsType(TYPE_XYZ)
end
function c82567889.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x825) and c:IsType(TYPE_XYZ) and c:IsAttackAbove(500) and c:GetOverlayCount()==0
end
function c82567889.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x5825,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,0x5825,2,REASON_COST)
end
function c82567889.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82567889.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82567889.filter,tp,LOCATION_MZONE,0,1,nil)
		and e:GetHandler():IsCanOverlay() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82567889.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c82567889.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c82567889.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c82567889.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c82567889.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c82567889.filter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c82567889.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_CANNOT_DISABLE)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	Duel.SendtoHand(c,tp,REASON_EFFECT)
	end
end
function c82567889.tgfilter(c,tp,ec)
	local lg=Duel.GetMatchingGroup(c82567889.cfilter,tp,LOCATION_MZONE,0,nil)
	local mg=Group.FromCards(c)
	mg:Merge(lg)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c82567889.xfilter,tp,LOCATION_EXTRA,0,1,nil,mg) and c:GetCounter(0x5825)>0
end
function c82567889.tgfilter2(c,tp,ec)
	local lg=Duel.GetMatchingGroup(c82567889.cfilter,tp,LOCATION_MZONE,0,nil)
	local mg=Group.FromCards(c)
	mg:Merge(lg)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c82567889.xfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c82567889.xfilter(c,mg)
	return  c:IsXyzSummonable(mg,nil,2,99)
end
function c82567889.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c82567889.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,e:GetHandler()) or  Duel.IsExistingMatchingCard(c82567889.tgfilter2,tp,LOCATION_MZONE,0,1,nil,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567889.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=Duel.GetMatchingGroup(c82567889.cfilter,tp,LOCATION_MZONE,0,nil,tp)
	local mg=Duel.GetMatchingGroup(c82567889.tgfilter,tp,0,LOCATION_MZONE,nil,tp)
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp) then
		mg:Merge(lg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c82567889.xfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local lc=g:GetFirst()
		if lc then
			Duel.XyzSummon(tp,lc,mg,2,99)
		end
	end
end