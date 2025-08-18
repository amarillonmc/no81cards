--白翼驰星 艾斯特
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, m)
	e1:SetCondition(cm.con1())
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con1(1))
	c:RegisterEffect(e2)
	local e3 = Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DISABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(cm.tg3)
	e3:SetTargetRange(LOCATION_ONFIELD, LOCATION_MZONE)
	c:RegisterEffect(e3)
	local e4 = Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
-- e1
function cm.con1(chk)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g = Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
		local b = #g <= #Duel.GetFieldGroup(tp, 0, LOCATION_MZONE)
		if chk then b = not b end
		return b and (#g == 0 or g:IsExists(Card.IsRace, 1, nil, RACE_WINDBEAST))
	end
end
function cm.e1f(c,e,tp)
	return c:IsSetCard(0xc754) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c = e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(cm.e1f,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,c,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE) < 2 or Duel.IsPlayerAffectedByEffect(tp,59822133)
		or not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.e1f),tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	g = g:Select(tp, 1, 1, nil)
	if #g == 0 then return end
	g:AddCard(c)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
-- e3
function cm.tg3(e,oc)
	if (oc:IsType(TYPE_MONSTER) and (not oc:IsType(TYPE_EFFECT) or oc:GetOriginalType() & TYPE_EFFECT == 0))
		or oc:IsLocation(LOCATION_FZONE) or oc:IsSetCard(0xc754,0x3755) and oc:IsFaceup() then return false end
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