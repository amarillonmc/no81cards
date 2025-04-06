local cm,m=GetID()

function cm.initial_effect(c)
	-- 效果①：从手卡特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	-- 效果②：解放自身，盖放陷阱
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+5)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end

-- 效果①：目标
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.filter1,tp,0,LOCATION_GRAVE,1,nil)
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,2,PLAYER_ALL,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end

-- 效果①：操作
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,cm.filter1,tp,0,LOCATION_GRAVE,1,1,nil)
	if #g1>0 and #g2>0 then
		g1:Merge(g2)
		if Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)==2 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end

-- 效果①：墓地怪兽筛选
function cm.filter1(c)
	return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end

-- 效果②：成本 - 解放自身
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end

-- 效果②：目标
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	-- 目标选择检查
	if chkc then return chkc:IsLocation(LOCATION_GRAVE)  and cm.tg3filter(chkc,tp) end
	
	if chk==0 then
		-- 核心检测逻辑：检查对方墓地的陷阱卡是否存在"满足自己墓地有对应不同种类"的卡
		return Duel.IsExistingTarget(cm.tg3filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,tp)
	end
	
	-- 提示选择对方墓地的陷阱卡（仅限可满足后续条件的候选目标）
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.tg3filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,tp)
	if #g>0 then
		-- 设置操作信息（移除 + 盖放）
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,1,tp,LOCATION_GRAVE)
	end
end
function cm.tg3filter(c,tp)
	-- 检查自己墓地是否存在不同类型(TYPE)的陷阱卡
	return Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil,c:GetType())	 and c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end

-- 筛选自己墓地不同类型的可盖放陷阱卡
function cm.setfilter(c,ttype)
	return c:IsType(TYPE_TRAP) and c:GetType()~=tttype and c:IsSSetable()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsAbleToRemove() then
		Duel.Remove(tc,POS_FACEUP,REMOVED_REASON_EFFECT)
		local type=tc:GetType()&0x70 --获取种类
		local g=Duel.GetMatchingGroup(cm.filter3,tp,LOCATION_GRAVE,0,nil,type)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SSET)
			local sg=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_GRAVE,0,1,1,nil,type)
			if sg:GetCount()>0 then
				Duel.SSet(tp,sg)
			end
		end
	end
end
-- 效果②：操作
-- 效果②：自己墓地陷阱筛选
function cm.filter3(c,typ)
	return c:IsType(TYPE_TRAP) and (c:GetType()&(TYPE_TRAP))~=typ and c:IsSSetable()
end
