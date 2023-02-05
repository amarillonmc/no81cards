--恶染侵覆
local m=30005005
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,30005000)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.hand)
	c:RegisterEffect(e2)
end
function cm.hand(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_HAND,0,1,nil)
end
function cm.cfilter(c)
	local chk=c:IsFaceup() or c:IsLocation(LOCATION_HAND)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_RITUAL) and chk and c:IsAbleToGraveAsCost()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsStatus(STATUS_ACT_FROM_HAND) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_HAND,0,1,2,nil)  
		Duel.SendtoGrave(g,REASON_COST)
		local g1=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_GRAVE)
		g1:KeepAlive()
		e:SetLabelObject(g1)		   
	end
end
function cm.setfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsSSetable(true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,e:GetHandlerPlayer(),HINTMSG_TARGET)
	local flag=Duel.SelectField(e:GetHandlerPlayer(),1,0,LOCATION_ONFIELD,0xe000e0)
	local seq=math.log(flag>>16,2)
	e:SetLabel(seq)   
	Duel.Hint(HINT_ZONE,e:GetHandlerPlayer(),flag)
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>0 then
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,e:GetHandlerPlayer(),1)
	end
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>1 then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,e:GetHandlerPlayer(),LOCATION_HAND+LOCATION_GRAVE)
	end 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetLabel()
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetTargetRange(0,LOCATION_ONFIELD)
	e2:SetTarget(cm.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(seq)
	Duel.RegisterEffect(e2,tp)
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>0 then
		Duel.Hint(HINT_CARD,0,m) 
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	if e:GetLabelObject() and e:GetLabelObject():GetCount()>1 then
		local cg=Duel.GetMatchingGroup(cm.cf,tp,LOCATION_HAND+LOCATION_DECK,0,nil)
		if #cg==0 then return false end
		local te=cg:GetFirst():CheckActivateEffect(true,true,false)
		local tg=te:GetTarget()
		if not tg then return false end 
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local ccg=cg:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,ccg)
		if ccg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
			Duel.ShuffleHand(e:GetHandlerPlayer())
		end
		local tte=ccg:GetFirst():CheckActivateEffect(true,true,false)
		local op=tte:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function cm.cf(c)
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() then return false end
	return c:IsOriginalCodeRule(30005000) and c:CheckActivateEffect(true,true,false)~=nil
end
function cm.disable(e,c)
	local seq=e:GetLabel()
	local loc=LOCATION_MZONE
	if seq>8 then
		loc=LOCATION_SZONE
		seq=seq-8
	end
	if seq>=5 and seq<=7 then return false end
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if cloc==LOCATION_SZONE and cseq>=5 then return false end
	if cloc==LOCATION_MZONE and cseq>=5 and loc==LOCATION_MZONE
		and (seq==1 and cseq==5 or seq==3 and cseq==6) then return true end
	return (cseq==seq and  cloc==loc)  and math.abs(cseq-seq)==0 and c:IsFaceup()
end

