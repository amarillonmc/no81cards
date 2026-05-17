--爱丽丝的手提箱
local s,id,o=GetID()

local CODE_ALICE = 6100440

function s.initial_effect(c)
	-- 声明记述卡名
	aux.AddCodeList(c,CODE_ALICE)

	-- 魔法卡发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	-- ①：卡的效果发动的场合
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)

	-- ②：被回合玩家送去墓地的场合
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end

-- === 效果① ===
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	-- 防止此卡在刚发动作为永续魔法的瞬间，诱发自身的这个效果（造成不必要的自我连锁）
	return re:GetHandler()~=e:GetHandler()
end

function s.thfilter(c)
	return aux.IsCodeListed(c,CODE_ALICE) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK+LOCATION_GRAVE)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	-- 【核心机制：获取真实视角的“回合玩家”】
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446) ~= 0 then
		turn_p = 1 - turn_p
		Duel.ResetFlagEffect(tp, 6100446)
		Duel.Hint(HINT_CARD,0,6100446)
	end
	
	local opp = 1 - turn_p
	
	-- 发动玩家从自己卡组选2张符合条件的卡
	Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_OPERATECARD)
	local g = Duel.SelectMatchingCard(tp, s.thfilter, tp, LOCATION_DECK+LOCATION_GRAVE, 0, 2, 2, nil)
	
	if #g == 2 then
		-- 回合玩家选那之内的1张加入自身手卡
		Duel.Hint(HINT_SELECTMSG, turn_p, HINTMSG_ATOHAND)
		local sg1 = g:Select(turn_p, 1, 1, nil)
		local sg2 = g - sg1
		
		-- 另1张加入以那玩家来看的对方手卡
		Duel.SendtoHand(sg1, turn_p, REASON_EFFECT)
		Duel.SendtoHand(sg2, opp, REASON_EFFECT)
		
		-- 双方确认对应获得的卡
		if #sg1 > 0 then Duel.ConfirmCards(1-turn_p, sg1) end
		if #sg2 > 0 then Duel.ConfirmCards(1-opp, sg2) end
	end
end

-- === 效果② ===
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	-- 这张卡被回合玩家送去墓地的场合 (诱发条件的判断不翻转)
	return rp == Duel.GetTurnPlayer()
end

function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end

function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		-- 这张卡在自己场上表侧表示放置
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end