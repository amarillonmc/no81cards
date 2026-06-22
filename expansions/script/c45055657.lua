--宇宙超越星神 最终多维理论
local s, id = GetID()
function s.initial_effect(c)   
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c, nil , aux.NonTuner(s.synfilter), 1 , 99)
	c:SetSPSummonOnce(id)
	
	-- ①：同调召唤成功时放置超越星宇宙
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O+CATEGORY_LEAVE_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(s.setcon)
	e1:SetTarget(s.settg)
	e1:SetOperation(s.setop)
	c:RegisterEffect(e1)
	
	-- ②：场上有其他超越星卡时攻守上升
	local e2 = Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetCondition(s.atkcon)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	local e3 = e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	
	-- ③：双方回合各1次，送墓超越星卡选择破坏效果
	local e4 = Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id, 1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetCondition(s.descon)
	e4:SetCost(s.descost)
	e4:SetTarget(s.destg)
	e4:SetOperation(s.desop)
	c:RegisterEffect(e4)
end

function s.synfilter(c)
	return c:IsType(TYPE_EFFECT)
end


function s.setcon(e, tp, eg, ep, ev, re, r, rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.setfilter(c)
	return c:IsCode(45055659) and (c:IsLocation(LOCATION_DECK) or c:IsLocation(LOCATION_GRAVE))
end
function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, nil) end
	Duel.SetOperationInfo(0, CATEGORY_LEAVE_GRAVE, nil, 1, tp, LOCATION_DECK + LOCATION_GRAVE)
end
function s.setop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOFIELD)
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK + LOCATION_GRAVE, 0, 1, 1, nil)
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		Duel.MoveToField(tc, tp, tp, LOCATION_SZONE, POS_FACEUP, true)
	end
end



function s.atkfilter(c)
	return c:IsSetCard(0x6f5) and c:IsFaceup() and not c:IsCode(id)
end

function s.atkcon(e)
	return Duel.IsExistingMatchingCard(s.atkfilter, e:GetHandlerPlayer(), LOCATION_ONFIELD, 0, 1, nil)
end


-- 效果③
function s.costfilter(c)
	return c:IsSetCard(0x6f5) and c:IsAbleToGraveAsCost() and c:IsFaceup()
end

function s.descost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.costfilter, tp, LOCATION_ONFIELD, 0, 1, e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TOGRAVE)
	local g = Duel.SelectMatchingCard(tp, s.costfilter, tp, LOCATION_ONFIELD, 0, 1, 1, e:GetHandler())
	Duel.SendtoGrave(g, REASON_COST)
end
-- 效果③：选择破坏效果
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffectLabel(id)~=Duel.GetTurnCount()-1
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
	local b1 = Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_MZONE, 1, nil)
	local b2 = Duel.IsExistingMatchingCard(nil, tp, 0, LOCATION_SZONE, 1, nil)
	
	if chk == 0 then 
		return b1 or b2
	end
	
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EFFECT)
	local op = 0
	if b1 and b2 then
		op = Duel.SelectOption(tp, 
			aux.Stringid(id, 2), -- 破坏怪兽
			aux.Stringid(id, 3)) -- 破坏魔法陷阱
	elseif b1 then
		op = 0
	elseif b2 then
		op = 1
	end
	e:SetLabel(op)
	
	if op == 0 then
		local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_MZONE, nil)
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
	else
		local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_SZONE, nil)
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, g:GetCount(), 0, 0)
	end
end

-- 效果③：破坏操作
function s.desop(e, tp, eg, ep, ev, re, r, rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op == 0 then
		local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_MZONE, nil)
		if g:GetCount() > 0 then
			Duel.Destroy(g, REASON_EFFECT)
		end
	else
		local g = Duel.GetMatchingGroup(nil, tp, 0, LOCATION_SZONE, nil)
		if g:GetCount() > 0 then
			Duel.Destroy(g, REASON_EFFECT)
		end
	end
	if c:IsRelateToEffect(e) then
	   c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2,Duel.GetTurnCount())
	end
end