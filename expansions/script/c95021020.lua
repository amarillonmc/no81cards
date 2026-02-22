--源能特工 夜露
local s, id = GetID()
s.source_set = 0x3962  -- 源能特工字段
s.token_id = 95021025  -- 夜露衍生物

function s.initial_effect(c)
	-- 效果①：自己主要阶段2从手卡特殊召唤（规则效果）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)

	-- 效果②：展示自身，召衍生物，结束阶段处理
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+1)  -- 与③共享
	e2:SetCost(s.cost2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)

	-- 效果③：展示自身，召衍生物，赋予离场效果和自毁
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_HAND)
	e3:SetCountLimit(1,id+1)  -- 与②共享
	e3:SetCost(s.cost3)
	e3:SetTarget(s.tg3)
	e3:SetOperation(s.op3)
	c:RegisterEffect(e3)

	-- 效果④：除外自身直到回合结束时，确认手卡，检索
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_REMOVE+CATEGORY_HANDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,id+2+EFFECT_COUNT_CODE_DUEL)  -- 决斗中一次
	e4:SetCost(s.cost4)
	e4:SetTarget(s.tg4)
	e4:SetOperation(s.op4)
	c:RegisterEffect(e4)
end

-- 效果①条件
function s.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 效果②代价：展示手卡这张卡
function s.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND) end
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
end

-- 效果②目标：检查是否有空位召衍生物
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,3,1-tp,LOCATION_ONFIELD)
end

-- 效果②操作
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	-- 特殊召唤衍生物
	local token=Duel.CreateToken(tp,s.token_id)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	-- 注册结束阶段效果
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(s.endcon2)
	e1:SetOperation(s.endop2)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetLabelObject(c)  -- 记录这张卡
	Duel.RegisterEffect(e1,tp)
end

-- 结束阶段条件：自己场上有夜露衍生物
function s.endcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_MZONE,0,1,nil,s.token_id)
end

-- 结束阶段操作
function s.endop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	-- 破坏自己场上1个夜露衍生物
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_MZONE,0,nil,s.token_id)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
		
		if c:IsLocation(LOCATION_HAND) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		-- 选对方场上3张卡破坏
			local oppg=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
			if #oppg>0 then
				local dg=oppg:Select(tp,1,3,nil)
				Duel.Destroy(dg,REASON_EFFECT)
			end
		end
	end
end
-- 效果③代价：展示手卡这张卡
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsLocation(LOCATION_HAND) end
	Duel.ConfirmCards(1-tp,Group.FromCards(c))
end

-- 效果③目标
function s.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end

-- 效果③操作
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local token=Duel.CreateToken(tp,s.token_id)
	if Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)==0 then return end

	-- 全局效果：衍生物因对方效果离场时，炸对方全场
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)  -- 衍生物离场时自动重置
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local token=e:GetLabelObject()
		return eg:IsContains(token) and rp==1-tp and re and re:GetOwnerPlayer()==1-tp
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local g=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_ONFIELD,0,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end)
	e1:SetLabelObject(token)
	Duel.RegisterEffect(e1,tp)

	-- 全局效果：回合结束时破坏衍生物
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)  -- 衍生物离场时自动重置
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		local token=e:GetLabelObject()
		return token and token:IsLocation(LOCATION_MZONE) and token:IsControler(tp)
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local token=e:GetLabelObject()
		if token and token:IsLocation(LOCATION_MZONE) then
			Duel.Destroy(token,REASON_EFFECT)
		end
	end)
	e2:SetLabelObject(token)
	Duel.RegisterEffect(e2,tp)
end

-- 衍生物离场条件：对方效果导致
function s.tokenleavecon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re and re:GetOwnerPlayer()==1-tp
end

-- 衍生物离场操作：炸对方全场
function s.tokenleaveop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,1-tp,LOCATION_ONFIELD,0,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end

-- 衍生物自毁操作
function s.tokendestroyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

-- 效果④代价：除外自身直到回合结束时
function s.cost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		-- 注册返回效果
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		Duel.RegisterEffect(e1,tp)
	end
end

-- 结束阶段返回手卡
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	if c and c:IsLocation(LOCATION_REMOVED) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end

-- 效果④目标
function s.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)  -- 实际需要源能特工
	end
	-- 确认对方手卡
	Duel.ConfirmCards(tp,Duel.GetFieldGroup(1-tp,LOCATION_HAND,0))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果④操作
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	-- 从卡组检索源能特工怪兽
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsSetCard(s.source_set) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() end,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end