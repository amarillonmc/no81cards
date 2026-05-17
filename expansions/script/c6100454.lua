--爱丽丝的冒险童话
local s,id,o=GetID()

local CODE_ALICE = 6100440

function s.initial_effect(c)
	-- 声明记述卡名
	aux.AddCodeList(c,CODE_ALICE)

	-- 手卡发动许可
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(s.handcon)
	c:RegisterEffect(e0)

	-- 陷阱卡发动 (发动时可选是否一并适用①效果)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0, TIMING_MAIN_END)
	e1:SetCost(s.cost)
	c:RegisterEffect(e1)

	-- ①：场上发动效果 (起动类诱发即时)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetHintTiming(0, TIMING_MAIN_END)
	e2:SetCondition(s.ef1con)
	e2:SetTarget(s.ef1tg)
	e2:SetOperation(s.ef1op)
	c:RegisterEffect(e2)

	-- ②：被回合玩家送去墓地的场合
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.tgcon)
	e3:SetTarget(s.tgtg)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)
end

-- === 手卡发动规则 ===
function s.handcostfilter(c)
	return aux.IsCodeListed(c,CODE_ALICE) and not c:IsPublic()
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(s.handcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
			return Duel.IsExistingMatchingCard(s.handcostfilter,tp,LOCATION_HAND,0,1,e:GetHandler())
		end
		return true
	end
	-- 从手卡发动，必须展示1张手卡符合条件的卡
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=Duel.SelectMatchingCard(tp,s.handcostfilter,tp,LOCATION_HAND,0,1,1,e:GetHandler())
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	end
end

-- === 效果① ===
function s.ef1con(e,tp,eg,ep,ev,re,r,rp)
	-- 自己·对方的主要阶段1次
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) and e:GetHandler():GetFlagEffect(id)==0
end
function s.alice_spfilter(c,e,tp)
	return aux.IsCodeListed(c,CODE_ALICE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.ef1tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.alice_spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	-- 记录当回合发动情况 (软一回合一次)
	e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	e:SetCategory(CATEGORY_SPECIAL_SUMMON)
end

function s.ef1op(e,tp,eg,ep,ev,re,r,rp)

	
	-- 【核心机制：获取真实视角的“回合玩家”】
	local turn_p = Duel.GetTurnPlayer()
	if Duel.GetFlagEffect(tp, 6100446) ~= 0 then
		turn_p = 1 - turn_p
		Duel.ResetFlagEffect(tp, 6100446)
		Duel.Hint(HINT_CARD,0,6100446)
	end
	
	local res = false
	local hg = Duel.GetMatchingGroup(Card.IsType, turn_p, LOCATION_HAND, 0, nil,TYPE_MONSTER)
	
	-- 回合玩家可以让手卡1只怪兽回到卡组让这个效果无效。
	if #hg > 0 and Duel.SelectYesNo(turn_p, aux.Stringid(id, 2)) then
		Duel.Hint(HINT_SELECTMSG, turn_p, HINTMSG_TODECK)
		local sg = hg:Select(turn_p, 1, 1, nil)
		if #sg > 0 then
		  Duel.ConfirmCards(0,sg)
			Duel.SendtoDeck(sg, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
			res = true
		end
	end
	
	-- 没回去的场合，从卡组把1只「破碎世界的死神 爱丽丝」特殊召唤。
	if not res then
		if Duel.GetLocationCount(tp, LOCATION_MZONE) > 0 then
			Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
			local g = Duel.SelectMatchingCard(tp, s.alice_spfilter, tp, LOCATION_DECK, 0, 1, 1, nil, e, tp)
			if #g > 0 then
				Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
			end
		end
	end
end

-- === 附带效果①处理的陷阱卡发动逻辑 ===
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=s.ef1con(e,tp,eg,ep,ev,re,r,rp) and s.ef1tg(e,tp,eg,ep,ev,re,r,rp,0)
	if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
		e:SetLabel(1)
		s.ef1tg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetLabel(0)
	end
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==1 then
		s.ef1op(e,tp,eg,ep,ev,re,r,rp)
	end
end

-- === 效果② ===
function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	-- 这张卡被回合玩家送去墓地的场合 (诱发条件的判断不翻转)
	return rp == Duel.GetTurnPlayer()
end
function s.tgfilter(c)
	return aux.IsCodeListed(c,CODE_ALICE) and c:IsAbleToDeck()
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.tgfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.tgfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,c)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,3,nil)
		-- 选回到卡组下面
		Duel.SendtoDeck(sg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
	end
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end