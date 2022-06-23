--悠久之音：单调
function c9310055.initial_effect(c)
	aux.AddCodeList(c,9310055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c9310055.condition)
	e1:SetTarget(c9310055.target)
	e1:SetOperation(c9310055.activate)
	c:RegisterEffect(e1)
	--release
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCondition(c9310055.condition)
	e2:SetCost(c9310055.cost)
	e2:SetTarget(c9310055.target)
	e2:SetOperation(c9310055.activate)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
	--addition
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCondition(c9310055.chcon)
	e4:SetOperation(c9310055.chop)
	c:RegisterEffect(e4)
end
function c9310055.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c9310055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c9310055.disfilter(c)
	return c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(9310055)
end
function c9310055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9310055.disfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetCountLimit(1)
	e1:SetLabelObject(e)
	e1:SetCondition(c9310055.rscon)
	e1:SetOperation(c9310055.rsop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c9310055.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c9310055.disfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
	   Duel.NegateActivation(ev)
	end
end
function c9310055.rscon(e,tp,eg,ep,ev,re,r,rp)
	return re==e:GetLabelObject()
end
function c9310055.rsop(e,tp,eg,ep,ev,re,r,rp)
	re:SetOperation(c9310055.activate)
	re:SetCategory(CATEGORY_TOHAND+CATEGORY_NEGATE+CATEGORY_DESTROY)
	re:SetLabel(0)
end
function c9310055.chcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED) and re:GetHandler():IsSetCard(0x97d) and re:GetHandler():GetType()&0x100004==0x100004 and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c9310055.chop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetLabel()&0x80~=0 then return end
	local op=re:GetOperation()
	local repop=function(e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(9310055,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(Card.IsAbleToDeck),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,2,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoDeck(g,nil,REASON_EFFECT)
			end
		end
	end
	re:SetOperation(repop)
	if not re:IsHasCategory(CATEGORY_TODECK) then re:SetCategory(re:GetCategory()+CATEGORY_TODECK) end
	re:SetLabel(re:GetLabel()|0x80)
end