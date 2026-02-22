--源能特工 零
local s, id = GetID()
s.tactics_set = 0x5962	  -- 「源能战术」陷阱卡字段代码
s.destroy_flag = id+1	-- 用于记录本回合是否有怪兽被破坏的标志ID

function s.initial_effect(c)
	-- 效果①：自己主要阶段2从手卡特殊召唤（规则效果）
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon1)
	c:RegisterEffect(e1)

	-- 效果②：丢弃1张手卡，从卡组把2张「源能战术」陷阱卡加入手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)

	-- 效果③：自己·对方回合，场上有怪兽被破坏的回合才能发动，确认对方手卡·卡组并选1张破坏
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_HANDES)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+2+EFFECT_COUNT_CODE_DUEL)  -- 决斗中一次
	e3:SetCondition(s.destroycon)
	e3:SetTarget(s.destroytg)
	e3:SetOperation(s.destroyop)
	c:RegisterEffect(e3)

	-- 全局检测怪兽破坏事件，用于效果③的条件
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROY)
		ge1:SetOperation(s.destroyregop)
		Duel.RegisterEffect(ge1,0)
	end
end

-- 效果①条件
function s.spcon1(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetCurrentPhase()==PHASE_MAIN2 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end

-- 效果②代价：丢弃1张手卡
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

-- 效果②检索过滤器：字段为「源能战术」的陷阱卡
function s.thfilter(c)
	return c:IsSetCard(s.tactics_set) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,2,2,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

-- 全局怪兽破坏记录
function s.destroyregop(e,tp,eg,ep,ev,re,r,rp)
	-- 当有怪兽被破坏时，为双方玩家设置一个标志（持续到回合结束）
	Duel.RegisterFlagEffect(0, s.destroy_flag, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 1)
	Duel.RegisterFlagEffect(1, s.destroy_flag, RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END, 0, 1)
end

-- 效果③发动条件：本回合有怪兽被破坏
function s.destroycon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp, s.destroy_flag) > 0
end
function s.destroytg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		-- 确保对方手卡或卡组至少有一张卡可以破坏
		return Duel.GetFieldGroupCount(1-tp, LOCATION_HAND+LOCATION_DECK, 0) > 0
	end
	-- 无特定操作信息，因为破坏数量取决于选择
end
function s.destroyop(e,tp,eg,ep,ev,re,r,rp)
	-- 确认对方手卡和卡组
	local opp=1-tp
	Duel.ConfirmCards(tp, Duel.GetFieldGroup(opp, LOCATION_HAND, 0))
	Duel.ConfirmDecktop(opp, Duel.GetFieldGroupCount(opp, LOCATION_DECK, 0))
	-- 获取所有可选的卡（手卡+卡组）
	local g=Duel.GetMatchingGroup(aux.TRUE, opp, LOCATION_HAND+LOCATION_DECK, 0, nil)
	if #g==0 then return end
	-- 让玩家选择一张卡
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,1,nil)
	if #sg>0 then
		Duel.SendtoGrave(sg, REASON_EFFECT)
	end
	-- 重新洗切卡组（如果选择了卡组的卡，会自动洗切？SendtoGrave会处理，但为了安全可以调用洗切）
	Duel.ShuffleDeck(opp)
end