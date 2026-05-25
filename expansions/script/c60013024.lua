-- 决心坠饰
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 标记该卡有灵光一闪效果记述
	cm.isChaosZeroNightmare=true
	
	-- ①：发动时的效果（可灵光一闪强化）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,7))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.act1_target)
	e1:SetOperation(cm.act1_activate)
	c:RegisterEffect(e1)
	
	-- ②：永续效果（左侧灵摆刻度+2）
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_LSCALE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetTarget(function(e,c) return c:GetSequence()==0 end) -- 仅左侧灵摆区（序号0）
	e2:SetValue(2)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e3)
end

-- 灵光一闪衍生物过滤
function cm.lf_filter(c)
	return c:IsCode(60013002) and c:IsFaceup() and c:IsLocation(LOCATION_SZONE)
end

-- 基础投射机过滤（60013019）
function cm.base_proj_filter(c)
	return c:GetCode()==60013019
end

-- 所有投射机过滤（60013014~60013019）
function cm.all_proj_filter(c)
	local cid=c:GetCode()
	return cid>=60013014 and cid<=60013019
end

-- ①效果的目标检查
function cm.act1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 初始化所有选项为false
	local b1=false
	local b2=false
	local b3=false
	
	-- 选项1：不进行灵光一闪（基础效果）
	if Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	-- 选项2：灵光一闪I（可选择任意投射机）
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	-- 选项3：灵光一闪II（基础/I效果+抽1卡）
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) 
		and (Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
		or Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) then b3=true end
	
	if chk==0 then return b1 or b2 or b3 end
end

-- ①效果的执行逻辑
function cm.act1_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 重新检查选项可用性
	local b1=false
	local b2=false
	local b3=false
	
	if Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b1=true end
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) 
		and Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) 
		and (Duel.IsExistingMatchingCard(cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
		or Duel.IsExistingMatchingCard(cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)) then b3=true end
	
	if not b1 and not b2 and not b3 then return end
	
	-- 选择强化选项（同一效果仅能选一种强化）
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},  -- 不进行灵光一闪
		{b2,aux.Stringid(m,2)},  -- 灵光一闪I
		{b3,aux.Stringid(m,3)})  -- 灵光一闪II
	
	-- 灵光一闪选项需要先破坏衍生物
	local draw_flag=false -- 标记是否需要抽卡（灵光一闪II）
	if op>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.lf_filter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
		
		-- 灵光一闪II需要标记抽卡
		if op==3 then draw_flag=true end
	end
	
	-- 执行灵摆卡放置逻辑
	local g=nil
	if op==1 or (op==3 and b1) then
		-- 基础效果/灵光一闪II（选基础投射机）
		g=Duel.SelectMatchingCard(tp,cm.base_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	elseif op==2 or (op==3 and b2) then
		-- 灵光一闪I/灵光一闪II（选任意投射机）
		g=Duel.SelectMatchingCard(tp,cm.all_proj_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	end
	
	if g and g:GetCount()>0 then
		local tc=g:GetFirst()
		-- 添加灵摆类型（对齐示例代码）
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
		
		-- 放置到右侧灵摆区（序号1）
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,false,1)
		tc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	
	-- 灵光一闪II额外抽1卡
	if draw_flag then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end