--夜空☆魔女-星忆的巡礼者
local s,id,o=GetID()
function s.initial_effect(c)
	--同调召唤
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)

	-- 全局监听：本回合自己是否从手卡发动过魔法·陷阱卡
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	-- ①：回合玩家对应的效果适用
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.ef1cost)
	e1:SetTarget(s.ef1tg)
	e1:SetOperation(s.ef1op)
	c:RegisterEffect(e1)

	-- ②：取对象弹回手卡 (起动)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.thcon1)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	
	-- ②：取对象弹回手卡 (诱发即时 / 满足条件时)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCondition(s.thcon2)
	c:RegisterEffect(e3)
end

-- === 全局监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rc = re:GetHandler()
	-- 判定：发动者是谁、是否为卡片发动、是否从手卡发动、是否为魔陷
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsStatus(STATUS_ACT_FROM_HAND) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		Duel.RegisterFlagEffect(rp, id+100, RESET_PHASE+PHASE_END, 0, 1)
	end
end

-- === 效果① ===
function s.ef1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end

function s.ef1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local turn_p = Duel.GetTurnPlayer()
	if chk==0 then
		if turn_p == tp then
			local g = Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)
			return g:GetClassCount(Card.GetCode) >= 3 and Duel.IsPlayerCanDraw(tp,1)
		else
			return true -- 对方回合只下发权限，恒为真
		end
	end
	if turn_p == tp then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end

function s.ef1op(e,tp,eg,ep,ev,re,r,rp)
	local turn_p = Duel.GetTurnPlayer()
	if turn_p == tp then
		-- ●自己：自己墓地3张卡名不同的卡用喜欢的顺序回到卡组下面，自己抽1张。
		local g = Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,nil)
		if g:GetClassCount(Card.GetCode) >= 3 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg = g:SelectSubGroup(tp,aux.dncheck,false,3,3)
			if #sg == 3 then
				Duel.HintSelection(sg)
				Duel.SendtoDeck(sg,nil,SEQ_DECKTOP,REASON_EFFECT)
			local ct=Duel.GetOperatedGroup():FilterCount(Card.IsLocation,nil,LOCATION_DECK)
			if ct>0 then Duel.SortDecktop(tp,tp,ct)
					for i=1,ct do
					local mg=Duel.GetDecktopGroup(tp,1)
					Duel.MoveSequence(mg:GetFirst(),SEQ_DECKBOTTOM)
		end
					Duel.BreakEffect()
					Duel.Draw(tp,1,REASON_EFFECT)
			end
			end
		end
	else
		-- ●对方：这个回合只有1次，自己可以连锁对方发动的效果从手卡把速攻魔法·陷阱卡发动。
		Duel.RegisterFlagEffect(tp, id, RESET_PHASE+PHASE_END, 0, 1)
		
		-- 仅在第一次结算赋予光环（防止重复复读）
		if Duel.GetFlagEffect(tp, id) == 1 then
			local c = e:GetHandler()
			-- 速攻魔法允许手发
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
			e1:SetTargetRange(LOCATION_HAND,0)
			e1:SetCondition(s.handactcon)
			e1:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e1,tp)
			
			-- 陷阱允许手发
			local e2=e1:Clone()
			e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
			Duel.RegisterEffect(e2,tp)
			
			-- 监听器：一旦成功这么做了，就销毁这个权限
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_CHAINING)
			e3:SetOperation(s.handactconsume)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
		end
	end
end

-- 手卡发动许可判定：必须是有特权标记，且当前正在连锁对方的效果
function s.handactcon(e,c)
	local tp = e:GetHandlerPlayer()
	if Duel.GetFlagEffect(tp, id) == 0 then return false end
	local chn = Duel.GetCurrentChain()
	if chn == 0 then return false end
	local p = Duel.GetChainInfo(chn, CHAININFO_TRIGGERING_PLAYER)
	return p == 1 - tp
end

-- 手卡发动权限消耗判定：成功激活时扣除特权标记
function s.handactconsume(e,tp,eg,ep,ev,re,r,rp)
	if ep == tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local rc = re:GetHandler()
		local is_qp = rc:IsType(TYPE_SPELL) and rc:IsType(TYPE_QUICKPLAY)
		local is_trap = rc:IsType(TYPE_TRAP)
		-- 检查：是否是由我方手卡拍出的速攻/陷阱
		if (is_qp or is_trap) and rc:IsStatus(STATUS_ACT_FROM_HAND) then
			local chn = Duel.GetCurrentChain()
			if chn > 1 then
				local p = Duel.GetChainInfo(chn - 1, CHAININFO_TRIGGERING_PLAYER)
				-- 检查：它是否连锁了对方发动的效果
				if p == 1 - tp and Duel.GetFlagEffect(tp, id) > 0 then
					Duel.ResetFlagEffect(tp, id) -- 消耗次数！
				end
			end
		end
	end
end

-- === 效果② ===
function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp, id+100) == 0
end
function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp, id+100) > 0
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToHand() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end