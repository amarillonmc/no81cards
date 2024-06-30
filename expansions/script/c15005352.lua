local m=15005352
local cm=_G["c"..m]
cm.name="迷忆渊裔69-苦难路"
function cm.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(cm.tgcost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--
	local ge1=Effect.CreateEffect(c)
	ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	ge1:SetCode(EVENT_CUSTOM+15005350)
	ge1:SetCondition(cm.regcon)
	ge1:SetOperation(cm.regop)
	ge1:SetLabelObject(c)
	Duel.RegisterEffect(ge1,0)
	--Gains Effect
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(cm.reg2con)
	e2:SetOperation(cm.reg2op)
	e2:SetLabelObject(c)
	c:RegisterEffect(e2)
	--
	if not ChasmoryCheck then
		ChasmoryCheck=true
		_ChasmoryOverlay=Duel.Overlay
		function Duel.Overlay(c,ocard)
			local re=Effect.CreateEffect(c)
			c:RegisterEffect(re)
			local res=_ChasmoryOverlay(c,ocard)
			local eg=Group.CreateGroup()
			if aux.GetValueType(ocard)=="Group" then eg=ocard:Clone() end
			if aux.GetValueType(ocard)=="Card" then eg:AddCard(ocard) end
			Duel.RaiseEvent(eg,EVENT_CUSTOM+15005350,re,0,0,0,0)
			return res
		end
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	return eg:IsContains(c) and (c:IsPreviousLocation(LOCATION_MZONE) or c:IsPreviousLocation(LOCATION_GRAVE))
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetOwner()
	local c=e:GetLabelObject()
	--gain effect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,m)
	--e2:SetCondition(cm.srcon)
	e2:SetCost(cm.srcost)
	e2:SetTarget(cm.srtg)
	e2:SetOperation(cm.srop)
	e2:SetLabelObject(c)
	e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	rc:RegisterEffect(e2)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0xff0000)
		rc:RegisterEffect(e2,true)
	end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,0,0,0,0)
end
function cm.reg2con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return r==REASON_XYZ and c:GetReasonCard():IsType(TYPE_XYZ)
end
function cm.reg2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local rc=c:GetReasonCard()
	Duel.RaiseEvent(c,EVENT_CUSTOM+m,e,0,0,0,0)
end
function cm.costfilter(c)
	return c:IsDiscardable()
end
function cm.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,c) and c:IsDiscardable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,c)
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
end
function cm.filter(c,tp)
	return c:IsSetCard(0xcf3c) and c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_FZONE,0)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		te:UseCountLimit(tp,1,true)
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetLabelObject()) and (e:GetLabelObject():IsPreviousLocation(LOCATION_MZONE) or e:GetLabelObject():IsPreviousLocation(LOCATION_GRAVE))
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.srfilter(c)
	return c:IsSetCard(0xcf3c) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end