--战前试炼的百千抉择
function c67201115.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetTarget(c67201115.target)
	e1:SetOperation(c67201115.activate)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(67201115,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_DESTROY+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c67201115.optg)
	e2:SetOperation(c67201115.opop)
	c:RegisterEffect(e2) 
end
function c67201115.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c67201115.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local ttc=Duel.GetOperatedGroup():GetFirst()
		if ttc:IsSetCard(0x3670) then
			local c=e:GetHandler()
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local tc=g:GetFirst()
			while tc do
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				e3:SetValue(1000)
				tc:RegisterEffect(e3)
				tc=g:GetNext()
			end
		else
			local gg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
			Duel.Destroy(gg,REASON_EFFECT)
		end
	end
end
--
function c67201115.tdfilter(c)
	return c:IsSetCard(0x3670) and c:IsFaceupEx() and c:IsAbleToDeck()
end
function c67201115.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3670)
end
function c67201115.optg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.GetMatchingGroupCount(c67201115.desfilter,tp,LOCATION_ONFIELD,0,nil)>0 
		and Duel.GetFlagEffect(tp,67201115)==0
	local b2=Duel.IsExistingMatchingCard(c67201115.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,67201116)==0
	if chk==0 then return b1 or b2 end
end
function c67201115.opop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsPlayerCanDraw(tp,1) and Duel.GetMatchingGroupCount(c67201115.desfilter,tp,LOCATION_ONFIELD,0,nil)>0 
		and Duel.GetFlagEffect(tp,67201115)==0
	local b2=Duel.IsExistingMatchingCard(c67201115.tdfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil)
		and Duel.GetFlagEffect(tp,67201116)==0
	local op=0
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(67201115,1),aux.Stringid(67201115,2))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(67201115,1))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(67201115,2))+1
	else return end
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,c67201115.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,67201115,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c67201115.tdfilter),tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,1,nil)
		local opt=Duel.SelectOption(tp,aux.Stringid(67201115,5),aux.Stringid(67201115,6))
		if opt==0 then
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		else
			Duel.SendtoDeck(g,nil,SEQ_DECKBOTTOM,REASON_EFFECT)
		end
		Duel.RegisterFlagEffect(tp,67201116,RESET_PHASE+PHASE_END,0,1)
	end
end
