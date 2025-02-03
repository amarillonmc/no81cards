--arc-究极屏障
function c36700121.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c36700121.condition)
	e1:SetTarget(c36700121.target)
	e1:SetOperation(c36700121.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetHintTiming(TIMING_END_PHASE)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,36700121)
	e2:SetCondition(c36700121.thcon)
	e2:SetTarget(c36700121.thtg)
	e2:SetOperation(c36700121.thop)
	c:RegisterEffect(e2)
	if not c36700121.global_check then
		c36700121.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c36700121.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c36700121.checkfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsControler(tp)
end
function c36700121.checkop(e,tp,eg,ep,ev,re,r,rp)
	for p=0,1 do
		if eg:IsExists(c36700121.checkfilter,1,nil,p) then Duel.RegisterFlagEffect(p,36700121,RESET_PHASE+PHASE_END,0,1) end
	end
end
function c36700121.chkfilter(c)
	return c:IsSetCard(0xc22) and c:GetSequence()<5
end
function c36700121.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c36700121.chkfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c36700121.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end
function c36700121.cfilter(c)
	return c:IsSetCard(0xc22) and c:IsType(TYPE_FUSION) and c:IsFaceupEx()
end
function c36700121.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetTurnPlayer()==1-tp and 2 or 1
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,ct)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		tc:RegisterEffect(e2)
		local dg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
		if #dg>0 and Duel.GetMatchingGroupCount(c36700121.cfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)>=1 and Duel.SelectYesNo(tp,aux.Stringid(36700121,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=dg:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		end
	end
end
function c36700121.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,36700121)>0 and Duel.GetCurrentPhase()==PHASE_END
end
function c36700121.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() or c:IsSSetable() end
end
function c36700121.thop(e,tp,eg,ep,ev,re,r,rp)	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsAbleToHand() and (not c:IsSSetable() or Duel.SelectOption(tp,1190,1153)==0) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		Duel.SSet(tp,c)
	end
end
