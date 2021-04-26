--幻异梦物-猫
xpcall(function() require("expansions/script/c71400001") end,function() require("script/c71400001") end)
function c71400044.initial_effect(c)
	--summon limit
	yume.AddYumeSummonLimit(c)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400044,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c71400044.tg1)
	e1:SetOperation(c71400044.op1)
	c:RegisterEffect(e1)
	--double attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetDescription(aux.Stringid(71400044,1))
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,71400044)
	e2:SetTarget(c71400044.tg2)
	e2:SetOperation(c71400044.op2)
	c:RegisterEffect(e2)
end
function c71400044.filter1(c)
	return c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and not c:IsCode(71400044) and c:IsAbleToHand()
end
function c71400044.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400044.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c71400044.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400044.filter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71400044.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x714)
end
function c71400044.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c71400044.filter2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c71400044.filter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c71400044.filter2,tp,LOCATION_MZONE,0,1,1,nil)
end
function c71400044.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(atk*2)
		tc:RegisterEffect(e1)
	end
end