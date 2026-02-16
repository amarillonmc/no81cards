--Card Name: (Custom Synchro Monster)
local s,id=GetID()
-- 递归检查辅助函数
s.SelectUnselectLoop=function(c,sg,mg,e,tp,min,max,rescon)
	local res=false
	if #sg>=min and #sg<=max then
		-- 检查当前组合是否满足条件
		if not rescon or rescon(sg,e,tp,mg,c) then return true end
	end
	-- 如果未达到最大值，尝试添加下一张卡
	if #sg<max then
		res=mg:IsExists(function(tc)
			if sg:IsContains(tc) then return false end
			sg:AddCard(tc)
			local res2=s.SelectUnselectLoop(tc,sg,mg,e,tp,min,max,rescon)
			sg:RemoveCard(tc)
			return res2
		end, 1, nil)
	end
	return res
end

-- 主函数：SelectUnselectGroup
s.SelectUnselectGroup=function(g,e,tp,min,max,rescon,chk,seltp,hintmsg,finishcon,breakcon,cancelcon)
	local min=min or 1
	local max=max or 1
	local chk=chk or 0
	local seltp=seltp or tp
	
	-- chk==0：仅检查是否存在满足条件的组合（用于 Target/Cost 的检测阶段）
	if chk==0 then
		if #g<min then return false end
		local sg=Group.CreateGroup()
		return s.SelectUnselectLoop(nil,sg,g,e,tp,min,max,rescon)
	end

	-- chk==1：执行选择操作
	local sg=Group.CreateGroup()
	while true do
		-- 判断当前状态是否可以完成选择（finishable）
		local finishable = #sg>=min and #sg<=max and (not rescon or rescon(sg,e,tp,g))
		
		-- 准备候选池：g 中尚未被选择的卡
		local mg=g:Filter(function(c) return not sg:IsContains(c) end, nil)
		
		-- 调用核心函数 SelectUnselect
		-- 参数：候选组, 已选组, 玩家, 是否可完成, 是否可取消
		-- 注意：cancelable 默认为 finishable，或者由 cancelcon 决定
		Duel.Hint(HINT_SELECTMSG,seltp,hintmsg or HINTMSG_SELECT)
		local tc=mg:SelectUnselect(sg,seltp,finishable,finishable or (cancelcon and cancelcon(sg,e,tp,g)),min,max)
		
		if not tc then break end -- 玩家确认完成或取消
		
		if sg:IsContains(tc) then
			sg:RemoveCard(tc) -- 如果卡在已选组中，则取消选择
		else
			sg:AddCard(tc)  -- 否则添加到已选组
		end
		
		-- 检查是否满足跳出条件（例如 breakcon）
		if breakcon and breakcon(sg,e,tp,mg) then break end
	end
	return sg
end
function s.initial_effect(c)
	--Synchro Summon
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	
	--Effect 1: Token Generation (Mandatory Trigger)
	--①：每次对方把怪兽的效果发动则发动。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.tkcon)
	e1:SetTarget(s.tktg)
	e1:SetOperation(s.tkop)
	c:RegisterEffect(e1)
	
	--Effect 2: Release Tokens to Revive (Quick Effect)
	--②：自己·对方的主要阶段，把自己场上的衍生物任意数量解放...发动。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(2,id)
	e2:SetCondition(s.spcon)
	e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

--Effect 1 Logic
function s.tkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end

function s.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end -- Mandatory effect
	e:SetLabel(re:GetHandler():GetOriginalLevel())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function s.tkop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	
	-- Only spawn if Level > 0 (Xyz/Link have 0 level) and we have space
	if lv>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,id+1,0,TYPES_TOKEN_MONSTER,1000,1000,lv,RACE_INSECT,ATTRIBUTE_DARK) then
		
		local token=Duel.CreateToken(tp,id+1)
		
		-- Set Stats manually to ensure accuracy (references Source 21-22)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
		token:RegisterEffect(e1)
		
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
	end
end

--Effect 2 Logic
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end

function s.costfilter(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end

function s.gyfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLevelAbove(1)
end

-- Check if a selected group of tokens has a valid target in GY
function s.costcheck(sg,e,tp,mg)
	local sum=sg:GetSum(Card.GetLevel)
	-- Duel.GetMZoneCount(tp,sg) ensures we count the zones freed by tokens
	return Duel.GetMZoneCount(tp,sg)>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,sum)
end

-- Target filter: Level must be STRICTLY LOWER than sum (Level < Sum)
function s.spfilter(c,sum)
	return c:IsLevelBelow(sum-1)
end

function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_MZONE,0,nil)
	-- Optimization: Quick check if any valid target exists at all
	local gy=Duel.GetMatchingGroup(s.gyfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	
	if chk==0 then
		if #g==0 or #gy==0 then return false end
		-- Check if it's theoretically possible to exceed the minimum level in GY
		local max_sum=g:GetSum(Card.GetLevel)
		local min_lv=gy:GetMin(Card.GetLevel)
		return max_sum > min_lv
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	-- SelectUnselectGroup handles the logic of "Select any number that satisfies the condition"
	local sg=s.SelectUnselectGroup(g,e,tp,1,99,s.costcheck,1,tp,HINTMSG_RELEASE)
	
	local sum=sg:GetSum(Card.GetLevel)
	e:SetLabel(sum) -- Store the sum for the Target function
	Duel.Release(sg,REASON_COST)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.spfilter(chkc,e:GetLabel()) end
	if chk==0 then return true end -- Cost checked validity already
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end