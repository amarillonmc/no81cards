local m=15000294
local cm=_G["c"..m]
cm.name="阿难陀舍沙"
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,9,2)
	c:EnableReviveLimit()
	--Level:?
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.indcon)
	e1:SetTarget(cm.etg)
	e1:SetOperation(cm.eop)
	c:RegisterEffect(e1)
	--effect limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,15000294)
	e2:SetCondition(cm.condition)
	e2:SetCost(cm.cost)
	e2:SetOperation(cm.efop)
	c:RegisterEffect(e2)
end
function cm.indcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.cefilter(c,ct)
	return Duel.CheckChainTarget(ct,c)
end
function cm.etg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return ev and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):GetCount()==1 and re:IsActivated() and Duel.IsExistingTarget(cm.cefilter,tp,0xff,0xff,1,nil,ev)
	end
end
function cm.eop(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(cm.cefilter,tp,0xff,0xff,nil,ev)
	if ag:GetCount()~=0 then
		Duel.Hint(HINT_CARD,tp,15000294)
		local bg=ag:RandomSelect(tp,1)
		if bg:GetCount()==1 then
			Duel.HintSelection(bg)
			Duel.ChangeTargetCard(ev,bg)
		end
	end
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)>=1
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,LOCATION_ONFIELD)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	if tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetTargetRange(1,1)
		e1:SetCondition(cm.actcon)
		e1:SetTarget(cm.actfilter)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	elseif tc:IsFacedown() then
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_TRIGGER)
		e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
		e2:SetCondition(cm.actcon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END-RESET_TURN_SET)
		tc:RegisterEffect(e2,true)
	end
end
function cm.actfilter(e,c)
	return c:IsCode(e:GetLabelObject():GetCode())
end
function cm.actcon(e,c)
	return Duel.GetCurrentPhase()~=PHASE_END
end