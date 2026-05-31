--XY-极超神龙炮
local s, id = GetID()
function s.initial_effect(c)
	-- 融合召唤限制与条件
	c:EnableReviveLimit()
	
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,70860415,6355563,true,true)
	aux.AddContactFusionProcedure(c,Card.IsAbleToRemoveAsCost,LOCATION_ONFIELD,0,Duel.Remove,POS_FACEUP,REASON_COST)
	
	-- 额外卡组特殊召唤限制
	local e1 = Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE + EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)

	-- ①：对方回合1次，丢弃1张手卡，以对方场上1张表侧表示的魔法·陷阱卡为对象才能发动。那张卡的效果无效化并破坏。
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 0))
	e2:SetCategory(CATEGORY_DISABLE + CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0, TIMING_END_PHASE + TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1)
	e2:SetCondition(s.negcond)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)

	-- ②：把场上·墓地的这张卡除外，把额外卡组1只机械族·光属性·6星融合怪兽给对方观看才能发动。那只怪兽有卡名记述的自己的墓地·除外状态的最多2只融合素材怪兽特殊召唤。
	local e3 = Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id, 1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE + LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

-- 用于保存发动效果时展示的怪兽的素材列表
s.revealed_mats = {}

-- 接触融合辅助过滤器
function s.spfilter1(c, tp, g, sc)
	return c:IsFusionCode(70860415) and c:IsAbleToRemoveAsCost()
		and g:IsExists(s.spfilter2, 1, c, tp, c, sc)
end
function s.spfilter2(c, tp, mc, sc)
	return c:IsFusionCode(6355563) and c:IsAbleToRemoveAsCost()
		and Duel.GetLocationCountFromEx(tp, tp, Group.FromCards(c, mc), sc) > 0
end

-- 接触融合条件
function s.spcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	local g = Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost, tp, LOCATION_ONFIELD, 0, nil)
	return g:IsExists(s.spfilter1, 1, nil, tp, g, c)
end

-- 接触融合目标与操作
function s.sptg_contact(e, tp, eg, ep, ev, re, r, rp, chk, c)
	local g = Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost, tp, LOCATION_ONFIELD, 0, nil)
	local g1 = g:Filter(s.spfilter1, nil, tp, g, c)
	if #g1 > 0 then
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
		local tc1 = g1:Select(tp, 1, 1, nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_REMOVE)
		local tc2 = g:Filter(s.spfilter2, tc1, tp, tc1, c):Select(tp, 1, 1, nil):GetFirst()
		local sg = Group.FromCards(tc1, tc2)
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	end
	return false
end
function s.spop_contact(e, tp, eg, ep, ev, re, r, rp, c)
	local g = e:GetLabelObject()
	Duel.Remove(g, POS_FACEUP, REASON_COST)
	g:DeleteGroup()
end

-- 额外卡组特殊召唤限制
function s.splimit(e, se, sp, st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end

-- ①：效果条件（对方回合）
function s.negcond(e, tp, eg, ep, ev, re, r, rp)
	return Duel.GetTurnPlayer() ~= tp
end

-- ①：效果Cost（丢弃1张手卡）
function s.negcost(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable, tp, LOCATION_HAND, 0, 1, nil) end
	Duel.DiscardHand(tp, Card.IsDiscardable, 1, 1, REASON_COST + REASON_DISCARD, nil)
end

-- ①：寻找对方场上表侧表示的魔法·陷阱
function s.negfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL + TYPE_TRAP)
end
function s.negtg(e, tp, eg, ep, ev, re, r, rp, chk, chid)
	if chk == 0 then return Duel.IsExistingTarget(s.negfilter, tp, 0, LOCATION_ONFIELD, 1, nil) end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.negfilter, tp, 0, LOCATION_ONFIELD, 1, 1, nil)
	Duel.SetOperationInfo(0, CATEGORY_DISABLE, g, 1, 0, 0)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

-- ①：效果无效并破坏
function s.negop(e, tp, eg, ep, ev, re, r, rp)
	local tc = Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1 = Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD+EVENT_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2 = Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT + RESETS_STANDARD+EVENT_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end

function s.spfilter(c,e,tp,fc)
	return aux.IsMaterialListCode(fc,c:GetCode()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.fselect(tg,tp,ec)
	return Duel.GetMZoneCount(tp,ec,tp)>=#tg
end
function s.ffilter(c,e,tp,ec)
	if not (c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(6)) then return false end
	local tg=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,c)
	return tg:CheckSubGroup(s.fselect,1,3,tp,ec)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.ffilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(tp,s.ffilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c):GetFirst()
	Duel.ConfirmCards(1-tp,fc)
	e:SetLabelObject(fc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local fc=e:GetLabelObject()
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp,fc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:SelectSubGroup(tp,aux.TRUE,false,1,ft)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
