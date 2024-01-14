--Kamipro 「约束的守护者」欧克
function c50214115.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,3,nil,nil)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetCondition(c50214115.imcon)
	e1:SetValue(c50214115.efilter)
	c:RegisterEffect(e1)
	--gain ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(c50214115.atkval)
	c:RegisterEffect(e2)
	--extra remove
	local e31=Effect.CreateEffect(c)
	e31:SetDescription(aux.Stringid(50214115,2))
	e31:SetCategory(CATEGORY_REMOVE)
	e31:SetType(EFFECT_TYPE_IGNITION)
	e31:SetRange(LOCATION_MZONE)
	e31:SetCountLimit(1,50214115)
	e31:SetCost(c50214115.ercost)
	e31:SetTarget(c50214115.ertg)
	e31:SetOperation(c50214115.erop)
	c:RegisterEffect(e31)
	--to deck
	local e32=Effect.CreateEffect(c)
	e32:SetDescription(aux.Stringid(50214115,3))
	e32:SetCategory(CATEGORY_TODECK)
	e32:SetType(EFFECT_TYPE_IGNITION)
	e32:SetRange(LOCATION_MZONE)
	e32:SetCountLimit(1,50214116)
	e32:SetCost(c50214115.tdcost)
	e32:SetTarget(c50214115.tdtg)
	e32:SetOperation(c50214115.tdop)
	c:RegisterEffect(e32)
	--handes
	local e33=Effect.CreateEffect(c)
	e33:SetDescription(aux.Stringid(50214115,4))
	e33:SetCategory(CATEGORY_HANDES)
	e33:SetType(EFFECT_TYPE_IGNITION)
	e33:SetRange(LOCATION_MZONE)
	e33:SetCountLimit(1,50214117)
	e33:SetCost(c50214115.hdcost)
	e33:SetTarget(c50214115.hdtg)
	e33:SetOperation(c50214115.hdop)
	c:RegisterEffect(e33)
	--half
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c50214115.hfcon)
	e4:SetOperation(c50214115.hfop)
	c:RegisterEffect(e4)
end
function c50214115.imcon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c50214115.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c50214115.atkval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)
	return g:GetClassCount(Card.GetAttribute)*300
end
function c50214115.rfilter1(c)
	return c:IsSetCard(0xcbf) and c:IsAttribute(ATTRIBUTE_FIRE+ATTRIBUTE_WATER) and c:IsAbleToRemoveAsCost()
end
function c50214115.ercost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsAttribute,nil,ATTRIBUTE_FIRE+ATTRIBUTE_WATER)
	local b1=og:GetCount()>0
	local b2=Duel.IsExistingMatchingCard(c50214115.rfilter1,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(50214115,0)},{b2,aux.Stringid(50214115,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local g=og:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c50214115.rfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c50214115.ertg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_EXTRA)
end
function c50214115.erop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=g:FilterSelect(tp,Card.IsAbleToRemove,1,1,nil)
	Duel.Remove(tg,POS_FACEDOWN,REASON_EFFECT)
	Duel.ShuffleExtra(1-tp)
end
function c50214115.rfilter2(c)
	return c:IsSetCard(0xcbf) and c:IsAttribute(ATTRIBUTE_WIND+ATTRIBUTE_EARTH) and c:IsAbleToRemoveAsCost()
end
function c50214115.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsAttribute,nil,ATTRIBUTE_WIND+ATTRIBUTE_EARTH)
	local b1=og:GetCount()>0
	local b2=Duel.IsExistingMatchingCard(c50214115.rfilter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(50214115,0)},{b2,aux.Stringid(50214115,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local g=og:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c50214115.rfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c50214115.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function c50214115.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
	if sg:GetCount()>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
	end
end
function c50214115.rfilter3(c)
	return c:IsSetCard(0xcbf) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToRemoveAsCost()
end
function c50214115.hdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup():Filter(Card.IsAttribute,nil,ATTRIBUTE_LIGHT+ATTRIBUTE_DARK)
	local b1=og:GetCount()>0
	local b2=Duel.IsExistingMatchingCard(c50214115.rfilter3,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(50214115,0)},{b2,aux.Stringid(50214115,1)})
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVEXYZ)
		local g=og:Select(tp,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c50214115.rfilter3,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_COST)
	end
end
function c50214115.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,1-tp,1)
end
function c50214115.hdop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c50214115.hfcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_ONFIELD)
		and c:IsPreviousControler(tp) and rp==1-tp
end
function c50214115.hfop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(1-tp,math.ceil(Duel.GetLP(1-tp)/2))
end