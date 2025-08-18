--连翼的飞星 卡秋娅
local cm, m = GetID()
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c, aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST), 2, 2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1, m)
	e1:SetCost(cm.cos1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(cm.con2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
--e1
function cm.cos1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = e:GetHandler():GetLinkedGroup()
	if chk==0 then return #g > 0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler():GetLinkedGroup(), REASON_EFFECT)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	return re:IsActiveType(TYPE_SPELL) and c:GetFlagEffect(m) == 0 and c:GetSequence() < 5
		and (Duel.GetLocationCount(tp,LOCATION_MZONE,PLAYER_NONE,0) > 0
		or Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0) > 0 and c:IsControlerCanBeChanged())
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
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
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,fid,aux.Stringid(m,0))
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetCountLimit(1)
	e1:SetLabel(fid, pseq)
	e1:SetLabelObject(c)
	e1:SetOperation(cm.op2op1)
	Duel.RegisterEffect(e1, tp)
end
function cm.op2op1(e,tp,eg,ep,ev,re,r,rp)
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