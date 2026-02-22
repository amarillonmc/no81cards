-- 桃源乡的来访者·融合体
local s, id = GetID()
s.togenkyo_set = 0x5220  -- 「桃源乡」字段

function s.initial_effect(c)
	-- 融合召唤规则：2只以上「桃源乡的来访者」(11621403)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep2(c,aux.FilterBoolFunction(Card.IsCode,11621403),2,99,true)

	-- 替代特殊召唤方式：解放自己场上1张「桃源乡」陷阱卡（除「桃源乡的大神邸官」）从额外卡组当作永续陷阱卡放置到魔陷区
	 -- 特殊召唤规则：解放自己场上1张其他「桃源乡」陷阱卡
	local e0 = Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE + EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_SPECIAL) 
	c:RegisterEffect(e0)

	-- 效果①：场上的这张卡被解放送去墓地时，结束阶段从墓地选1张「桃源乡」卡回手
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_RELEASE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2 = Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id, 1))
	e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(s.trapop)
	c:RegisterEffect(e2)
end

-- 替代召唤条件
function s.trapfilter(c)
	return c:IsSetCard(0x5220) and c:IsType(TYPE_TRAP)
end
function s.spcon(e, c)
	if c == nil then return true end
	local tp = c:GetControler()
	return Duel.IsExistingMatchingCard(s.trapfilter, tp, LOCATION_ONFIELD, 0, 1, nil)
		and Duel.GetLocationCountFromEx(tp, tp, nil, c) > 0
end
function s.spop(e, tp, eg, ep, ev, re, r, rp, c)
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_RELEASE)
	local g = Duel.SelectMatchingCard(tp, s.trapfilter, tp, LOCATION_ONFIELD, 0, 1, 1, nil)
	if #g > 0 then
		Duel.Release(g, REASON_COST)
	end
end

-- 效果①目标（无特殊目标，仅设置操作信息）
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end

-- 效果①操作：在结束阶段回收墓地「桃源乡」卡
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 创建一个延迟效果在结束阶段执行
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(s.repop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

function s.repop(e,tp,eg,ep,ev,re,r,rp)
	-- 从墓地选择1张「桃源乡」卡加入手卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(s.togenkyo_set) and c:IsAbleToHand() end,tp,LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function s.trapop(e, tp, eg, ep, ev, re, r, rp)
	local c = e:GetHandler()
	-- 检查魔陷区空位
	if Duel.GetLocationCount(tp, LOCATION_SZONE) <= 0 then return end
	-- 移动到魔陷区
	if Duel.MoveToField(c, tp, tp, LOCATION_SZONE, POS_FACEUP, true) then
		-- 改变类型为永续陷阱
		local e1 = Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TRAP + TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT + RESETS_STANDARD - RESET_TOFIELD)
		c:RegisterEffect(e1)
	end
end