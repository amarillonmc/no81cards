--外星人先锋
--外星人先锋
local s,id=GetID()
function s.initial_effect(c)
	--效果1：丢弃放置指示物并检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.e1cost)
	e1:SetTarget(s.e1tg)
	e1:SetOperation(s.e1op)
	c:RegisterEffect(e1)
	
	--效果2：回到手卡
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)
end
c98920905.counter_add_list={0x100e}
-- ==================== 效果1 ====================
function s.e1cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end

function s.thfilter(c)
	-- 0xc是「外星」字段，并且排除同名卡
	return (c:IsSetCard(0xc) or aux.IsCounterAdded(c,0x100e) or c:IsCode(59258334,99342953)) and not c:IsCode(id) and c:IsAbleToHand()
end

function s.cfilter(c)
	-- 0x100e是A指示物
	return c:IsFaceup() and c:IsCanAddCounter(0x100e,1)
end

function s.e1tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc) end
	if chk==0 then 
		return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x100e)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.e1op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	-- 给目标怪兽放置1个A指示物
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:AddCounter(0x100e,1) then
		-- 那之后，检索1张卡
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

-- ==================== 效果2 ====================
function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
