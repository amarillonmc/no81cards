--星绘·序曲
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x452)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,5))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(3)
	e1:SetCost(s.sumcost)
	e1:SetTarget(s.sumtg)
	e1:SetOperation(s.sumop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(s.thcost1)
	e2:SetTarget(s.damtg)
	e2:SetOperation(s.dmgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCost(s.thcost2)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e4:SetCountLimit(1,id+1)
	e4:SetCost(s.thcost)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.activate)
	c:RegisterEffect(e4)
end

function s.sumcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x452,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x452,2,REASON_COST)
end
function s.sumfilter(c)
	return c:IsAbleToHand()
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~0 and g:GetFirst():IsAbleToDeck() and Duel.IsCanRemoveCounter(tp,1,1,0x452,1,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) and Duel.RemoveCounter(tp,1,1,0x452,1,REASON_COST) then 
			Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
		end
	end
end

function s.cfilter1(c)
	return c:IsAbleToGraveAsCost()
end
function s.thcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter1,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function s.cfilter2(c)
	return c:IsAbleToRemoveAsCost()
end
function s.thcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter2,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x452,1) end
end
function s.dmgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsCanAddCounter(0x452,1) then
		if c:AddCounter(0x452,1) and Duel.IsCanRemoveCounter(tp,1,1,0x452,3,REASON_EFFECT)
		and Duel.SelectYesNo(tp,aux.Stringid(id,3)) and Duel.RemoveCounter(tp,1,1,0x452,3,REASON_EFFECT) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_FIELD)
			e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
			e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e3:SetTargetRange(LOCATION_ONFIELD,0)
			e3:SetTarget(aux.TRUE)
			e3:SetValue(aux.indoval)
			e3:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e3,tp)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
			e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			e2:SetTargetRange(LOCATION_ONFIELD,0)
			e2:SetTarget(aux.TRUE)
			e2:SetValue(aux.indoval)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end

function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function s.atkfilter(e,c)
	return c:IsFaceup() and c:IsSetCard(0x452)
end
function s.atkfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x452)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(s.atkfilter)
	e2:SetValue(1000)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	if Duel.IsCanRemoveCounter(tp,1,1,0x452,3,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) and Duel.RemoveCounter(tp,1,1,0x452,3,REASON_EFFECT) then
		local g=Duel.GetMatchingGroup(s.atkfilter1,tp,LOCATION_MZONE,0,nil)
		local sc=g:GetFirst()
		while sc do
			local atk=sc:GetAttack()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(atk)
			sc:RegisterEffect(e1)
			sc=g:GetNext()
		end
	end
end