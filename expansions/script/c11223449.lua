local m=11223449
local cm=_G["c"..m]
cm.name="苏醒的妖域血奴 夜魅之光"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--To Hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.thcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
--Activate
function cm.eqfilter(c)
	return c:GetAttack()==500 and c:GetDefense()==500 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
		and not c:IsForbidden()
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_EQUIP)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local sel=0
		if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)
			and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then sel=sel+1 end
		if Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_SZONE,0,1,nil)
			and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) then sel=sel+2 end
		e:SetLabel(sel)
		return sel~=0
	end
	local sel=e:GetLabel()
	if sel==3 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		sel=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif sel==1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
	else
		Duel.SelectOption(tp,aux.Stringid(m,2))
	end
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_HANDES+CATEGORY_EQUIP)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_DESTROY)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,2,PLAYER_ALL,LOCATION_ONFIELD)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local sel=e:GetLabel()
	if sel==1 then
		local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
		if ct<1 then return end
		if ct>3 then ct=3 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
		if Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local eqg=Duel.SelectMatchingCard(tp,cm.eqfilter,tp,LOCATION_DECK,0,1,ct,nil)
		local tc=eqg:GetFirst()
		while tc do
			Duel.Equip(tp,tc,g:GetFirst(),true)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cm.eqlimit)
			e1:SetLabelObject(g:GetFirst())
			tc:RegisterEffect(e1)
			--Atk Up
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(500)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			--Remove
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetDescription(aux.Stringid(m,3))
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e3:SetValue(LOCATION_REMOVED)
			e3:SetReset(RESET_EVENT+RESETS_REDIRECT)
			tc:RegisterEffect(e3,true)
			tc=eqg:GetNext()
		end
	else
		if not Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_SZONE,0,1,nil)
			or not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g1=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_SZONE,0,1,1,nil)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1:GetFirst())
		g1:Merge(g2)
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
--To Hand
function cm.thfilter(c)
	return c:GetAttack()==500 and c:GetDefense()==500 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_WARRIOR)
		and c:IsAbleToRemoveAsCost()
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end