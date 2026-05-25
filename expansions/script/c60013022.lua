-- 准备发射
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- ①：发动时的效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,7))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.act1_target)
	e1:SetOperation(cm.act1_activate)
	c:RegisterEffect(e1)
	-- ②：准备阶段的效果
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,8))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(cm.act2_target)
	e2:SetOperation(cm.act2_activate)
	c:RegisterEffect(e2)
end
cm.isChaosZeroNightmare=true

-- 灵光一闪衍生物的过滤
function cm.lf_filter(c)
	return c:IsCode(60013002) and c:IsFaceup()
end

-- 基础投射机的过滤
function cm.base_proj_filter(c)
	return c:GetCode()==60013019
end

-- 所有投射机的过滤（60013014~60013019）
function cm.all_proj_filter(c)
	local cid=c:GetCode()
	return cid>=60013014 and cid<=60013019
end

-- ①的目标检查
function cm.act1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 先初始化所有b变量为false
	local b1=false
	local b2=false
	local b3=false
	
	-- 选项1：不进行灵光一闪，原本效果
	if Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	-- 选项2：灵光一闪I，破坏衍生物，可选择所有投射机
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	-- 选项3：灵光一闪II，破坏衍生物，原本效果+抽卡
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b3=true end
	
	if chk==0 then return b1 or b2 or b3 end
end

-- ①的效果执行
function cm.act1_activate(e,tp,eg,ep,ev,re,r,rp)
	-- 先初始化所有b变量为false
	local b1=false
	local b2=false
	local b3=false
	
	-- 重新检查选项可用性
	if Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b3=true end
	
	if not b1 and not b2 and not b3 then return end
	
	-- 选择操作选项
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,2)}, -- 不进行灵光一闪
		{b2,aux.Stringid(m,3)}, -- 灵光一闪I
		{b3,aux.Stringid(m,4)}) -- 灵光一闪II
	
	-- 灵光一闪选项需要破坏衍生物
	if op>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.lf_filter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	
	-- 执行对应效果
	if op==1 then
		-- 原本效果：放置基础投射机到右侧灵摆区，刻度1
		Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
		local g=Duel.SelectMatchingCard(tp,cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			-- 添加灵摆类型
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_PENDULUM)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e0)
			
			-- 设置灵摆刻度为1
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)
			
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			tc:RegisterEffect(e2)
			
			-- 移动到右侧灵摆区（序号1）
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,1)
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	elseif op==2 then
		-- 灵光一闪I：放置任意投射机到右侧灵摆区，刻度1
		Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
		local g=Duel.SelectMatchingCard(tp,cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			-- 添加灵摆类型
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_PENDULUM)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e0)
			
			-- 设置灵摆刻度为1
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)
			
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			tc:RegisterEffect(e2)
			
			-- 移动到右侧灵摆区（序号1）
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,1)
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
	elseif op==3 then
		-- 灵光一闪II：放置基础投射机到右侧灵摆区，之后抽1张
		Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
		local g=Duel.SelectMatchingCard(tp,cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			-- 添加灵摆类型
			local e0=Effect.CreateEffect(e:GetHandler())
			e0:SetType(EFFECT_TYPE_SINGLE)
			e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e0:SetCode(EFFECT_ADD_TYPE)
			e0:SetValue(TYPE_PENDULUM)
			e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e0)
			
			-- 设置灵摆刻度为1
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
			tc:RegisterEffect(e1)
			
			local e2=e1:Clone()
			e2:SetCode(EFFECT_CHANGE_RSCALE)
			tc:RegisterEffect(e2)
			
			-- 移动到右侧灵摆区（序号1）
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,1)
			tc:SetStatus(STATUS_EFFECT_ENABLED,true)
		end
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end

-- ②的目标检查
function cm.act2_target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 先初始化所有b变量为false
	local b1=false
	local b2=false
	local b3=false
	
	-- 选项1：不进行灵光一闪，原本效果
	if Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	-- 选项2：灵光一闪III，破坏衍生物，可选择所有投射机
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	-- 选项3：灵光一闪IV，破坏衍生物，原本效果+抽卡
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b3=true end
	
	if chk==0 then return b1 or b2 or b3 end
end

-- ②的效果执行
function cm.act2_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 先初始化所有b变量为false
	local b1=false
	local b2=false
	local b3=false
	
	-- 重新检查选项可用性
	if Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b3=true end
	
	if not b1 and not b2 and not b3 then return end
	
	-- 选择操作选项
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,5)}, -- 不进行灵光一闪
		{b2,aux.Stringid(m,6)}, -- 灵光一闪III
		{b3,aux.Stringid(m,7)}) -- 灵光一闪IV
	
	-- 灵光一闪选项需要破坏衍生物
	if op>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.lf_filter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	
	-- 检查左侧灵摆区是否已有卡
	local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
	if op==1 then
		-- 原本效果
		if lc then
			-- 已有卡，令其刻度+1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			lc:RegisterEffect(e2)
		else
			-- 无卡，放置基础投射机到左侧灵摆区，刻度1
			Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
			local g=Duel.SelectMatchingCard(tp,cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				-- 添加灵摆类型
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetCode(EFFECT_ADD_TYPE)
				e0:SetValue(TYPE_PENDULUM)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e0)
				
				-- 设置灵摆刻度为1
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e1)
				
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				tc:RegisterEffect(e2)
				
				-- 移动到左侧灵摆区（序号0）
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,0)
				tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
		end
	elseif op==2 then
		-- 灵光一闪III
		if lc then
			-- 已有卡，令其刻度+1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			lc:RegisterEffect(e2)
		else
			-- 无卡，放置任意投射机到左侧灵摆区，刻度1
			Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
			local g=Duel.SelectMatchingCard(tp,cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				-- 添加灵摆类型
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetCode(EFFECT_ADD_TYPE)
				e0:SetValue(TYPE_PENDULUM)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e0)
				
				-- 设置灵摆刻度为1
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e1)
				
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				tc:RegisterEffect(e2)
				
				-- 移动到左侧灵摆区（序号0）
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,0)
				tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
		end
	elseif op==3 then
		-- 灵光一闪IV
		if lc then
			-- 已有卡，令其刻度+1
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			lc:RegisterEffect(e2)
		else
			-- 无卡，放置基础投射机到左侧灵摆区，刻度1
			Duel.Hint(HINT_SELECTMSG,tp,HINT_SELECTMSG)
			local g=Duel.SelectMatchingCard(tp,cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
			local tc=g:GetFirst()
			if tc then
				-- 添加灵摆类型
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e0:SetCode(EFFECT_ADD_TYPE)
				e0:SetValue(TYPE_PENDULUM)
				e0:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e0)
				
				-- 设置灵摆刻度为1
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e1)
				
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				tc:RegisterEffect(e2)
				
				-- 移动到左侧灵摆区（序号0）
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,0)
				tc:SetStatus(STATUS_EFFECT_ENABLED,true)
			end
		end
		-- 抽1张卡
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
