--坦尼尔的红心扑克
local s,id,o=GetID()

local CODE_ALICE = 6100440

function s.initial_effect(c)
	-- 声明记述卡名
	aux.AddCodeList(c,CODE_ALICE)

	-- 全局监听：本回合发动的魔法·陷阱卡数量
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end

	-- 手卡发动许可
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)

	-- ①：互换控制权 + 代受战伤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)

	-- ②：墓地回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end

-- === 全局监听 ===
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then
		Duel.RegisterFlagEffect(0,id,RESET_PHASE+PHASE_END,0,1)
	end
end

-- === 手卡发动规则 ===
function s.handcostfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost()
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.handcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler())
end

function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if c:IsStatus(STATUS_ACT_FROM_HAND) then
			return Duel.IsExistingMatchingCard(s.handcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,c)
		end
		return true
	end
	if c:IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,s.handcostfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,c)
		Duel.SendtoGrave(g,REASON_COST)
	end
end

-- === 效果① ===
function s.swapfilter(c)
	return c:IsAbleToChangeControler() and aux.NegateMonsterFilter(c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.swapfilter,tp,LOCATION_MZONE,0,1,nil)
		   and Duel.IsExistingMatchingCard(s.swapfilter,tp,0,LOCATION_MZONE,1,nil)
	end
end

function s.alice_filter(c)
	return c:IsCode(CODE_ALICE) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(s.swapfilter,tp,0,LOCATION_MZONE,nil)
	local g2=Duel.GetMatchingGroup(s.swapfilter,1-tp,0,LOCATION_MZONE,nil)
	
	if #g1>0 and #g2>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local sg1=g1:Select(tp,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONTROL)
		local sg2=g2:Select(1-tp,1,1,nil)
		
		local tc1=sg1:GetFirst()
		local tc2=sg2:GetFirst()
		if tc1 and tc2 and Duel.SwapControl(tc1,tc2) then
			local c=e:GetHandler()
			for tc in aux.Next(Group.FromCards(tc1,tc2)) do
				-- 效果直到回合结束时无效
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
	end
	
	-- 判断是否应用爱丽丝的代受伤害效果
	if Duel.IsExistingMatchingCard(s.alice_filter, tp, LOCATION_MZONE+LOCATION_GRAVE, LOCATION_MZONE+LOCATION_GRAVE, 1, nil) then
		-- 【核心机制：获取真实视角的“回合玩家”】
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446) ~= 0 then
		turn_p = 1 - turn_p
		Duel.ResetFlagEffect(tp, 6100446)
		Duel.Hint(HINT_CARD,0,6100446)
	end
		
		local opp = 1 - turn_p
		
		-- 给予以回合玩家来看的对方“战伤反射”，原本由他承受的伤害会弹向回合玩家（代受）
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetTargetRange(1,0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3, opp)
	end
end

-- === 效果② ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,id)>=3
end

function s.thfilter(c,p)
	return c:IsControler(p) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	-- Target 阶段先预测而不剥夺翻转机会
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(0, 6100446) > 0 then turn_p = 1 - turn_p end
	
	if chk==0 then return e:GetHandler():IsAbleToHand()
		and Duel.IsExistingMatchingCard(s.thfilter,turn_p,LOCATION_ONFIELD,0,1,nil)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,0,LOCATION_GRAVE+LOCATION_ONFIELD)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 确定效果解析时的回合玩家视角
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(0, 6100446) > 0 then
		turn_p = 1 - turn_p
		Duel.ResetFlagEffect(0, 6100446)
		Duel.Hint(HINT_CARD,0,6100446)
	end
	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	-- 从场上选取1张由“当前视角下的回合玩家”控制的卡
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,turn_p)
	if #g>0 then
		Duel.HintSelection(g)
		g:AddCard(c)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end