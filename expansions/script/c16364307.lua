--X伙伴 建御雷兽
function c16364307.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xdc3),9,3,c16364307.ovfilter,aux.Stringid(16364307,3),3,c16364307.xyzop0)
	c:EnableReviveLimit()
	--toextra
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(16364307,1))
	e1:SetCategory(CATEGORY_TOEXTRA)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,16364307)
	e1:SetCondition(c16364307.tdcon)
	e1:SetTarget(c16364307.tdtg)
	e1:SetOperation(c16364307.tdop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16364307,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,16364307+1)
	e2:SetTarget(c16364307.destg)
	e2:SetOperation(c16364307.desop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c16364307.imcon)
	e3:SetValue(c16364307.efilter)
	c:RegisterEffect(e3)
end
function c16364307.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(7) and c:IsSetCard(0xdc3)
end
function c16364307.xyzop0(e,tp,chk,mc)
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	mc:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c16364307.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<=10
end
function c16364307.tdfilter(c)
	return c:IsSetCard(0xdc3) and c:IsType(TYPE_XYZ) and c:IsAbleToDeck()
end
function c16364307.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c16364307.tdfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c16364307.tdfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c16364307.tdfilter,tp,LOCATION_GRAVE,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c16364307.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.SendtoDeck(g,nil,1,REASON_EFFECT)
	end
end
function c16364307.desfilter(c,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and not c:IsSetCard(0xdc3)
end
function c16364307.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	if chk==0 then return Duel.IsExistingMatchingCard(c16364307.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,ct*100) end
	local g=Duel.GetMatchingGroup(c16364307.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ct*100)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16364307.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	local g=Duel.GetMatchingGroup(c16364307.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,ct*100)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c16364307.imcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsCode(16364065)
end
function c16364307.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
		and not e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end