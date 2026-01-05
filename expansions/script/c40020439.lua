--瞬耀-致哈萨维的鼓舞
local s,id=GetID()
s.named_with_FlashRadiance=1
function s.FlashRadiance(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_FlashRadiance
end

function s.XiGundam(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_XiGundam
end
function s.initial_effect(c)
	aux.AddCodeList(c,40020396)
	
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_ATKCHANGE + CATEGORY_DEFCHANGE + CATEGORY_POSITION + CATEGORY_TODECK + CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET + EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(TIMING_DAMAGE_STEP)
	e1:SetCountLimit(1, id)
	e1:SetCondition(s.e1con)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)

	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 100)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end



function s.e1con(e, tp, eg, ep, ev, re, r, rp)
	return aux.dscon(e, tp, eg, ep, ev, re, r, rp)
end

function s.tgfilter(c)
	return c:IsFaceup() and aux.IsCodeListed(c, 40020396)
end

function s.e1tg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.tgfilter(chkc) end
	if chk == 0 then return Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_MZONE, 0, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end

function s.opt1filter(c)
	return c:IsCanTurnSet()
end

function s.opt2filter(c)
	return (c:IsDefensePos() or c:IsFacedown()) and c:IsAbleToDeck()
end

function s.opt3filter(c)
	return s.XiGundam(c) and c:IsFaceup() and c:IsCanAddCounter(0x1f1e, 1)
end

function s.e1op(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then

		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END)
		tc:RegisterEffect(e1)
		local e2 = e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		tc:RegisterEffect(e2)
		
		local b1 = Duel.IsExistingMatchingCard(s.opt1filter, tp, 0, LOCATION_ONFIELD, 1, nil)
		local b2 = Duel.IsExistingMatchingCard(s.opt2filter, tp, 0, LOCATION_ONFIELD, 1, nil)
		local b3 = Duel.IsExistingMatchingCard(s.opt3filter, tp, LOCATION_MZONE, 0, 1, nil)
		
		if (b1 or b2 or b3) and Duel.SelectYesNo(tp, aux.Stringid(id, 2)) then
			Duel.BreakEffect()
			local ops = {}
			local opval = {}
			local off = 1
			if b1 then
				ops[off] = aux.Stringid(id, 3) 
				opval[off] = 1
				off = off + 1
			end
			if b2 then
				ops[off] = aux.Stringid(id, 4) 
				opval[off] = 2
				off = off + 1
			end
			if b3 then
				ops[off] = aux.Stringid(id, 5)
				opval[off] = 3
				off = off + 1
			end
			
			local op = Duel.SelectOption(tp, table.unpack(ops))
			local sel = opval[op + 1]
			
			if sel == 1 then
				-- 对方卡变里侧/盖放
				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_POSCHANGE)
				local g = Duel.SelectMatchingCard(tp, s.opt1filter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
				local rc = g:GetFirst()
				if rc then
					if rc:IsType(TYPE_MONSTER) then
						Duel.ChangePosition(rc, POS_FACEDOWN_DEFENSE)
					else
						Duel.ChangePosition(rc, POS_FACEDOWN)
					end
				end
			elseif sel == 2 then

				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
				local g = Duel.SelectMatchingCard(tp, s.opt2filter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
				if g:GetCount() > 0 then
					Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
				end
			elseif sel == 3 then

				Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_COUNTER)
				local g = Duel.SelectMatchingCard(tp, s.opt3filter, tp, LOCATION_MZONE, 0, 1, 1, nil)
				local rc = g:GetFirst()
				if rc then
					rc:AddCounter(0x1f1e, 1)
					Duel.RegisterFlagEffect(tp, 40020396, 0, 0, 1)
				end
			end
		end
	end
end

function s.e2filter(c, tp)
	return s.FlashRadiance(c) and c:IsType(TYPE_XYZ) and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_XYZ)
end

function s.e2con(e, tp, eg, ep, ev, re, r, rp)
	return eg:IsExists(s.e2filter, 1, nil, tp)
end

function s.e2tg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, e:GetHandler(), 1, 0, 0)
end

function s.e2op(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsSSetable() then
		Duel.SSet(tp, c)
		local e1 = Effect.CreateEffect(c)
		e1:SetDescription(3300)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_CLIENT_HINT)
		e1:SetReset(RESET_EVENT + RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1)
	end
end
