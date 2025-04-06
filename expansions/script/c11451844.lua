--连锁意外
--23.06.29
local cm,m=GetID()
function cm.initial_effect(c)
	--copy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	--e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_TO_GRAVE)
		ge3:SetOperation(cm.checkop3)
		Duel.RegisterEffect(ge3,0)
		local ge4=Effect.CreateEffect(c)
		ge4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge4:SetCode(EVENT_SSET)
		ge4:SetLabelObject(ge3)
		ge4:SetOperation(cm.checkop4)
		Duel.RegisterEffect(ge4,0)
		local ec={
			EVENT_CHAIN_ACTIVATING,
			EVENT_CHAINING,
			EVENT_ATTACK_ANNOUNCE,
			EVENT_BREAK_EFFECT,
			EVENT_CHAIN_SOLVING,
			EVENT_CHAIN_SOLVED,
			EVENT_CHAIN_END,
			EVENT_SUMMON,
			EVENT_SPSUMMON,
			EVENT_MSET,
			EVENT_BATTLE_DESTROYED
		}
		for _,code in ipairs(ec) do
			local ce=ge3:Clone()
			ce:SetCode(code)
			ce:SetLabelObject(ge3)
			ce:SetOperation(cm.checkop31)
			Duel.RegisterEffect(ce,0)
		end
	end
end
function cm.checkop3(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,e:GetLabel())
	end
end
function cm.checkop4(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	local g=eg:Filter(Card.IsLocation,nil,LOCATION_SZONE)
	for tc in aux.Next(g) do
		tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1,te:GetLabel())
	end
	te:SetLabel(te:GetLabel()+1)
end
function cm.checkop31(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	te:SetLabel(te:GetLabel()+1)
end
function cm.fieldid(c)
	return c:GetFlagEffectLabel(m) or -1
end
function cm.filter(c,ec)
	return (c:GetType()&TYPE_QUICKPLAY>0 or c:GetType()==TYPE_TRAP) and not c:IsReason(REASON_RETURN) and cm.fieldid(c)<cm.fieldid(ec)
end
function cm.filter2(c,ec,sc)
	return cm.filter(c,ec) and cm.fieldid(c)==cm.fieldid(sc) and c:IsAbleToRemoveAsCost() and ((c:GetType()&TYPE_QUICKPLAY>0 and c:CheckActivateEffect(true,true,false)~=nil) or (c:GetType()&TYPE_TRAP>0 and c:CheckActivateEffect(false,true,false)~=nil))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	--e:SetLabel(1)
	return true
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then
		if not e:IsCostChecked() or #hg==0 then return false end
		--e:SetLabel(0)
		local c=e:GetHandler()
		if c:GetFlagEffect(m)==0 then return end
		local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e:GetHandler())
		if #g<=Duel.GetCurrentChain() then return end
		local ct=math.min(#g,Duel.GetCurrentChain()+1)
		if c:IsFaceup() and not c:IsStatus(STATUS_EFFECT_ENABLED) then ct=math.min(#g,Duel.GetCurrentChain()) end
		local maxc=g:GetMaxGroup(cm.fieldid):GetFirst()
		for i=1,ct do
			maxc=g:GetMaxGroup(cm.fieldid):GetFirst()
			g:RemoveCard(maxc)
		end
		local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE,0,nil,e:GetHandler(),maxc)
		--Debug.Message(ct..#sg)
		return #sg>0
	end
	e:SetLabel(0)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil,e:GetHandler())
	local ct=math.min(#g,Duel.GetCurrentChain())
	local maxc=g:GetMaxGroup(cm.fieldid):GetFirst()
	for i=1,ct do
		maxc=g:GetMaxGroup(cm.fieldid):GetFirst()
		g:RemoveCard(maxc)
	end
	local sg=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_GRAVE,0,nil,e:GetHandler(),maxc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=sg:Select(tp,1,1,nil)
	local bool=true
	if g:GetFirst():GetType()==TYPE_TRAP then bool=false end
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(bool,true,true)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,0,nil)
	if #g>0 then --and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		--Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		g=g:Select(tp,1,1,nil)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
	end
end