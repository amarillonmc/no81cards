-- 魔法卡：双重献祭
local s, id = GetID()

function s.initial_effect(c)
	
	-- 效果：解放怪兽并选择效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 定义字段
s.darkmoon_setcode = 0x696c
s.soul_setcode = 0x396c
function s.dfilter(c)
	return c:IsType(TYPE_MONSTER)
end
-- 代价：解放手卡或场上1只怪兽
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.IsExistingMatchingCard(s.dfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
	end
	local g=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil,TYPE_MONSTER)
	Duel.Release(g,REASON_COST)
end

-- 目标设定
function s.thfilter(c)
	return (c:IsSetCard(s.darkmoon_setcode) or c:IsSetCard(s.soul_setcode)) 
		and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
		local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
		return b1 or b2
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end

-- 效果处理
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	-- 检查可用的效果选项
	local b1=Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	
	if not (b1 or b2) then return end
	
	-- 让玩家选择效果
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(id,1),aux.Stringid(id,2))
	elseif b1 then
		op=0
	else
		op=1
	end
	
	if op==0 then
		-- 效果①：从卡组把1只「暗月」或「魂铸意志」怪兽加入手卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		-- 效果②：选场上1只怪兽直到回合结束效果无效化
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			if tc then
				Duel.NegateRelatedChain(tc,RESET_TURN_SET)
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(e2)
			end
		end
	end
end