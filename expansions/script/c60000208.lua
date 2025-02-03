-- 执君命（通常陷阱）
-- 卡号：60000208
local s, id = GetID()

local CARD_PULAO = 60000196	  -- 蒲牢·华钟的卡号
local WANSHI_COUNTER = 0x62b	 -- 万世铭指示物类型

function s.initial_effect(c)
	-- 添加卡名记述
	aux.AddCodeList(c,CARD_PULAO)
	
	-- 允许手牌发动（需场上有表侧蒲牢）
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)
	
	-- 常规发动处理
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 手牌发动条件：场上有表侧蒲牢
function s.handcon(e)
	return Duel.IsExistingMatchingCard(s.faceup_pulao_filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end

-- 自定义表侧蒲牢过滤器
function s.faceup_pulao_filter(c)
	return c:IsCode(CARD_PULAO) and c:IsFaceup()
end

-- 目标选择：不取对象破坏对方1张卡
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,0,LOCATION_ONFIELD)
end

-- 主要效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 不取对象破坏对方1张卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if #g==0 or Duel.Destroy(g,REASON_EFFECT)==0 then return end
	
	-- 后续分支效果（全部提供用户选择）
	s.draw_effect(e,tp)
	s.set_effect(e,tp)
	s.exc_effect(e,tp)
end

--------------------
-- 后续效果分支（全部添加用户选择）
--------------------

-- 抽卡效果（场地区有表侧卡）
function s.draw_effect(e,tp)
	local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
	if fc and fc:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

-- 盖放魔法陷阱（有表侧蒲牢且墓地有卡）
function s.setfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,CARD_PULAO)
	and c:IsSSetable() and not c:IsCode(id)
end

function s.set_effect(e,tp)
	if Duel.IsExistingMatchingCard(s.faceup_pulao_filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.setfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SSet(tp,g:GetFirst())
		end
	end
end

-- 除外效果（有可放指示物的其他表侧怪兽）
function s.excfilter(c)
	return c:IsFaceup() and c:IsCanAddCounter(WANSHI_COUNTER,1)
	and not c:IsCode(CARD_PULAO)
end

function s.exc_effect(e,tp)
	if Duel.IsExistingMatchingCard(s.excfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EXCLUDE)
		local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
end