--女神之令-怜
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x611),aux.FilterBoolFunction(Card.IsFusionAttribute,ATTRIBUTE_LIGHT),false)
	
	--①：融合召唤或准备阶段 -> 降星回收
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.thcon2)
	c:RegisterEffect(e2)
	
	--②：展示魔陷 -> 适用效果
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.effcon)
	e3:SetCost(s.effcost)
	e3:SetTarget(s.efftg)
	e3:SetOperation(s.effop)
	c:RegisterEffect(e3)
end

-- === 效果① ===
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return true -- 双方准备阶段均可
end

function s.thfilter(c)
	return c:IsSetCard(0x611) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetLevel()>=3 
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:GetLevel()>=3 then
		-- 等级下降2星
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
		
		-- 回收
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.SendtoHand(g,nil,REASON_EFFECT)
		end
	end
end

-- === 效果② ===
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()~=e:GetHandler()
end

-- 场上可被除外的怪兽过滤器
function s.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAbleToRemove()
end

-- 场上可被无效的魔陷过滤器
function s.sfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup() and not c:IsDisabled()
end

-- Cost过滤器：手卡检查
-- 只有当场上有满足条件的对象时，手卡对应的魔/陷才合法
function s.costfilter(c,tp)
	if not (c:IsSetCard(0x611) and not c:IsPublic()) then return false end
	if c:IsType(TYPE_SPELL) then
		-- 如果是魔法，要求场上有怪兽
		return Duel.IsExistingMatchingCard(s.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	elseif c:IsType(TYPE_TRAP) then
		-- 如果是陷阱，要求场上有魔陷
		return Duel.IsExistingMatchingCard(s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	end
	return false
end

function s.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	-- 这里的 SelectMatchingCard 会自动调用 s.costfilter，确保只能选到场上有对应目标的卡
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	local tc=g:GetFirst()
	
	-- 设置Label用于后续处理
	if tc:IsType(TYPE_SPELL) then
		e:SetLabel(1)
	else
		e:SetLabel(2)
	end
	Duel.ShuffleHand(tp)
end

function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- chk==0 时返回 true 即可，因为具体的合法性检查已经在 Cost 中完成了
	-- 如果 Cost 能够支付成功（找到合法的卡），说明必定有 Target 可供处理
	if chk==0 then return true end
	
	local ty=e:GetLabel()
	if ty==1 then
		e:SetCategory(CATEGORY_REMOVE)
	elseif ty==2 then
		e:SetCategory(CATEGORY_DISABLE)
	end
end

function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local ty=e:GetLabel()
	local c=e:GetHandler()
	
	if ty==1 then
		-- ●魔法：场上最多2只表侧表示怪兽直到连锁结束时除外
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,s.mfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if #g>0 then
			Duel.HintSelection(g)
			if Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY)~=0 then
				local og=Duel.GetOperatedGroup()
				if og:GetCount()>0 then
					og:KeepAlive()
					-- 注册连锁结束回归的效果
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_CHAIN_END)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetLabelObject(og)
					e1:SetCountLimit(1)
					e1:SetOperation(s.retop)
					Duel.RegisterEffect(e1,tp)
				end
			end
		end
		
	elseif ty==2 then
		-- ●陷阱：场上最多2张表侧表示的魔法·陷阱卡的效果直到连锁结束时无效
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,s.sfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,nil)
		if #g>0 then
			Duel.HintSelection(g)
			for tc in aux.Next(g) do
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				-- 效果无效
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
				tc:RegisterEffect(e2)
				if tc:IsType(TYPE_TRAPMONSTER) then
					local e3=Effect.CreateEffect(c)
					e3:SetType(EFFECT_TYPE_SINGLE)
					e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
					e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
					tc:RegisterEffect(e3)
				end
			end
		end
	end
end

-- 连锁结束时返回场上
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		Duel.ReturnToField(tc)
	end
	g:DeleteGroup()
	e:Reset()
end