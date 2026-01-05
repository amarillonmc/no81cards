--炽魂·双星 舞姬
local s, id = GetID()

-- 定义炽魂字段常量
s.soul_setcode = 0xa96c

function s.initial_effect(c)
	-- 卡片允许放置炽魂指示物
	c:EnableCounterPermit(s.soul_setcode)
	
	-- 效果①：特殊召唤条件
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP,0)
	e1:SetCondition(s.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	
	-- 效果②：特殊召唤或攻击宣言时放置指示物
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(s.ctcon)
	e2:SetTarget(s.cttg)
	e2:SetOperation(s.ctop)
	c:RegisterEffect(e2)
	
	local e3=e2:Clone()
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e3)
	
	-- 效果③：去除指示物进行连接召唤
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id)
	e4:SetCondition(s.linkcon)
	e4:SetCost(s.linkcost)
	e4:SetTarget(s.linktg)
	e4:SetOperation(s.linkop)
	c:RegisterEffect(e4)
end

-- 效果①：特殊召唤条件（自己场上有炽魂指示物）
function s.cfilter(c)
	return c:GetCounter(s.soul_setcode)>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end

-- 效果②：放置指示物条件
function s.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsFaceup()
end

function s.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,s.soul_setcode)
end

function s.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		c:AddCounter(s.soul_setcode,1)
	end
end

-- 效果③：可以在双方回合发动
function s.linkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end

-- 效果③：去除指示物作为代价
function s.linkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST) end
	Duel.RemoveCounter(tp,1,0,s.soul_setcode,1,REASON_COST)
end

-- 效果③：目标设定
function s.linktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g=Group.FromCards(c)
		-- 检查是否有可用的炽魂连接怪兽
		local exg=Duel.GetMatchingGroup(s.linkfilter1,tp,LOCATION_EXTRA,0,nil)
		return exg:GetCount()>0 and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 第一次连接召唤的筛选器
function s.linkfilter1(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil,nil,1,1)
end

-- 操作处理
function s.linkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	-- 第一次连接召唤：用自身为素材召唤炽魂连接怪兽
	local g=Group.FromCards(c)
	local exg=Duel.GetMatchingGroup(s.linkfilter1,tp,LOCATION_EXTRA,0,nil)
	if exg:GetCount()==0 then return end
	Duel.Release(c,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lc1=exg:Select(tp,1,1,nil):GetFirst()
	
	-- 进行第一次连接召唤
	
	Duel.SpecialSummon(lc1,0,tp,tp,true,false,POS_FACEUP)
	
	-- 询问是否进行第二次连接召唤
	
	local lz = false
	if s.check_quick_spell(tp) then
		lz =true
	end
	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
		-- 第二次连接召唤：用第一次召唤的怪兽为素材再次连接召唤
		local g2=Group.FromCards(lc1)
		local exg2=Duel.GetMatchingGroup(s.linkfilter2,tp,LOCATION_EXTRA,0,nil)
		if exg2:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local lc2=exg2:Select(tp,1,1,nil):GetFirst()
			if lc2 then
				-- 进行第二次连接召唤
				Duel.LinkSummon(tp,lc2,nil,lc1)
				
				-- 检查是否有表侧表示的炽魂速攻魔法卡
				if lz then
					-- 给第二次连接召唤的怪兽添加效果
					local e1=Effect.CreateEffect(c)
					e1:SetDescription(aux.Stringid(id,3))
					e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
					e1:SetType(EFFECT_TYPE_QUICK_O)
					e1:SetCode(EVENT_FREE_CHAIN)
					e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
					e1:SetRange(LOCATION_MZONE)
					e1:SetCountLimit(1)
					e1:SetCondition(s.linkcon2)
					e1:SetTarget(s.linktg2)
					e1:SetOperation(s.linkop2)
					lc2:RegisterEffect(e1)
				end
			end
		else
			Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,5))
		end
	else
		Duel.Hint(HINT_OPSELECTED,tp,aux.Stringid(id,6))
	end
end

-- 第二次连接召唤的筛选器
function s.linkfilter2(c)
	return c:IsSetCard(s.soul_setcode) and c:IsType(TYPE_LINK) and c:IsLinkSummonable(nil,nil,1,1)
end

-- 检查场上有表侧表示的炽魂速攻魔法卡
function s.check_quick_spell(tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)
	for tc in aux.Next(g) do
		if tc:IsSetCard(s.soul_setcode) and tc:IsType(TYPE_QUICKPLAY) then
			return true
		end
	end
	return false
end

-- 给予效果的发动条件
function s.linkcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp or Duel.GetTurnPlayer()==1-tp
end

-- 给予效果的目标设定
function s.linktg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local g=Group.FromCards(c)
		local exg=Duel.GetMatchingGroup(s.linkfilter1,tp,LOCATION_EXTRA,0,nil)
		return exg:GetCount()>0 and Duel.GetLocationCountFromEx(tp,tp,g,c)>0
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

-- 给予效果的操作处理
function s.linkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	
	-- 用这张卡为素材进行炽魂连接怪兽的连接召唤
	local g=Group.FromCards(c)
	local exg=Duel.GetMatchingGroup(s.linkfilter1,tp,LOCATION_EXTRA,0,nil)
	if exg:GetCount()==0 then return end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lc=exg:Select(tp,1,1,nil):GetFirst()	
	-- 进行连接召唤
	Duel.LinkSummon(tp,lc,nil,c)
end