-- 黄金太阳
local cm,m,o=GetID()
function cm.initial_effect(c)
	-- 给这张卡自己添加「神威·不落日」的卡名记述，方便其他系列卡识别
	aux.AddCodeList(c,60001312)
	
	-- ①：手卡效果：给对方确认后发动，检索神威系列魔陷
	-- 改为二速快速效果，符合陷阱卡的效果规则
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.act1_cost)
	e1:SetTarget(cm.act1_target)
	e1:SetOperation(cm.act1_activate)
	c:RegisterEffect(e1)
	
	-- ②：怪兽召唤成功时，墓地效果：回手+对方回合的速攻发动权限
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.act2_target)
	e2:SetOperation(cm.act2_activate)
	c:RegisterEffect(e2)
end

-- 有「神威·不落日」卡名记述的魔陷过滤，排除黄金太阳自己
function cm.sv_filter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and aux.IsCodeListed(c,60001312) and c:GetCode()~=60001317
end

-- 有「神威·不落日」卡名记述的速攻魔法过滤
function cm.sv_quick_filter(c)
	return c:IsType(TYPE_QUICKPLAY) and aux.IsCodeListed(c,60001312)
end

-- ①的cost：把手卡的这张卡给对方确认
function cm.act1_cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsPublic() end
	-- 公开卡片，给对方确认
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	return true
end

-- ①的目标检查
function cm.act1_target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sv_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end

-- ①的效果执行
function cm.act1_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 检索有「神威·不落日」卡名记述的魔陷
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.sv_filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
	-- 这张卡送去墓地
	Duel.SendtoGrave(c,REASON_EFFECT)
end

-- ②的目标检查
function cm.act2_target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

-- ②的效果执行
function cm.act2_activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoHand(c,nil,REASON_EFFECT)>0 then
		-- 如果是对方回合，添加速攻魔法的手卡发动权限
		if Duel.GetTurnPlayer()~=tp then
			-- 仅「神威·不落日」系列的速攻魔法，可在对方回合从手卡发动
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
			e1:SetTargetRange(LOCATION_HAND,0)
			e1:SetTarget(cm.sv_quick_filter)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
