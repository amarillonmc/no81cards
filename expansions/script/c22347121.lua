--蕾蕾宗忍法·灭杀之拳
function c22347121.initial_effect(c)
	--①：让自己场上1只「蕾宗忍者」怪兽回到手卡，以对方场上2张卡为对象才能发动。那些卡破坏。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22347121,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c22347121.cost)
	e1:SetTarget(c22347121.target)
	e1:SetOperation(c22347121.activate)
	c:RegisterEffect(e1)
	--②：自己场上有「蕾宗忍者」怪兽存在，对方把怪兽的效果发动时，把墓地的这张卡除外才能发动。那个发动无效并破坏。
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,22347121)
	e2:SetCondition(c22347121.discon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22347121.distg)
	e2:SetOperation(c22347121.disop)
	c:RegisterEffect(e2)
end
function c22347121.cfilter(c)
	return c:IsFaceup() and c:IsAbleToHandAsCost() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5705)
end
function c22347121.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingMatchingCard(c22347121.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c22347121.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,REASON_COST)
end
function c22347121.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(aux.TURE,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TURE,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c22347121.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(tg,REASON_EFFECT)
end
function c22347121.filter(c)
	return c:IsSetCard(0x5705) and c:IsFaceup()
end
function c22347121.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainDisablable(ev) and re:IsActiveType(TYPE_MONSTER)
		and Duel.IsExistingMatchingCard(c22347121.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c22347121.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c22347121.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end