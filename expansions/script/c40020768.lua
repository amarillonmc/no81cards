--神皇妖蛇 提亚玛德
local s,id=GetID()
function s.DarkSnake(c)
	local m = _G["c"..c:GetCode()]
	if m and m.named_with_DarkSnake then return true end
	if c:GetCode() == s.KUKULKAN_CODE and c:IsLocation(LOCATION_PZONE) then return true end 
	return false
end
s.named_with_DarkSnake=1
s.KUKULKAN_CODE=40020764
function s.initial_effect(c)

	aux.AddXyzProcedure(c,nil,7,3)
	c:EnableReviveLimit()

	-- 超量召唤手续2：自定义超量（除外代价 + 场上/额外卡组叠放）
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.spcon)
	e0:SetTarget(s.sptg)
	e0:SetOperation(s.spop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id+1)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
end
function s.kukulkanfilter(c)
	return c:IsCode(s.KUKULKAN_CODE) and c:IsFaceup()
end

-- ========== 自定义超量召唤手续 ==========
function s.rmfilter(c)
	if not (c:IsCode(s.KUKULKAN_CODE) and c:IsAbleToRemoveAsCost()) then return false end
	if c:IsLocation(LOCATION_PZONE) then return true end
	return c:IsLocation(LOCATION_HAND+LOCATION_GRAVE)
end

function s.ovfilter(c)
	return c:IsCode(s.KUKULKAN_CODE) and c:IsFaceup() and c:IsLocation(LOCATION_ONFIELD+LOCATION_EXTRA)
end

function s.spcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,id)>0 then return false end
	
	local rmg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local ovg=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
	if #rmg==0 or #ovg==0 then return false end
	
	for tc in aux.Next(ovg) do
		local rmc=rmg:Clone()
		rmc:RemoveCard(tc)
		if #rmc>0 then return true end
	end
	return false
end

function s.normalxyzfilter(c,xyzc)
	return c:IsLevel(7) and c:IsCanBeXyzMaterial(xyzc,nil)
end

-- 标记过滤器
function s.ovmarkfilter(c)
	return c:GetFlagEffect(id+100)>0
end

function s.rmmarkfilter(c)
	return c:GetFlagEffect(id+101)>0
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	
	local normalMg=Duel.GetMatchingGroup(s.normalxyzfilter,tp,LOCATION_MZONE,0,nil,c)
	if #normalMg>=3 then
		if not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			return false
		end
	end
	
	local rmg=Duel.GetMatchingGroup(s.rmfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD,0,nil)
	local ovg=Duel.GetMatchingGroup(s.ovfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local ov=ovg:Select(tp,1,1,nil)
	local ovc=ov:GetFirst()
	
	rmg:RemoveCard(ovc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rm=rmg:Select(tp,1,1,nil)
	local rmc=rm:GetFirst()
	
	-- 【修复重点】在选中的卡上注册临时标记
	ovc:RegisterFlagEffect(id+100,0,0,1)  -- 叠放素材标记
	rmc:RegisterFlagEffect(id+101,0,0,1)  -- 除外代价标记
	
	return true
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- 【修复重点】通过标记找到除外用的卡
	local rmg=Duel.GetMatchingGroup(s.rmmarkfilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
	if #rmg>0 then
		local rmc=rmg:GetFirst()
		rmc:ResetFlagEffect(id+101)
		Duel.Remove(rmc,POS_FACEUP,REASON_COST)
	end
	
	-- 【修复重点】通过标记找到叠放用的卡
	local ovg=Duel.GetMatchingGroup(s.ovmarkfilter,tp,LOCATION_ONFIELD+LOCATION_EXTRA,0,nil)
	if #ovg>0 then
		local ovc=ovg:GetFirst()
		ovc:ResetFlagEffect(id+100)
		-- 继承原有素材（如果有的话）
		local tcmg=ovc:GetOverlayGroup()
		if #tcmg>0 then
			Duel.Overlay(c,tcmg)
		end
		-- 叠放素材
		Duel.Overlay(c,ovg)
	end
	
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end



-- ========== 效果①：抽卡+特召 ==========
-- 条件：超量召唤成功 + 除外有库库尔坎
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
		and Duel.IsExistingMatchingCard(s.kukulkanfilter,tp,LOCATION_REMOVED,0,1,nil)
end

-- 目标：只需能抽卡即可
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

-- 妖蛇怪兽过滤器（可特召）
function s.spfilter(c,e,tp)
	return s.DarkSnake(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- 处理
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	-- 再次检查条件（除外有库库尔坎）
	if not Duel.IsExistingMatchingCard(s.kukulkanfilter,tp,LOCATION_REMOVED,0,1,nil) then return end
	-- 抽1张
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	-- "那之后"可以特召妖蛇怪兽
	if Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- ========== 效果①：攻击宣言时 ==========
-- 条件：自己的妖蛇怪兽攻击对方怪兽 + 除外有库库尔坎
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return ac and ac:IsControler(tp) and s.DarkSnake(ac)
		and at  -- 有攻击对象（即不是直接攻击）
		and Duel.IsExistingMatchingCard(s.kukulkanfilter,tp,LOCATION_REMOVED,0,1,nil)
end

-- 操作
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ac=Duel.GetAttacker()
	if not ac then return end
	local lp=Duel.GetLP(1-tp)

	if lp>800 then
		if Duel.SelectYesNo(1-tp,aux.Stringid(id,3)) then

			Duel.PayLPCost(1-tp,800)
			return
		end
	end

	if ac:IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) then return end
	if not Duel.SelectYesNo(tp,aux.Stringid(id,4)) then return end

	Duel.ChangeAttackTarget(nil)
end