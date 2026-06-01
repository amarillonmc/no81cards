--暗渡陈仓
local s,id=GetID()
function s.initial_effect(c)
	-- 这个卡名的卡在1回合只能发动1张。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,2))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
  Duel.AddCustomActivityCounter(id,ACTIVITY_CHAIN,s.chainfilter)
end

---------------- 全局检测逻辑 ----------------
function s.chainfilter(re,tp,cid)
	local ph=Duel.GetCurrentPhase()
	return not re:IsActiveType(TYPE_MONSTER) 
end

---------------- ①效果主逻辑 ----------------
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(id,1-tp,ACTIVITY_CHAIN)~=0
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
  -- 弹出两个效果供玩家选择
  local op=Duel.SelectOption(tp,aux.Stringid(id,0),aux.Stringid(id,1))
  e:SetLabel(op)
  Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.thlimit(e,c)
	-- 判定区域为卡组
	return c:IsLocation(LOCATION_DECK)
end

function s.splimit(e,c)
	-- 判定区域为手卡
	return c:IsLocation(LOCATION_HAND)
end

function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	-- 先处理抽1张
	if Duel.Draw(p,d,REASON_EFFECT)>0 then
		if op==0 then
			-- ● 这个回合，对方不能从卡组把卡加入手卡 (封检索 + 封抽卡)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_CANNOT_TO_HAND)
			e1:SetTargetRange(0,1) -- 影响对象：对方(1)
			e1:SetTarget(s.thlimit)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			-- 底层补充：严谨封锁抽卡
			local e2=Effect.CreateEffect(c)
						e2:SetType(EFFECT_TYPE_FIELD)
						e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
						e2:SetCode(EFFECT_CANNOT_DRAW)
						e2:SetReset(RESET_PHASE+PHASE_END)
						e2:SetTargetRange(0,1)
						Duel.RegisterEffect(e2,tp)
		else
			-- ● 这个回合，对方不能从手卡把怪兽特殊召唤。
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
			e3:SetTargetRange(0,1) -- 影响对象：对方(1)
			e3:SetTarget(s.splimit)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end