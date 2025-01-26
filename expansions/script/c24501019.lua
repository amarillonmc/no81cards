--神威骑士皇爆裂击
function c24501019.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,24501019)
	e1:SetCondition(c24501019.condition)
	e1:SetTarget(c24501019.target)
	e1:SetOperation(c24501019.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	--e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,24501020)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c24501019.destg)
	e2:SetOperation(c24501019.desop)
	c:RegisterEffect(e2)
end
function c24501019.chkfilter(c)
	return c:IsCode(24501025) and c:IsFaceup()
end
function c24501019.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c24501019.chkfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev) and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c24501019.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c24501019.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c24501019.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD+LOCATION_HAND)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local op=Duel.AnnounceType(tp)
	e:SetLabel(op)
end
function c24501019.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD+LOCATION_HAND)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	local dg=g:Clone()
	if e:GetLabel()==0 then
		dg=g:Filter(Card.IsType,nil,TYPE_MONSTER)
	elseif e:GetLabel()==1 then
		dg=g:Filter(Card.IsType,nil,TYPE_SPELL)
	else
		dg=g:Filter(Card.IsType,nil,TYPE_TRAP)
	end
	if #dg==0 then return end
	Duel.Destroy(dg,REASON_EFFECT)
end
function c24501019.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x501)
end
