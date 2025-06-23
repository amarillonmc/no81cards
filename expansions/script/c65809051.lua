-- 永续魔法卡：资源掠夺者
local s,id=GetID()
function s.initial_effect(c)
	-- 效果①：资源获取送墓+抢夺对方场卡
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(s.cost1)
	e1:SetTarget(s.tg1)
	e1:SetOperation(s.op1)
	c:RegisterEffect(e1)
	
	-- 效果②：除外时回收
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+1)
	e2:SetCondition(s.con2)
	e2:SetTarget(s.tg2)
	e2:SetOperation(s.op2)
	c:RegisterEffect(e2)
end

-- 效果①处理函数
function s.cfilter(c)
	return c:IsCode(65809001) 
end
function s.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function s.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,1-tp,LOCATION_ONFIELD)
end
function s.op1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,0,LOCATION_ONFIELD,1,1,nil)
	local dg=Duel.GetDecktopGroup(1-tp,1)
	if #g>0 and Duel.SendtoHand(g,tp,REASON_EFFECT)>0 and dg:GetFirst():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
			if #dg>0 then
				Duel.BreakEffect()
				Duel.SendtoHand(dg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,dg)
				Duel.ShuffleHand(tp)
				Duel.ShuffleDeck(1-tp)
			end
	end
end

-- 效果②处理函数
function s.con2filter(c,tp)
	return c:GetOwner()~=tp and c:GetControler()==tp
end
function s.con2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.con2filter,1,nil,tp)
end
function s.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end
