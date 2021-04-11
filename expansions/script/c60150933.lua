--幻致的白热战
function c60150933.initial_effect(c)
	--Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCode(EVENT_BE_BATTLE_TARGET)
    e1:SetCondition(c60150933.condition)
	e1:SetCost(c60150933.cost)
    e1:SetTarget(c60150933.target)
    e1:SetOperation(c60150933.activate)
    c:RegisterEffect(e1)
	--Activate2
    local e2=Effect.CreateEffect(c)
    e2:SetCategory(CATEGORY_TODECK)
    e2:SetType(EFFECT_TYPE_ACTIVATE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCode(EVENT_CHAINING)
    e2:SetCondition(c60150933.condition2)
	e2:SetCost(c60150933.cost)
    e2:SetTarget(c60150933.target2)
    e2:SetOperation(c60150933.activate2)
    c:RegisterEffect(e2)
end
function c60150933.condition(e,tp,eg,ep,ev,re,r,rp)
    local tc=eg:GetFirst()
    return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x6b23)
end
function c60150933.cfilter(c,tp)
    return c:IsSetCard(0x6b23) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function c60150933.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c60150933.cfilter,tp,LOCATION_HAND,LOCATION_DECK,1,nil,tp) end
	local cg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
    Duel.ConfirmCards(tp,cg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c60150933.cfilter,tp,LOCATION_HAND,LOCATION_DECK,1,1,nil,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c60150933.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    local tg=Duel.GetAttacker()
    if chkc then return chkc==tg end
    if chk==0 then return tg:IsOnField() and tg:IsCanBeEffectTarget(e) and (tg:IsAbleToDeck() or tg:IsAbleToExtra())
        and Duel.IsExistingMatchingCard(c60150933.filter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
end
function c60150933.filter(c)
    return c:IsFaceup() and c:IsSetCard(0x6b23)
end
function c60150933.activate(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateAttack()
    local tc=Duel.GetFirstTarget()
    if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if Duel.SendtoDeck(tc,2,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(1-tp)
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,c60150933.filter,tp,LOCATION_MZONE,0,1,1,nil)
			local ac=g:GetFirst()
			if ac then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(tc:GetAttack())
				e1:SetReset(RESET_EVENT+0x1fe0000)
				ac:RegisterEffect(e1)
			end
		end
    end
end
function c60150933.filter2(c)
    return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsSetCard(0x6b23)
end
function c60150933.condition2(e,tp,eg,ep,ev,re,r,rp)
    if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
    if not re:IsActiveType(TYPE_MONSTER) then return false end
    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    return tg and tg:IsExists(c60150933.filter2,1,nil) and Duel.IsChainNegatable(ev)
end
function c60150933.target2(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
    if (re:GetHandler():IsAbleToDeck() or re:GetHandler():IsAbleToExtra()) and re:GetHandler():IsRelateToEffect(re) then
        Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
    end
end
function c60150933.activate2(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateActivation(ev)
        if Duel.SendtoDeck(eg,2,nil,REASON_EFFECT)~=0 then
			Duel.ShuffleDeck(1-tp)
			Duel.ShuffleDeck(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
			local g=Duel.SelectMatchingCard(tp,c60150933.filter,tp,LOCATION_MZONE,0,1,1,nil)
			local ac=g:GetFirst()
			if g then
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(60150933,0))
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_IMMUNE_EFFECT)
				e1:SetValue(c60150933.efilter)
				e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
				ac:RegisterEffect(e1)
			end
		end
end
function c60150933.efilter(e,re)
    return e:GetHandler()~=re:GetOwner()
end