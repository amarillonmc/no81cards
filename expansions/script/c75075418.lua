--三角攻阵-空转奇策
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
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
function cm.e2f2(c,e,tp,sp,zone)
	return c:IsSetCard(0xc754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,sp,zone)
end
function cm.e2f1(c,e,tp)
	if not (c:IsFaceup() and c:IsSetCard(0xc754) and c:IsCanBeEffectTarget(e)) then return false end
	local seq = c:GetSequence()
	if seq > 4 then return false end
	local zone = 1 << seq
	zone = (zone << 1 | zone >> 1) & 0x1F
	local sp = c:GetControler()
	return Duel.IsExistingMatchingCard(cm.e2f2,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,sp,zone)
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e2f1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,e,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g > 0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.e2f1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
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
function cm.e2f3(c, tp, cseq)
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
	local seq = tc:GetSequence()
	if seq > 4 then return false end
	local zone = 1 << seq
	zone = (zone << 1 | zone >> 1) & 0x1F
	local sp = tc:GetControler()
	local g = Duel.GetMatchingGroup(cm.e2f2, tp, LOCATION_HAND+LOCATION_GRAVE, 0, nil, e, tp, sp, zone)
	g = g:Filter(aux.NecroValleyFilter(aux.TRUE),nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g = g:Select(tp, 1, 1, nil)
	if #g == 0 or Duel.SpecialSummon(g,0,tp,sp,false,false,POS_FACEUP,zone) == 0 then return end
	if seq == 0 or seq == 4 or not Duel.IsPlayerCanSpecialSummonCount(tp,2) then return end
	if #Duel.GetMatchingGroup(cm.e2f3,tp,LOCATION_ONFIELD,LOCATION_MZONE,tc,sp,seq) < 3 then return end
	g = Duel.GetMatchingGroup(Card.IsLinkSummonable,tp,LOCATION_EXTRA,0,nil,nil)
	if #g == 0 or not Duel.SelectYesNo(tp,1166) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	g = g:Select(tp,1,1,nil):GetFirst()
	Duel.BreakEffect()
	Duel.LinkSummon(tp,g,nil)
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