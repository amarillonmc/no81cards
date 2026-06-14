-- 自定义连接怪兽
local s,id=GetID()
function s.initial_effect(c)
	-- 连接召唤条件：包含连接怪兽的效果怪兽3只以上
   aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),3,99,s.lcheck)
	c:EnableReviveLimit()
	
	-- ①：这张卡连接召唤的自己·对方回合，让场上除这张卡外的全部怪兽直到这个连锁结束时除外才能发动。
	-- 这个回合，这张卡不受对方发动的效果影响，在同1次的战斗阶段中可以作2次攻击。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.ef1con)
	e1:SetCost(s.ef1cost)
	e1:SetOperation(s.ef1op)
	c:RegisterEffect(e1)
	
	-- ②：对方连锁自己的效果的发动把卡的效果发动时，让双方除外状态最多为这个效果发动时连锁数量的卡回到卡组·额外卡组才能发动。
	-- 这张卡的攻击力上升1000。
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.ef2con)
	e2:SetCost(s.ef2cost)
	e2:SetOperation(s.ef2op)
	c:RegisterEffect(e2)
end

-- ==================== 连接素材检查 ====================
function s.lcheck(g,lc)
	return g:IsExists(Card.IsLinkType,1,nil,TYPE_LINK)
end

-- ==================== 效果①逻辑 ====================
function s.ef1con(e,tp,eg,ep,ev,re,r,rp)
	-- 必须是这张卡连接召唤的那个回合
	local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end

function s.ef1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	-- 获取场上除这张卡以外的全部怪兽
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	
	if chk==0 then 
		-- 核心规则判定：
		-- 1. 至少要有1只其他怪兽
		-- 2. 所有怪兽都必须能被除外
		-- 3. 场上绝对不能有衍生物 (Token不能被用于临时除外的Cost)
		return #g>0 
			and g:FilterCount(Card.IsAbleToRemoveAsCost,nil)==#g 
			and not g:IsExists(Card.IsType,1,nil,TYPE_TOKEN) 
	end
	
	-- 全部作为COST除外
	if Duel.Remove(g,POS_FACEUP,REASON_COST+REASON_TEMPORARY)>0 then
		local og=g:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #og>0 then
			og:KeepAlive() 
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CHAIN_END)
			e1:SetReset(RESET_PHASE+PHASE_END)
			e1:SetLabelObject(og)
			e1:SetOperation(s.returnop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.returnop(e,tp,eg,ep,ev,re,r,rp)
	local og=e:GetLabelObject()
	if og then
		-- 【双重保险】：回场前再次确认这些卡还在除外区，防止期间被其他卡转移
		local sg=og:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if #sg>0 then
			for tc in aux.Next(sg) do
				Duel.ReturnToField(tc)
			end
		end
		og:DeleteGroup() -- 释放内存
	end
	e:Reset() -- 效果执行完毕后销毁该延迟效果
end
function s.ef1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	-- 不受对方发动的效果影响
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetValue(s.efilter)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	-- 可以作2次攻击 (增加1次额外攻击)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end

function s.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActivated()
end

-- ==================== 效果②逻辑 ====================
function s.ef2con(e,tp,eg,ep,ev,re,r,rp)
	-- 触发条件：对方 (ep==1-tp) 连锁发动效果，且上一个连锁是自己发动的 (ev-1 的 triggering player 是 tp)
	return rp==1-tp and ev>1 and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_PLAYER)==tp
end

function s.ef2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	-- 最多为这个效果发动时连锁数量。因为当前正准备发动，所以连锁数 = 当前存在的连锁 + 1
	local max_ct=Duel.GetCurrentChain()+1
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	-- 让玩家选择 1 到 max_ct 张除外的卡
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckOrExtraAsCost,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,max_ct,nil)
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end

function s.ef2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		-- 攻击力上升1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
	end
end