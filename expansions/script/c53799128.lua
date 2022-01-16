local m=53799128
local cm=_G["c"..m]
cm.name="隐菌女 MZ"
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.NOT(aux.FilterBoolFunction(Card.IsLinkType,TYPE_TOKEN)),3,3,cm.lcheck)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cpcost)
	e1:SetTarget(cm.cptg)
	e1:SetOperation(cm.cpop)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
function cm.lcheck(g)
	return g:GetClassCount(Card.GetLinkRace)==1
end
function cm.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL)
end
function cm.cpfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost() and c:IsAbleToRemove(POS_FACEDOWN) and c:CheckActivateEffect(false,true,false)~=nil and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,2,c,c:GetCode())
end
function cm.filter(c,code)
	return c:IsCode(code) and c:IsAbleToGraveAsCost() and c:IsAbleToRemove(POS_FACEDOWN)
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ConfirmCards(1-tp,g)
	local sg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_HAND+LOCATION_DECK,0,g:GetFirst(),g:GetFirst():GetCode())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	if #sg>2 then sg=sg:Select(tp,2,2,nil) end
	g:Merge(sg)
	Duel.SendtoGrave(g,REASON_COST)
	Duel.SetTargetCard(g)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.ckfilter(c,code)
	return c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g and g:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==3 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
		local ct=Duel.GetOperatedGroup():FilterCount(function(c,code)return c:IsLocation(LOCATION_REMOVED) and c:IsFacedown()end,nil)
		if ct==3 and te then
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
