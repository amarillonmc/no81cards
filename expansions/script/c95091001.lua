-- 神秘洞察
local s,id=GetID()
function s.initial_effect(c)
	-- ① 丢弃手卡发动效果
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DRAW+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end

-- 丢弃1张手卡作为cost
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local opp=1-tp
	
	-- 确认对方手卡和卡组
	local hand=Duel.GetFieldGroup(opp,LOCATION_HAND,0)
	local deck=Duel.GetFieldGroup(opp,LOCATION_DECK,0)
	
	if #hand>0 then
		Duel.ConfirmCards(tp,hand)
	end
	if #deck>0 then
		Duel.ConfirmCards(tp,deck)
	end
	
	-- 从对方卡组选1张卡加入对方手卡
	if #deck>0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,0))
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_DECK,1,1,nil)
		if #g>0 then
			local tc=g:GetFirst()
			Duel.SendtoHand(tc,opp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
			deck:RemoveCard(tc)
		end
	end
	
	-- 洗切对方卡组
	Duel.ShuffleDeck(opp)
	
	-- 自己抽1张卡
	Duel.Draw(tp,1,REASON_EFFECT)
end