--忒提斯场地测试
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetCost(s.descost)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function s.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:GetOverlayCount()>0
end
function s.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(s.rmfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if Duel.Remove(tc,0,REASON_COST+REASON_TEMPORARY)~=0 then
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_CHAIN,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetLabelObject(tc)
		e1:SetCountLimit(1)
		e1:SetOperation(s.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ReturnToField(tc)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if KOISHI_CHECK then
		local fc=Duel.GetFieldGroup(tp,0,LOCATION_FZONE)
		local tg1=Group.CreateGroup()
		if fc then
			if Duel.ChangePosition(fc,POS_FACEDOWN)==1 then tg1:AddCard(fc) end
		end
		for i=1,5 do
			c:SetCardData(CARDDATA_CODE,id+i)
		end
		local tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,4)
		if tc then
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)==1 then tg1:AddCard(tc) end
		end
		c:SetCardData(CARDDATA_CODE,id+6)
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,0)
		if tc then
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)==1 then tg1:AddCard(tc) end
		end
		c:SetCardData(CARDDATA_CODE,id+7)
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,2)
		if tc then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		c:SetCardData(CARDDATA_CODE,id+8)
		c:SetCardData(CARDDATA_CODE,id+9)
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,1)
		if tc then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		c:SetCardData(CARDDATA_CODE,id+10)
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,4)
		if tc then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		c:SetCardData(CARDDATA_CODE,id+11)
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,2)
		if tc then
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)==1 then tg1:AddCard(tc) end
		end
		c:SetCardData(CARDDATA_CODE,id+12)
		c:SetCardData(CARDDATA_CODE,id+13)
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,0)
		if tc then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		c:SetCardData(CARDDATA_CODE,id+14)
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,3)
		if tc then
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)==1 then tg1:AddCard(tc) end
		end
		c:SetCardData(CARDDATA_CODE,id+15)
		tc=Duel.GetFieldCard(1-tp,LOCATION_MZONE,3)
		if tc then Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
		c:SetCardData(CARDDATA_CODE,id+16)
		tc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,1)
		if tc then
			tc:CancelToGrave()
			if Duel.ChangePosition(tc,POS_FACEDOWN)==1 then tg1:AddCard(tc) end
		end
		c:SetCardData(CARDDATA_CODE,id+17)
		if tg1:GetCount()>0 then Duel.RaiseEvent(tg1,EVENT_SSET,e,REASON_EFFECT,tp,tp,0) end
		for i=18,33 do
			c:SetCardData(CARDDATA_CODE,id+i)
		end
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
		for i=34,38 do
			c:SetCardData(CARDDATA_CODE,id+i)
		end
		c:SetCardData(CARDDATA_CODE,id)
	else
		local g=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_MZONE,nil)
		if g:GetCount()>0 then
			Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
		end
		local g2=Duel.GetMatchingGroup(Card.IsCanTurnSet,tp,0,LOCATION_SZONE,nil)
		local tc=g2:GetFirst()
		while tc do
			tc:CancelToGrave()
			tc=g2:GetNext()
		end
		Duel.ChangePosition(g2,POS_FACEDOWN)
		Duel.BreakEffect()
		local sg=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
		Duel.Destroy(sg,REASON_EFFECT,LOCATION_REMOVED)
	end
end