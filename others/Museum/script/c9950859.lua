--嵌合电子食人魔
function c9950859.initial_effect(c)
 aux.AddCodeList(c,64268668)
--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950859,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9950859)
	e1:SetCost(c9950859.cost)
	e1:SetTarget(c9950859.target)
	e1:SetOperation(c9950859.operation)
	c:RegisterEffect(e1)
	--fusion substitute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_FUSION_SUBSTITUTE)
	e2:SetCondition(c9950859.subcon)
	c:RegisterEffect(e2)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(aux.bfgcost)
	e1:SetCountLimit(1,99508590)
	e1:SetCode(EVENT_ATTACK_DISABLED)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetTarget(c9950859.target2)
	e1:SetOperation(c9950859.operation2)
	c:RegisterEffect(e1)
end
function c9950859.subcon(e)
	return e:GetHandler():IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
end
function c9950859.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c9950859.filter(c)
	return c:IsCode(64268668) and c:IsAbleToHand()
end
function c9950859.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950859.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c9950859.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9950859.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,3,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9950859.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==eg:GetFirst() end
	if chk==0 then return eg:GetFirst():IsFaceup() and eg:GetFirst():IsCanBeEffectTarget(e) end
	Duel.SetTargetCard(eg:GetFirst())
end
function c9950859.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetFlagEffect(9950859)==0 then
		tc:RegisterFlagEffect(9950859,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_BATTLE_START)
		e2:SetCountLimit(1)
		e2:SetOperation(c9950859.atkop)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c9950859.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(e:GetHandler():GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_DAMAGE)
	e:GetHandler():RegisterEffect(e1)
end

