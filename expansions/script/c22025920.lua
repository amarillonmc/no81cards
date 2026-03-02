--人理之基 帕里斯
function c22025920.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,22025920)
	e1:SetTarget(c22025920.sptg)
	e1:SetOperation(c22025920.spop)
	c:RegisterEffect(e1)
	--dis
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22025920,0))
	e2:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22025921)
	e2:SetCondition(c22025920.discon)
	e2:SetTarget(c22025920.distg)
	e2:SetOperation(c22025920.disop)
	c:RegisterEffect(e2)
	--dis ere
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(22025920,0))
	e3:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_DISABLE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,22025921)
	e3:SetCondition(c22025920.discon1)
	e3:SetCost(c22025920.erecost)
	e3:SetTarget(c22025920.distg)
	e3:SetOperation(c22025920.disop)
	c:RegisterEffect(e3)
end
function c22025920.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition()
end
function c22025920.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()

	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22025920.posfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22025920.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	Duel.SelectTarget(tp,c22025920.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22025920.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and tc:IsRelateToEffect(e) and tc:IsAttackPos() then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
end

function c22025920.discon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(22025820) and ep==tp
end
function c22025920.filter(c)
	return c:IsFaceup() 
end
function c22025920.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22025920.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22025920.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22025920.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c22025920.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local pdef=tc:GetDefense()
		local dg=Group.CreateGroup()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		Duel.AdjustInstantly(tc)
		local batk=tc:GetBaseAttack()
		local e3=e1:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		e3:SetValue(-2000)
		tc:RegisterEffect(e3)
			if pdef~=0 and tc:IsDefense(0) then dg:AddCard(tc) end
		if #dg>0 then
			Duel.BreakEffect()
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function c22025920.discon1(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsCode(22025820) and ep==tp and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22025920.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end