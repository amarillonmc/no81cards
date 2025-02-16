--混沌从骑 埃刻
function c49811185.initial_effect(c)
	-- 效果①：属性变更
	-- 场上和墓地中，这张卡的属性也当作「暗」使用
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e1:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e1)

	-- 效果②：特殊召唤
	-- 自己额外卡组没有卡存在的场合，这张卡可以从手牌特殊召唤
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,49811185+EFFECT_COUNT_CODE_OATH)
	e2:SetCondition(c49811185.spcon)
	c:RegisterEffect(e2)

	-- 效果③：检索效果
	-- 这张卡召唤·特殊召唤的场合才能发动
	-- 从卡组把1只可以特殊召唤的攻击力2400以上而守备力1000的怪兽加入手卡
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,49811186)
	e3:SetTarget(c49811185.thtg)
	e3:SetOperation(c49811185.thop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end

-- 效果②：特殊召唤的条件
function c49811185.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end

-- 效果③：检索效果的目标
function c49811185.thfilter(c)
	return c:IsAttackAbove(2400) and c:IsDefense(1000) and c:IsAbleToHand() and c:IsSpecialSummonableCard()
end

-- 效果③：检索效果的目标设置
function c49811185.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49811185.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- 效果③：检索效果的操作
function c49811185.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c49811185.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end