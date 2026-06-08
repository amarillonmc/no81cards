--恍然悠悠
local s, id = GetID()
function c98920990.initial_effect(c)
	--change name
	aux.EnableChangeCode(c,27288416,LOCATION_MZONE+LOCATION_GRAVE)
	--normal monster
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_TYPE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(TYPE_NORMAL)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_REMOVE_TYPE)
	e2:SetValue(TYPE_EFFECT)
	c:RegisterEffect(e2)
		-- ①：自己·对方回合可以发动。这张卡从手卡特殊召唤，并处理后续效果。
	local e1 = Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id, 0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION) -- 起动效果
	e1:SetRange(LOCATION_HAND) -- 手卡发动
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET) -- 取对象
	e1:SetCountLimit(1, id) -- 这个卡名的效果1回合只能使用1次
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
end
-- 复活的悠悠 (Resurrected Mokey Mokey)

-- 墓地「悠悠」卡片的过滤条件
function s.tgfilter(c, e, tp, mzone, szone)
	if not c:IsSetCard(0x183) then return false end -- 必须是「悠悠」卡片
	if c:IsType(TYPE_MONSTER) then
		-- 如果是怪兽，需要自己场上有至少2个怪兽区域（这只卡和目标怪兽），且目标怪兽可以特召
		return mzone > 1 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
	else
		-- 如果是魔陷，需要自己场上有至少1个怪兽区域和1个魔陷区域，且目标魔陷可以盖放
		return mzone > 0 and szone > 0 and c:IsSSetable()
	end
end

-- 效果发动时的目标选择与合法性检测
function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
	local c = e:GetHandler()
	local mzone = Duel.GetLocationCount(tp, LOCATION_MZONE)
	local szone = Duel.GetLocationCount(tp, LOCATION_SZONE)
	if chkc then 
		return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tgfilter(chkc, e, tp, mzone, szone) 
	end
	if chk == 0 then
		-- 手卡的这张卡必须能特召，且墓地有符合条件的「悠悠」卡
		return mzone > 0 and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
			and Duel.IsExistingTarget(s.tgfilter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp, mzone, szone)
	end
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TARGET)
	local g = Duel.SelectTarget(tp, s.tgfilter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp, mzone, szone)
	
	-- 设置效果分类
	local tc = g:GetFirst()
	if tc:IsType(TYPE_MONSTER) then
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, Group.FromCards(c, tc), 2, tp, LOCATION_HAND+LOCATION_GRAVE)
	else
		Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
	end
end

-- 效果处理
function s.spop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	-- 1. 特殊召唤手卡的这张卡
	if Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
		local tc = Duel.GetFirstTarget()
		if tc and tc:IsRelateToEffect(e) then
			-- 2. 判断对象的卡片类型
			if tc:IsType(TYPE_MONSTER) then
				-- 作为对象的卡是怪兽的场合，那只怪兽特殊召唤
				if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
					Duel.SpecialSummon(tc, 0, tp, tp, false, false, POS_FACEUP)
				end
			else
				-- 作为对象的卡是魔法·陷阱卡的场合，那张卡在自己场上盖放
				if Duel.GetLocationCount(tp, LOCATION_SZONE) > 0 then
					Duel.SSet(tp, tc)
				end
			end
		end
	end
end