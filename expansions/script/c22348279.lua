--怨 恨 念 法 「 积 怨 返 」
local m=22348279
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_ATTACK)
	e1:SetCountLimit(1,22348279+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22348279.cpcon)
	e1:SetTarget(c22348279.cptg)
	e1:SetOperation(c22348279.cpop)
	c:RegisterEffect(e1)
	--act in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c22348279.actcon)
	c:RegisterEffect(e2)


end

function c22348279.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x612)
end
function c22348279.actcon(e)
	return Duel.IsExistingMatchingCard(c22348279.filter1,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

function c22348279.cpcon(e)
	return Duel.IsExistingMatchingCard(c22348279.filter2,e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end

function c22348279.copyfilter(c,tp)
	return c:IsFaceup() 
end
function c22348279.filter2(c,lv)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT)
end
function c22348279.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g=Duel.GetMatchingGroup(c22348279.filter2,tp,0,LOCATION_MZONE,nil)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(c22348279.copyfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c22348279.copyfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c22348279.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local g=Duel.GetMatchingGroup(c22348279.filter2,tp,0,LOCATION_MZONE,nil)
	if tc and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and #g>0 then
		local fc=g:Select(tp,1,1,nil):GetFirst()
		local code=fc:GetOriginalCode()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		fc:RegisterEffect(e1)
		if not fc:IsType(TYPE_TRAPMONSTER) then tc:CopyEffect(code,RESET_EVENT+RESETS_STANDARD,1) end
	end
end