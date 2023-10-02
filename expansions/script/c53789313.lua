local m=53789313
local cm=_G["c"..m]
cm.name="手塚琳"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.rmtg)
	e1:SetOperation(cm.rmop)
	c:RegisterEffect(e1)
	local sg=Group.CreateGroup()
	sg:KeepAlive()
	e1:SetLabelObject(sg)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetOperation(cm.desop)
	e2:SetLabelObject(sg)
	c:RegisterEffect(e2)
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
		if g:GetCount()==0 then return false end
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,POS_FACEDOWN) and tc:IsAbleToRemove(POS_FACEDOWN)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,POS_FACEDOWN)
	Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tffilter(c,tp)
	return c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()==0 then return end
	local tc1=g:GetMinGroup(Card.GetSequence):GetFirst()
	local tc2=Duel.GetTargetsRelateToChain():GetFirst()
	Duel.DisableShuffleCheck()
	if Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT)==0 or not tc1:IsLocation(LOCATION_REMOVED) or not tc2 then return end
	Duel.ConfirmCards(tp,Group.FromCards(tc1,tc2))
	Duel.ConfirmCards(1-tp,Group.FromCards(tc1,tc2))
	if not tc1:IsCode(tc2:GetCode()) or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if not tc:IsType(TYPE_CONTINUOUS) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1)
		end
		Duel.ShuffleDeck(tp)
		if c:IsRelateToEffect(e) then
			local sg=e:GetLabelObject()
			if c:GetFlagEffect(m)==0 then
				sg:Clear()
				c:RegisterFlagEffect(m,RESET_EVENT+0x1020000,0,1)
			end
			sg:AddCard(tc)
			tc:CreateRelation(c,RESET_EVENT+RESETS_STANDARD)
		end
	end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject():Filter(Card.IsRelateToCard,nil,e:GetHandler())
	e:GetHandler():ResetFlagEffect(m)
	e:GetLabelObject():Clear()
	Duel.Destroy(g,REASON_EFFECT)
end
