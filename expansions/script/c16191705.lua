-- 4星怪兽×3
local s,id=GetID()
function s.initial_effect(c)
	-- 常规超量召唤手续：4星怪兽×3
	aux.AddXyzProcedure(c,nil,4,3)
	
	-- 不能作为超量召唤的素材
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)

	-- 【核心】附加超量召唤方法：满足条件时用手卡/场上的怪兽作为素材
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_XYZ) -- 确保其被视为超量召唤
	e1:SetCondition(s.altxyzcon)
	e1:SetTarget(s.altxyztg)
	e1:SetOperation(s.altxyzop)
	c:RegisterEffect(e1)

	-- ①：可以把这张卡1个超量素材取除，从以下效果选择1个发动（共享Cost，分为2个独立效果处理）
	
	-- ●效果A：自己·对方回合1次，无效对方场上1只效果怪兽，己方回合附带封锁
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCountLimit(1)
	e2:SetCost(s.cost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)

	-- ●效果B：自己回合1次，对方特召时抽卡并回洗手卡
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(s.drcon)
	e3:SetCost(s.cost)
	e3:SetTarget(s.drtg)
	e3:SetOperation(s.drop)
	c:RegisterEffect(e3)
end

-- 拔除素材Cost
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

-------------------------------------------------------------------------
-- 【手卡/场上作为4星怪兽超量召唤的实现】
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 【替换部分：手卡任意卡/场上怪兽作为4星怪兽超量召唤的实现】
-- （兼容旧内核，抛弃 SelectUnselectGroup 的纯原生 API 写法）
-------------------------------------------------------------------------

-- 1. 过滤条件：场上必须是怪兽，手卡则无视类型（魔陷也可以）
function s.altxyz_filter(c,xyzc)
	if c:IsLocation(LOCATION_MZONE) then
		return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCanBeXyzMaterial(xyzc)
	else
		return true
	end
end

-- 2. 占位检测：判断选这张场上的卡能否为额外卡组的超量怪兽腾出格子
function s.zone_filter(c,tp,xyzc)
	return c:IsLocation(LOCATION_MZONE) and Duel.GetLocationCountFromEx(tp,tp,c,xyzc)>0
end

-- 3. 召唤条件：检测是否满足特召标准
function s.altxyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	
	-- 数量差值判断
	local opp_ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND+LOCATION_GRAVE)
	local my_ct=Duel.GetFieldGroupCount(tp,LOCATION_HAND+LOCATION_ONFIELD,0)
	if opp_ct <= my_ct then return false end
	
	-- 必须至少有3张符合条件的卡
	local mg=Duel.GetMatchingGroup(s.altxyz_filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	if mg:GetCount()<3 then return false end
	
	-- 如果直接就有额外空位，随便凑3张就行
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 then return true end
	
	-- 如果没有空位，则场上必须至少有1只怪兽能腾出空位
	return mg:IsExists(s.zone_filter,1,nil,tp,c)
end

-- 4. 选材目标：实现手动合规选取
function s.altxyztg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
	local mg=Duel.GetMatchingGroup(s.altxyz_filter,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	local g=Group.CreateGroup()
	
	-- 【步骤 A】：如果当前额外区域没有空位，强制玩家必须先选1张能腾出格子的场上怪兽
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg1=mg:FilterSelect(tp,s.zone_filter,1,1,nil,tp,c)
		-- 如果玩家右键取消了选择，中断召唤
		if not sg1 or sg1:GetCount()==0 then return false end 
		g:Merge(sg1)
		mg:Sub(sg1) -- 从总池子中剔除已选的卡
	end
	
	-- 【步骤 B】：选满剩下的数量，凑齐3张
	local rem = 3 - g:GetCount()
	if rem > 0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		-- 如果一开始就有空位，这里会直接选3张；如果是补选，这里会选2张
		local sg2=mg:Select(tp,rem,rem,nil)
		if not sg2 or sg2:GetCount()<rem then return false end
		g:Merge(sg2)
	end
	
	if g:GetCount()==3 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else 
		return false 
	end
end

-- 5. 叠放操作：将选好的卡转化为素材
function s.altxyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local mg=e:GetLabelObject()
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	mg:DeleteGroup()
	Duel.ShuffleHand(tp)
end

-------------------------------------------------------------------------
-- 【无效效果实现】（非取对象无效）
-------------------------------------------------------------------------
function s.disfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EFFECT) and not c:IsDisabled()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.disfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_NEGATE)
	local g=Duel.SelectMatchingCard(tp,s.disfilter,tp,0,LOCATION_MZONE,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if tc then
		Duel.HintSelection(g)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
	-- 如果在自己回合发动，追加封锁
	if Duel.GetTurnPlayer()==tp then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_ACTIVATE)
		e3:SetTargetRange(0,1)
		e3:SetValue(s.aclimit)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function s.aclimit(e,re,tp)
	local loc=re:GetActivateLocation()
	return re:IsActiveType(TYPE_MONSTER) and (loc==LOCATION_HAND or loc==LOCATION_GRAVE)
end

-------------------------------------------------------------------------
-- 【抽卡效果实现】
-------------------------------------------------------------------------
function s.spfilter(c,tp)
	return c:IsSummonPlayer(1-tp)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(s.spfilter,1,nil,tp)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local spg=eg:Filter(s.spfilter,nil,tp)
	local max_lvl=0
	for tc in aux.Next(spg) do
		local lvl=tc:GetLevel()
		if lvl>max_lvl then max_lvl=lvl end
	end
	-- 必须能取到等级，且允许抽卡
	if chk==0 then return max_lvl>0 and Duel.IsPlayerCanDraw(tp,max_lvl) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(max_lvl)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,max_lvl)
	if max_lvl>2 then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,max_lvl-2,tp,LOCATION_HAND)
	end
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		local ret=d-2
		if ret>0 then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(p,Card.IsAbleToDeck,p,LOCATION_HAND,0,ret,ret,nil)
			if #g>0 then
				Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
			end
		end
	end
end