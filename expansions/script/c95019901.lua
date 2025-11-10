-- 怪兽卡：领域封锁者
local s, id = GetID()

function s.initial_effect(c)
	-- 不能通常召唤
	c:EnableReviveLimit()
	
	-- 不能通常召唤/特殊召唤的限制
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(0)
	c:RegisterEffect(e0)
	
	-- 效果①：特殊召唤规则（参考雷击坏兽）
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e1:SetTargetRange(POS_FACEUP_DEFENSE,1) -- 守备表示召唤到对方场上
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(s.regop)
	c:RegisterEffect(e11)
	
	-- 返回手卡效果
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.retcon)
	e2:SetOperation(s.retop)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(id,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,2)

	 --   e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	-- 效果②：封锁当前所在位置玩家的主要怪兽区域
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_DISABLE_FIELD)
	e3:SetValue(s.disval)
	c:RegisterEffect(e3)
	
	-- 效果③：支付2600基本分抽2张卡
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	--e4:SetCountLimit(1)
	e4:SetCost(s.drcost)
	e4:SetTarget(s.drtg)
	e4:SetOperation(s.drop)
	c:RegisterEffect(e4)
end



function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 记录特殊召唤时的回合数和当前控制者
	c:RegisterFlagEffect(1082946,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,0))
	c:SetTurnCounter(0)
end

-- 返回手卡条件
function s.retcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end

-- 返回手卡操作
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		Duel.SendtoHand(c,c:GetControler(),REASON_EFFECT)
		c:ResetFlagEffect(1082946)
	end
end
















-- 效果①：特殊召唤条件
function s.spfilter(c,tp)
	return c:IsReleasable(REASON_SPSUMMON) and Duel.GetMZoneCount(1-tp,c,tp)>0
end

function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.spfilter,tp,0,LOCATION_MZONE,1,nil,tp)
end

-- 效果①：特殊召唤目标选择
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,0,LOCATION_MZONE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end

-- 效果①：特殊召唤操作
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_SPSUMMON)
	local c=e:GetHandler()  
end





-- 效果②：封锁当前所在位置玩家的主要怪兽区域
function s.disval(e)
	local c=e:GetHandler()
	local p=c:GetControler() -- 当前控制者
	local owner=e:GetHandlerPlayer() -- 卡片持有者
	
	-- 判断先攻后手
	local is_first_player = (owner == 0) -- 如果持有者是玩家0，则是先攻玩家
	
	if is_first_player then
		-- 先攻玩家
		if p == owner then
			-- 怪兽在自己场上，封锁自己的主要怪兽区域
			return 0x1f -- 封锁自己主要怪兽区域（位0-4）
		else
			-- 怪兽在对方场上，封锁对方的主要怪兽区域
			return 0x1f0000 -- 封锁对方主要怪兽区域（位16-20）
		end
	else
		-- 后攻玩家
		if p == owner then
			-- 怪兽在自己场上，封锁对方的主要怪兽区域
			return 0x1f0000 -- 封锁对方主要怪兽区域（位16-20）
		else
			-- 怪兽在对方场上，封锁自己的主要怪兽区域
			return 0x1f -- 封锁自己主要怪兽区域（位0-4）
		end
	end
end

-- 效果③：支付2600基本分作为代价
function s.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2600) end
	Duel.PayLPCost(tp,2600)
end

-- 效果③：抽卡目标设定
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end

-- 效果③：抽卡操作
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end