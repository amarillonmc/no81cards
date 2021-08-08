--距离同步完成剩余251秒
function c60000117.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c60000117.target)
	e1:SetOperation(c60000117.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,60000117)
	e2:SetCost(c60000117.spcost)
	e2:SetTarget(c60000117.sptg)
	e2:SetOperation(c60000117.spop)
	c:RegisterEffect(e2)	
end
function c60000117.filter(c)
	return c:IsSetCard(0x56a9) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c60000117.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000117.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c60000117.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c60000117.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c60000117.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	Duel.ConfirmCards(1-tp,g)
	if not Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_DECK,0,1,nil,0x56a9) then return true end
end
--「 No Game No Life」 怪 兽
function c60000117.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x36a0)
end
-- 场 上 有 所 述 怪 兽
function c60000117.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c60000117.filter1,tp,LOCATION_MZONE,0,1,nil) end
end
-- 可 以 被 效 果 影 响 的「 No Game No Life」 怪 兽
function c60000117.filter2(c,e)
	return c:IsFaceup() and c:IsSetCard(0x36a0) and not c:IsImmuneToEffect(e)
end
-- 自 己 怪 兽 区 域 有 所 述 怪 兽 ,加 攻
function c60000117.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c60000117.filter2,tp,LOCATION_MZONE,0,nil,e)
	local c=e:GetHandler()
	local tc=sg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1000)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end











