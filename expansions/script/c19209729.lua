--愿众人幸福的莫比乌斯
function c19209729.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_FZONE+LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c19209729.indcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--attack up-other
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCode,19209728))--FilterBoolFunction
	e2:SetValue(c19209729.atkval)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(19209729,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c19209729.thtg)
	e3:SetOperation(c19209729.thop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,19209729)
	e4:SetCondition(c19209729.descon)
	e4:SetTarget(c19209729.destg)
	e4:SetOperation(c19209729.desop)
	c:RegisterEffect(e4)
end
function c19209729.cfilter(c)
	return c:IsOriginalSetCard(0xb53) and c:IsFaceup()
end
function c19209729.indcon(e)
	return Duel.IsExistingMatchingCard(c19209729.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c19209729.atkval(e,c)
	return Duel.GetFieldGroupCount(0,LOCATION_MZONE,LOCATION_MZONE)*900
end
function c19209729.gcheck(g)
	return aux.gffcheck(g,Card.IsAbleToHand,0,Card.IsAbleToDeck,0)
end
function c19209729.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xb53):Filter(Card.IsCanBeEffectTarget,nil,e)
	if chk==0 then return g:CheckSubGroup(c19209729.gcheck,2,2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local sg=g:SelectSubGroup(tp,c19209729.gcheck,false,2,2)
	Duel.SetTargetCard(sg)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,sg,1,tp,LOCATION_GRAVE)
end
function c19209729.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	g:Sub(tg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg:GetFirst())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c19209729.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_FZONE) and c:IsPreviousPosition(POS_FACEUP)
end
function c19209729.desfilter(c)
	return c:IsCode(19209728) and c:IsFaceup() and Duel.GetMatchingGroupCount(nil,0,LOCATION_MZONE,LOCATION_MZONE,c)>0
end
function c19209729.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c19209729.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c19209729.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=Duel.SelectTarget(tp,c19209729.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_MZONE,LOCATION_MZONE,sg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c19209729.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local exg=tc:IsRelateToChain() and Group.FromCards(tc) or Group.CreateGroup()
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_MZONE,LOCATION_MZONE,exg)
	Duel.Destroy(g,REASON_EFFECT)
end
