--白翼驰星 帕奥拉
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1, m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.tg3)
	e3:SetTargetRange(LOCATION_ONFIELD, LOCATION_MZONE)
	e3:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
-- e1
function cm.e1f(c)
	return c:IsSetCard(0x3755) and c:IsAbleToHand()
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(cm.e1f, tp, LOCATION_DECK, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_TOHAND, nil, 1, tp, LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc = Duel.SelectMatchingCard(tp, cm.e1f, tp, LOCATION_DECK, 0, 1, 1, nil):GetFirst()
	if not tc then return end
	Duel.SendtoHand(tc, nil, REASON_EFFECT)
	Duel.ConfirmCards(1 - tp, tc)
end
-- e3
function cm.tg3(e,oc)
	if oc:IsLocation(LOCATION_FZONE) or oc:IsSetCard(0xc754) and oc:IsFaceup() then return false end
	local cseq = e:GetHandler():GetSequence()
	local seq = oc:GetSequence()
	local isp = oc:IsControler(e:GetHandlerPlayer())
	if cseq > 4 then
		seq = isp and 9 + seq or 13 - seq
		return oc:IsLocation(LOCATION_MZONE) and seq == 2 * cseq
	end
	if seq > 4 then
		seq = isp and seq or 11 - seq
		seq = 2 * seq - 9
		return seq == cseq
	elseif not isp then
		return false
	elseif oc:IsLocation(LOCATION_SZONE) then
		return seq == cseq
	end
	return seq < cseq + 2 and cseq - 2 < seq
end
-- e4
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return re:IsActiveType(TYPE_QUICKPLAY) and c:GetFlagEffect(m) == 0 and c:GetSequence() < 5
		and (Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0) > 0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0) > 0 and c:IsControlerCanBeChanged())
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.SelectYesNo(tp,aux.Stringid(m,0)) then return end
	Duel.Hint(HINT_CARD, 0, m)
	local c = e:GetHandler()
	local pseq = c:GetSequence()
	local oppo_loc = 0
	local _, zone = Duel.GetLocationCount(tp, LOCATION_MZONE, PLAYER_NONE, 0)
	if c:IsControlerCanBeChanged() then
		oppo_loc = LOCATION_MZONE
		local _, zone1 = Duel.GetLocationCount(1 - tp, LOCATION_MZONE, PLAYER_NONE, 0)
		zone = zone + (zone1 << 16)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOZONE)
	zone = Duel.SelectField(tp, 1, LOCATION_MZONE, oppo_loc, zone | 0xE000E0)
	if zone & 0x1F > 0 then
		Duel.MoveSequence(c, math.log(zone, 2))
	else
		Duel.GetControl(c, 1 - tp, 0, 0, zone >> 16)
	end
	local fid = c:GetFieldID()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,2))
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid, pseq)
	e1:SetLabelObject(c)
	e1:SetOperation(cm.op4op1)
	Duel.RegisterEffect(e1, tp)
end
function cm.op4op1(e,tp,eg,ep,ev,re,r,rp)
	local fid, pseq = e:GetLabel()
	local c = e:GetLabelObject()
	if c:GetFlagEffectLabel(m) == fid then
		if not Duel.CheckLocation(tp, LOCATION_MZONE, pseq) then
			Duel.SendtoGrave(c, REASON_RULE)
		elseif c:IsControler(tp) then
			Duel.MoveSequence(c, pseq)
		elseif c:IsControlerCanBeChanged() then
			Duel.GetControl(c, tp, 0, 0, 2 ^ pseq)
		end
	end
	c:ResetFlagEffect(m)
	e:Reset()
end