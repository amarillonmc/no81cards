--三角攻阵-明镜反击
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
	e3:SetCode(EVENT_CHAINING)
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
function cm.e2f(c, tp, cseq)
	if c:IsLocation(LOCATION_FZONE) then return false end
	local seq = c:GetSequence()
	local isp = c:IsControler(tp)
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
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e1:SetValue(1200)
	tc:RegisterEffect(e1)
	if tc:IsControler(tp) or not tc:IsControlerCanBeChanged() then return end
	local _, zone = Duel.GetLocationCount(tp, LOCATION_MZONE, PLAYER_NONE, 0)
	if zone & 0xE == 0xE then return end
	local ct, g = 3, Duel.GetFieldGroup(tp,LOCATION_ONFIELD,LOCATION_MZONE) - tc
	for i = 1, 3 do
		local _zone = 1 << i
		if zone & _zone > 0 then
			ct = ct - 1
		elseif not g:IsExists(cm.e2f, 3, nil, tp, i) then
			ct = ct - 1
			zone = zone + _zone
		end
	end
	if zone & 0xE == 0xE then return end
	zone = zone | 0x11
	if not (tc:IsControlerCanBeChanged(false,~zone) and Duel.SelectYesNo(tp,1112)) then return end
	if ct > 1 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
		zone = Duel.SelectField(tp, 1, LOCATION_MZONE, 0, zone)
	else
		zone = 0x7F ~ zone
	end
	Duel.GetControl(tc, tp, 0, 0, zone)
end
--e3
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	if not (re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_QUICKPLAY)) then return end
	local rc = re:GetHandler()
	if not rc:IsSetCard(0x3755) or rc:IsCode(m) then return end
	local ct, zone = Duel.GetLocationCount(1 - tp, LOCATION_SZONE, PLAYER_NONE, 0)
	if ct == 0 or not Duel.SelectYesNo(tp, aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD, 0, m)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	zone = Duel.SelectField(tp, 1, 0, LOCATION_SZONE, (zone | 0x20) << 24)
	Duel.MoveToField(e:GetHandler(), tp, 1 - tp, LOCATION_SZONE, POS_FACEUP, true, zone >> 24)
end