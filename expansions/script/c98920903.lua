--雪与暖的冬化精

local s, id = GetID()

function s.initial_effect(c)
	
	-- 效果1：丢弃手卡特召墓地怪兽
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1, id)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	-- 效果2：墓地除外盖放魔陷
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetCategory(CATEGORY_SEARCH + CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1, id + 100)
	e2:SetCost(s.setcost)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- 效果1：丢弃代价处理
function s.spcost(e, tp, eg, ep, ev, re, r, rp, chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.disfilter(c)
   return (c:IsSetCard(0x182) or c:IsAttribute(ATTRIBUTE_EARTH)) and c:IsDiscardable()
end
-- 效果1：目标处理
function s.spfilter(c,code)
	return c:IsSetCard(0x182) and c:IsType(TYPE_MONSTER) and not c:IsCode(98920903,code)
end
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
   	local fe=Duel.IsPlayerAffectedByEffect(tp,14108995)
	local b2=Duel.IsExistingMatchingCard(s.disfilter,tp,LOCATION_HAND,0,1,c)
	if chk == 0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsDiscardable() and Duel.IsExistingMatchingCard(s.disfilter, tp, LOCATION_HAND, 0, 1, c) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.IsExistingMatchingCard(s.spfilter, tp, LOCATION_GRAVE, 0, 2, nil,98920903)
	end
	if fe and (not b2 or Duel.SelectYesNo(tp,aux.Stringid(14108995,0))) then
		Duel.Hint(HINT_CARD,0,14108995)
		fe:UseCountLimit(tp)
		e:SetLabelObject(c)
		Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	else
		local g = Duel.SelectMatchingCard(tp, s.disfilter, tp, LOCATION_HAND, 0, 1, 1, c)
		e:SetLabelObject(g:GetFirst())
		g:AddCard(c)
		Duel.SendtoGrave(g, REASON_COST + REASON_DISCARD)
	end
	Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 2, tp, LOCATION_GRAVE)
end
-- 效果1：特殊召唤操作
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local dc = e:GetLabelObject()
	local sg = Duel.GetMatchingGroup(s.spfilter, tp, LOCATION_GRAVE, 0, nil,dc:GetCode())
	if #sg >= 2 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
		local spg = sg:Select(tp, 2, 2, nil)
		if #spg == 2 and Duel.SpecialSummon(spg, 0, tp, tp, false, false, POS_FACEUP) > 0 then
			-- 本回合限制：只能发动地属性怪兽效果
			local e1 = Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_CANNOT_ACTIVATE)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetTargetRange(1, 0)
			e1:SetValue(s.actlimit)
			e1:SetReset(RESET_PHASE + PHASE_END)
			Duel.RegisterEffect(e1, tp)
		end
	end
end
function s.actlimit(e, re, tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsAttribute(ATTRIBUTE_EARTH)
end

-- 效果2：除外代价
function s.setcost(e, tp, eg, ep, ev, re, r, rp, chk)
	local c = e:GetHandler()
	if chk == 0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c, POS_FACEUP, REASON_COST)
end

-- 效果2：盖放目标
function s.setfilter(c)
	return c:IsSetCard(0x182) and c:IsType(TYPE_SPELL + TYPE_TRAP) and c:IsSSetable()
end
function s.settg(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(s.setfilter, tp, LOCATION_DECK, 0, 1, nil) end
end

-- 效果2：盖放操作
function s.setop(e, tp, eg, ep, ev, re, r, rp)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SET)
	local g = Duel.SelectMatchingCard(tp, s.setfilter, tp, LOCATION_DECK, 0, 1, 1, nil)
	if #g > 0 then
		Duel.SSet(tp, g:GetFirst())
	end
end

