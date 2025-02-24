--天空漫步者-平衡解放
function c9910235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMINGS_CHECK_MONSTER+TIMING_DAMAGE_STEP)
	e1:SetCondition(c9910235.condition)
	e1:SetTarget(c9910235.target)
	e1:SetOperation(c9910235.activate)
	c:RegisterEffect(e1)
end
function c9910235.cfilter(c)
	return c:GetSequence()<5 and (c:IsFacedown() or not c:IsRace(RACE_PSYCHO))
end
function c9910235.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c9910235.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c9910235.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:IsType(TYPE_LINK)
end
function c9910235.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910235.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910235.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9910235.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 then
		e:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_REMOVE)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end
function c9910235.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local zone=LOCATION_ONFIELD+LOCATION_GRAVE
	local link=tc:GetLink()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(link*500)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c9910235.atktg)
		e2:SetLabel(tc:GetFieldID())
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,zone,zone,aux.ExceptThisCard(e))
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetCurrentChain()>2 and #g>=link
		and Duel.SelectYesNo(tp,aux.Stringid(9910235,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=g:Select(tp,link,link,nil)
		Duel.HintSelection(sg)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c9910235.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
