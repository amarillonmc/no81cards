--合辛的魔光陷阱
function c17337720.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TOHAND+CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(c17337720.activate)
	c:RegisterEffect(e0)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,17337720)
	e1:SetCondition(c17337720.setcon)
	e1:SetTarget(c17337720.settg)
	e1:SetOperation(c17337720.setop)
	c:RegisterEffect(e1)
end
function c17337720.cfilter(c,tp)
	return c:IsSetCard(0x3f51) and c:IsControler(tp) and c:IsFaceup()
end
function c17337720.desfilter(c,tp)
	return c17337720.cfilter(c,tp) or c:GetColumnGroup():IsExists(c17337720.cfilter,1,nil,tp)
end
function c17337720.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c17337720.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp)
	local b1=true
	local b2=#g>0
	local b3=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>Duel.GetFieldGroupCount(tp,0,LOCATION_HAND) and g:IsExists(Card.IsAbleToHand,1,nil,tp)
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(17337720,0)},
		{b2,aux.Stringid(17337720,1)},
		{b3,aux.Stringid(17337720,2)})
	if op==1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:Select(tp,1,1,nil)
	Duel.HintSelection(sg)
	if op==2 then Duel.Destroy(sg,REASON_EFFECT) else Duel.SendtoHand(sg,tp,REASON_EFFECT) end
end
function c17337720.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c17337720.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function c17337720.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
