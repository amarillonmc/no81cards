local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xae6d),s.matfilter,true)
	  local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.chcon)
	e1:SetTarget(s.chtg)
	e1:SetOperation(s.chop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e2:SetTarget(s.target)
	e2:SetOperation(s.operation)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,id+o*2)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e3:SetTarget(s.target1)
	e3:SetOperation(s.operation1)
	c:RegisterEffect(e3)
end
function s.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return 
Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,nil,tp) and e:GetHandler():IsAbleToExtra() end
end
function s.operation1(e,tp,eg,ep,ev,re,r,rp)
local c=e:GetHandler()
if SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and  c:IsLocation(LOCATION_EXTRA) then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tc=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_ONFIELD,0,1,1,nil,tp):GetFirst()
	if tc  then Duel.SendtoGrave(tc,REASON_EFFECT) 
	Duel.ShuffleDeck(tp)
	end
end
end
function s.filter(c,tp)
	return  c:IsType(TYPE_CONTINUOUS)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.filter(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function s.matfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return  re:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function s.chfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_CONTINUOUS)
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.chfilter,tp,LOCATION_ONFIELD,0,1,nil,REASON_EFFECT) end
end
function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,s.repop)
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(1-tp,s.chfilter,1-tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g~=0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end