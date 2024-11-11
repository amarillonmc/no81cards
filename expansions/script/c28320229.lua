--六出花的童话乐土
function c28320229.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--Activate from grave
	local e5=e0:Clone()
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(c28320229.cost)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_ACTIVATE_COST)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c28320229.gatg)
	e6:SetOperation(c28320229.gaop)
	c:RegisterEffect(e6)
	--field effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetRange(LOCATION_FZONE)
	e1:SetValue(c28320229.effectfilter)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DEFENSE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsAttribute,ATTRIBUTE_EARTH))
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--to deck
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c28320229.tdtg)
	e3:SetOperation(c28320229.tdop)
	c:RegisterEffect(e3)
	--recover
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(28320229,0))
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_RECOVER)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCondition(c28320229.recon)
	e4:SetTarget(c28320229.retg)
	e4:SetOperation(c28320229.reop)
	c:RegisterEffect(e4)
end
function c28320229.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetLP(tp,Duel.GetLP(tp)-2000)
end
function c28320229.gatg(e,te,tp)
	e:SetLabelObject(te)
	return te:GetHandler()==e:GetHandler()
end
function c28320229.gaop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_FZONE,POS_FACEUP,false)
	e:GetHandler():CreateEffectRelation(te)
	local c=e:GetHandler()
	local ev0=Duel.GetCurrentChain()+1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==ev0 end)
	e1:SetOperation(c28320229.rsop)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAIN_NEGATED)
	Duel.RegisterEffect(e2,tp)
end
function c28320229.rsop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if e:GetCode()==EVENT_CHAIN_SOLVED and rc:IsRelateToEffect(re) then
		rc:SetStatus(STATUS_EFFECT_ENABLED,true)
	end
	if e:GetCode()==EVENT_CHAIN_NEGATED and rc:IsRelateToEffect(re) and not (rc:IsOnField() and rc:IsFacedown()) then
		rc:SetStatus(STATUS_ACTIVATE_DISABLED,true)
	end
end
function c28320229.effectfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	return p==tp and te:GetHandler():IsAttribute(ATTRIBUTE_EARTH) and te:IsActiveType(TYPE_MONSTER)
end
function c28320229.tdfilter(c)
	return c:IsSetCard(0x287) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c28320229.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28320229.tdfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c28320229.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c28320229.tdfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,99,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	local og=Duel.GetOperatedGroup()
	local ct=og:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	Duel.Recover(tp,ct*800,REASON_EFFECT)
end
function c28320229.recon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c28320229.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1500)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,tp,1)
end
function c28320229.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1500,REASON_EFFECT)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT)
end
