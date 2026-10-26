--HARROW
function c19209584.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(19209584,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c19209584.handcon)
	c:RegisterEffect(e0)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,19209584)
	e1:SetCondition(c19209584.condition)
	e1:SetTarget(c19209584.target)
	e1:SetOperation(c19209584.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(19209584,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,19209584+1)
	e2:SetCondition(c19209584.thcon)
	e2:SetTarget(c19209584.thtg)
	e2:SetOperation(c19209584.thop)
	c:RegisterEffect(e2)
	--global
	if not c19209584.global_check then
		c19209584.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c19209584.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c19209584.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
end
function c19209584.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(1-tp,19209584)==0 then return false end
	if tp==ep or not re:IsActiveType(TYPE_MONSTER) or not Duel.IsChainDisablable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc>0
end
function c19209584.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c19209584.tgfilter(c,code)
	return c:IsOriginalCodeRule(code) and c:IsAbleToGrave()
end
function c19209584.activate(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	local p=rc:GetOwner()
	local code=rc:GetOriginalCode()
	local g=Duel.GetMatchingGroup(c19209584.tgfilter,p,LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,nil,code)
	if Duel.NegateEffect(ev) and #g>0 then
		Duel.BreakEffect()
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetValue(aux.indoval)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c19209584.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN)
end
function c19209584.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c19209584.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToChain() then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c19209584.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsReason(REASON_EFFECT) and re and re:IsActiveType(TYPE_MONSTER) then
			Duel.RegisterFlagEffect(rp,19209584,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
