--魁杓七圣-禄存天玑
-- 魁杓七圣-禄存天玑
local s,id=GetID()

function s.initial_effect(c)
	-- ①：自己·对方的战斗阶段开始时公开手卡，并赋予本家战阶封锁效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.pubcon)
	e1:SetOperation(s.pubop)
	c:RegisterEffect(e1)

	-- ②：场上的怪兽被战斗破坏时特召、检索（公开状态可附加炸卡）
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id+10000)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
end

-- ==================== ①效果逻辑：手卡公开与战阶封锁 ====================
function s.pubcon(e,tp,eg,ep,ev,re,r,rp)
	-- 只有在没有被公开的情况下才能发动
	return not e:GetHandler():IsPublic()
end
function s.pubop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	
	-- 1. 将这张卡变为公开状态直到回合结束
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	
	-- 贴个标记以防和因其他效果被公开的情况混淆
	c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	
	-- 2. 赋予“对方不能发动效果”的光环
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1) -- 影响对方玩家
	e2:SetCondition(s.actcon)
	e2:SetValue(1) -- 1代表所有魔法·陷阱·怪兽的效果
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function s.actcon(e)
	local c=e:GetHandler()
	-- 前提：这张卡必须还在手卡，且保持公开状态，且是通过①效果公开的
	if not (c:IsLocation(LOCATION_HAND) and c:IsPublic() and c:GetFlagEffect(id)>0) then return false end
	
	-- 判断：是否有「魁杓七圣」怪兽正在进行战斗
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and a:IsControler(tp) and a:IsSetCard(0x3328))
		or (d and d:IsControler(tp) and d:IsSetCard(0x3328))
end

-- ==================== ②效果逻辑：特召与检索 ====================
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	-- EVENT_BATTLE_DESTROYED 这个时点本身就代表有场上的怪兽被战斗破坏
	return true
end
function s.thfilter(c)
	return c:IsSetCard(0x3328) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	
	-- 【关键点】：在确认发动的瞬间检查这张卡是否公开，并存入Label，防止后续状态变化丢失信息
	if c:IsPublic() then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
	
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	-- 破坏对方卡片是选发效果，不在 Target 里硬性规定
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	-- 步骤1：特召自身
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		-- 步骤2：检索卡片
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		
		-- 步骤3：判断发动时是否公开，如果是，则可选择炸卡
		if e:GetLabel()==1 then
			local dg=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
			if #dg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect() -- 插入效果断点（表示动作是先后发生）
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local sg=dg:Select(tp,1,1,nil)
				Duel.HintSelection(sg)
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end