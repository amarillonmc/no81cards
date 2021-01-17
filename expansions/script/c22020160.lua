--人理之基 尼禄·花嫁
function c22020160.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--change name
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(22020130)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22020160,0))
	e2:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_SEARCH)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e2:SetCountLimit(1,22020160)
	e2:SetCondition(c22020160.condition)
	e2:SetTarget(c22020160.rectg)
	e2:SetOperation(c22020160.recop)
	c:RegisterEffect(e2)
end
function c22020160.cfilter(c)
	return c:IsFaceup() and c:IsDisabled()
end
function c22020160.condition(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c22020160.cfilter,tp,0,LOCATION_MZONE,nil)
	return ct>0 and aux.dscon()
end
function c22020160.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xff1) and c:GetBaseAttack()>0
end
function c22020160.filter1(c)
	return c:IsSetCard(0xff1) and c:IsAbleToHand()
end
function c22020160.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22020160.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22020160.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local ct=Duel.GetMatchingGroupCount(c22020160.cfilter,tp,0,LOCATION_MZONE,nil)
	local g=Duel.SelectTarget(tp,c22020160.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if ct<=1 then return Duel.IsExistingMatchingCard(c22020160.filter,tp,LOCATION_MZONE,0,1,nil) end
	return true
end
function c22020160.recop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c22020160.filter1,tp,LOCATION_DECK,0,nil)
	local g=Duel.GetMatchingGroup(c22020160.cfilter,tp,0,LOCATION_MZONE,nil)
	local ct=g:GetCount()
	if ct>=1 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetBaseAttack()>0 then
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT) end
	end
	if ct>=2 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:GetAttack()>0 then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(tc:GetAttack()*2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
		end
	end
	if ct>=3 and Duel.SelectYesNo(tp,aux.Stringid(22020160,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end