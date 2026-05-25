-- 喘气
--Duel.LoadScript("c.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- ①：速攻魔法发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,7))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.isChaosZeroNightmare=true -- 标记该卡有灵光一闪效果记述

-- 灵光一闪衍生物过滤
function cm.lf_filter(c)
	return c:IsCode(60013002) and c:IsFaceup()
end

-- 有灵光一闪效果/维若妮卡卡名的过滤
function cm.target_filter(c)
	-- 判断是否有灵光一闪效果（isChaosZeroNightmare） 或 是维若妮卡（60013012）
	return c.isChaosZeroNightmare or c:GetCode()==60013012
end

-- 目标检查
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 初始化所有选项为false
	local b1=false
	local b2=false
	local b3=false
	local b4=false
	
	-- 选项1：不进行灵光一闪（基础效果）
	if Duel.IsPlayerCanDraw(tp,2) then b1=true end
	-- 选项2：灵光一闪I（改为抽4张）
	if Duel.IsPlayerCanDraw(tp,4) and Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	-- 选项3：灵光一闪II（送去墓地改为不需要）
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	-- 选项4：灵光一闪III（抽1+检索，灵光一闪IV额外刻度+2）
	if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.target_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	
	if chk==0 then return b1 or b2 or b3 or b4 end
end

-- 效果执行
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 重新检查选项可用性
	local b1=false
	local b2=false
	local b3=false
	local b4=false
	
	if Duel.IsPlayerCanDraw(tp,2) then b1=true end
	if Duel.IsPlayerCanDraw(tp,4) and Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) then b2=true end
	if Duel.IsPlayerCanDraw(tp,2) and Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) then b3=true end
	if Duel.IsPlayerCanDraw(tp,1) and Duel.IsExistingMatchingCard(cm.target_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) 
		and Duel.IsExistingMatchingCard(cm.lf_filter,tp,LOCATION_SZONE,0,1,nil) then b4=true end
	
	if not b1 and not b2 and not b3 and not b4 then return end
	
	-- 选择强化选项
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(m,1)},  -- 不进行灵光一闪
		{b2,aux.Stringid(m,2)},  -- 灵光一闪I
		{b3,aux.Stringid(m,3)},  -- 灵光一闪II
		{b4,aux.Stringid(m,4)})  -- 灵光一闪III/IV
	
	-- 灵光一闪选项需要破坏衍生物
	if op>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.GetMatchingGroup(cm.lf_filter,tp,LOCATION_SZONE,0,nil):Select(tp,1,1,nil)
		if not Duel.Destroy(dg,REASON_EFFECT) then return end
	end
	
	-- 执行对应效果
	if op==1 then
		-- 基础效果：抽2张，非灵光一闪/非维若妮卡的卡送去墓地
		local g=Duel.GetDecktopGroup(tp,2)
		Duel.Draw(tp,2,REASON_EFFECT)
		local sg=g:Filter(function(c) return not cm.target_filter(c) end,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	elseif op==2 then
		-- 灵光一闪I：改为抽4张
		Duel.Draw(tp,4,REASON_EFFECT)
		-- 基础规则：非灵光一闪/非维若妮卡的卡送去墓地
		local g=Duel.GetDecktopGroup(tp,4)
		local sg=g:Filter(function(c) return not cm.target_filter(c) end,nil)
		if sg:GetCount()>0 then
			Duel.SendtoGrave(sg,REASON_EFFECT)
		end
	elseif op==3 then
		-- 灵光一闪II：抽2张，送去墓地改为不需要
		Duel.Draw(tp,2,REASON_EFFECT)
		-- 无墓地发送流程
	elseif op==4 then
		-- 灵光一闪III：抽1张 + 检索灵光一闪/维若妮卡卡
		Duel.Draw(tp,1,REASON_EFFECT)
		
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.target_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		
		-- 灵光一闪IV：左侧灵摆区刻度+2
		local lc=Duel.GetFieldCard(tp,LOCATION_PZONE,0)
		if lc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LSCALE)
			e1:SetValue(2)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			lc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_RSCALE)
			lc:RegisterEffect(e2)
		end
	end
end