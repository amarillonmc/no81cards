local s,id=GetID()
function s.initial_effect(c)
	--spsummon limit
	c:SetSPSummonOnce(id)
	-- 超量召唤手续
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165) -- "超量召唤"
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_XYZ)
	e0:SetCondition(s.xyzcon)
	e0:SetTarget(s.xyztg)
	e0:SetOperation(s.xyzop)
	c:RegisterEffect(e0)

	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.negcon)
	e1:SetCost(s.negcost)
	e1:SetTarget(s.negtg)
	e1:SetOperation(s.negop)
	c:RegisterEffect(e1)

	-- 全局检测：记录“在怪兽区域发动过效果”
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- 记录发动过效果的怪兽
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	-- 判断是否是怪兽效果，且在怪兽区域发动
	if re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE then
		local rc=re:GetHandler()
		-- 给发动效果的怪兽打上标记 (ID作为Flag)
		-- 标记持续到回合结束，RESET_EVENT防止离场后重置导致的判定问题（虽然离场后通常无法作为素材）
		rc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end

-- 素材筛选过滤器
function s.mfilter(c,xyzc,tp)
	-- 基础检查：表侧、可作素材
	if not c:IsFaceup() or not c:IsCanBeXyzMaterial(xyzc) then return false end
	
	-- 逻辑分支：
	if c:IsControler(tp) then
		-- 自己场上：要么是8星(正规素材)，要么满足特殊条件(本回合SS+发动过效果)
		return c:IsXyzLevel(xyzc,8) or (c:IsStatus(STATUS_SPSUMMON_TURN) and c:GetFlagEffect(id)>0)
	else
		-- 对方场上：必须满足特殊条件
		return c:IsStatus(STATUS_SPSUMMON_TURN) and c:GetFlagEffect(id)>0
	end
end
-- 组合检查器：判断选中的素材组是否合法
function s.xyzcheck(g,tp,xyzc)
	-- 必须是2张卡 (根据需求：8星x2)
	if #g~=2 then return false end
	
	local opp_cnt = 0	  -- 对方特殊素材计数
	local self_sub_cnt = 0   -- 自己特殊素材计数(非8星)
	for tc in aux.Next(g) do
		if tc:IsControler(1-tp) then
			opp_cnt = opp_cnt + 1
		else
			-- 如果自己的卡不是8星，则必须占用“特殊名额”
			-- (如果它既是8星又是特殊状态，优先视为8星，不增加计数)
			if not tc:IsXyzLevel(xyzc,8) then
				self_sub_cnt = self_sub_cnt + 1
			end
		end
	end
	
	-- 额外格/L怪兽箭头检查
	if Duel.GetLocationCountFromEx(tp,tp,g,xyzc)<=0 then return false end
	-- 限制条件：对方最多1只，自己作为非8星代用的最多1只
	return opp_cnt <= 1 and self_sub_cnt <= 1
end
-- 召唤条件 (严格参照 Auxiliary.XyzLevelFreeCondition)
function s.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	
	-- 初始化最小/最大素材数 (默认为2)
	local minc=2
	local maxc=2
	
	-- 兼容性处理：如果引擎传入了min/max参数（例如被其他卡片效果修改），进行修正
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	
	-- 如果修正后最小需求大于最大需求，无法召唤
	if minc>maxc then return false end
	-- 1. 获取所有可能的素材
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
	end
	-- 2. 处理“必须作为素材”的卡 (Must Material Check)
	-- 这是procedure.lua中非常重要的一环，防止无视由于效果导致必须使用的卡
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
	
	-- 将必须使用的卡设为已选中，并检查剩余卡是否满足条件
	Duel.SetSelectedCard(sg)
	
	-- 3. 检查子集是否存在
	-- CheckSubGroup 会自动考虑 SetSelectedCard 中的卡
	return mg:CheckSubGroup(s.xyzcheck,minc,maxc,tp,c)
end
-- 召唤目标选择 (严格参照 Auxiliary.XyzLevelFreeTarget)
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	if og and not min then return true end
	
	local minc=2
	local maxc=2
	if min then
		if min>minc then minc=min end
		if max<maxc then maxc=max end
	end
	
	local mg=nil
	if og then
		mg=og
	else
		mg=Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
	end
	
	local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
	Duel.SetSelectedCard(sg)
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local cancel=Duel.IsSummonCancelable()
	
	local g=mg:SelectSubGroup(tp,s.xyzcheck,cancel,minc,maxc,tp,c)
	
	if g and #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else
		return false
	end
end
-- 召唤操作 (严格参照 Auxiliary.XyzLevelFreeOperation)
function s.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	if og and not min then
		local sg=Group.CreateGroup()
		local tc=og:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=og:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(og)
		Duel.Overlay(c,og)
	else
		local mg=e:GetLabelObject()
		local sg=Group.CreateGroup()
		local tc=mg:GetFirst()
		while tc do
			local sg1=tc:GetOverlayGroup()
			sg:Merge(sg1)
			tc=mg:GetNext()
		end
		Duel.SendtoGrave(sg,REASON_RULE)
		c:SetMaterial(mg)
		Duel.Overlay(c,mg)
		mg:DeleteGroup()
	end
end

function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local tc=Duel.GetOperatedGroup():GetFirst()
	e:SetLabelObject(tc)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) then
		local tc=e:GetLabelObject()
		if tc and tc:IsLocation(LOCATION_GRAVE) then
			--Grant effect
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(id,1))
			e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_QUICK_F)
			e1:SetCode(EVENT_CHAINING)
			e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
			e1:SetRange(LOCATION_GRAVE)
			e1:SetCondition(s.gnegcon)
			e1:SetCost(aux.bfgcost)
			e1:SetTarget(s.gnegtg)
			e1:SetOperation(s.gnegop)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end

function s.gnegcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end

function s.gnegtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end

function s.gnegop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end