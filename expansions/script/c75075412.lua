--三角攻阵-鬼神架势
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
end
--e2
function cm.tg2con1(e,tp,eg,ep,ev,re,r,rp)
	local _, tp = e:GetLabel()
	return tp ~= Duel.GetTurnPlayer()
end
function cm.tg2op1(e,tp,eg,ep,ev,re,r,rp)
	local ct, tp = e:GetLabel()
	if ct == 1 then
		Duel.Hint(HINT_CARD, 0, m)
		Duel.SendtoHand(e:GetHandler(), nil, REASON_RULE)
	else
		e:SetLabel(ct - 1, tp)
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	g = g:Filter(Card.IsCanBeEffectTarget,nil,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local c, ct = e:GetHandler(), 1
	if Duel.GetTurnPlayer() ~= tp and Duel.GetCurrentPhase() == PHASE_END then ct = 2 end
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(ct, tp)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(cm.tg2con1)
	e1:SetOperation(cm.tg2op1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function cm.op2val1(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel())
end
function cm.e2f(c, p, cseq)
	if c:IsLocation(LOCATION_FZONE) then return false end
	local seq = c:GetSequence()
	local isp = c:IsControler(p)
	if seq > 4 then
		seq = isp and seq or 11 - seq
		seq = 2 * seq - 9
		return seq == cseq
	elseif not isp then
		return false
	elseif c:IsLocation(LOCATION_SZONE) then
		return seq == cseq
	end
	return seq < cseq + 2 and cseq - 2 < seq
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not tc:IsFaceup() or not tc:IsRelateToEffect(e) then return end
	local code1, code2 = tc:GetCode()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,1)
	e1:SetValue(cm.op2val1)
	e1:SetLabel(code1, code2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local seq = tc:GetSequence()
	if seq == 0 or seq > 3 then return end
	local p = tc:GetControler()
	local g = Duel.GetMatchingGroup(cm.e2f,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,p,seq)
	if #g < 3 or not Duel.SelectYesNo(tp,1101) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	g = Duel.SelectMatchingCard(tp, nil, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
	Duel.Destroy(g, REASON_EFFECT)
end
--e3
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD, 0, m)
	local c = e:GetHandler()
	Duel.ChangePosition(c,POS_FACEDOWN)
	Duel.RaiseEvent(c,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
end