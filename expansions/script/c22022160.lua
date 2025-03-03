--人理之基 莫里亚蒂
function c22022160.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x2ff1),aux.FilterBoolFunction(Card.IsFusionSetCard,0x108),true)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x108))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--activate from hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xff1))
	e3:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e4)
	--neg
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22022160,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,22022160)
	e5:SetCondition(c22022160.negcon)
	e5:SetOperation(c22022160.negop)
	c:RegisterEffect(e5)
	--discard
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22022160,1))
	e6:SetCategory(CATEGORY_HANDES)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,22022161)
	e6:SetCondition(c22022160.descon)
	e6:SetTarget(c22022160.destg)
	e6:SetOperation(c22022160.desop)
	c:RegisterEffect(e6)
	--discard
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22022160,1))
	e7:SetCategory(CATEGORY_HANDES)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCountLimit(1,22022161)
	e7:SetCondition(c22022160.descon1)
	e7:SetCost(c22022160.erecost)
	e7:SetTarget(c22022160.destg)
	e7:SetOperation(c22022160.desop)
	c:RegisterEffect(e7)
end
function c22022160.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and e:GetHandler():GetColumnGroup():IsContains(re:GetHandler())
end
function c22022160.negop(e,tp,eg,ep,ev,re,r,rp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCondition(c22022160.discon)
		e1:SetOperation(c22022160.disop)
		Duel.RegisterEffect(e1,tp)
end
function c22022160.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainNegatable(ev) and e:GetHandler():GetFlagEffect(22050180)==0 and ep~=tp
end
function c22022160.disop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	e:GetHandler():RegisterFlagEffect(22050180,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
		e:Reset()
	end
end
function c22022160.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousControler(1-tp)
end
function c22022160.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22022160.cfilter,1,nil,tp)
end
function c22022160.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,0,0,1-tp,1)
end
function c22022160.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND,nil)
	if g:GetCount()==0 then return end
	local sg=g:RandomSelect(1-tp,1)
	Duel.SendtoGrave(sg,REASON_DISCARD+REASON_EFFECT)
end
function c22022160.descon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22022160.cfilter,1,nil,tp) and Duel.IsPlayerAffectedByEffect(tp,22020980)
end
function c22022160.erecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_CARD,0,22020980)
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end