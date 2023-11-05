--归墟仲裁·屠破
local m=30015020
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--not Special Summon
	local ea=ors.notsp(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,8,4,2)
	--Effect 1
	local e1=ors.atkordef(c,400,4000)
	--Effect 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	--e2:SetCost(cm.togcost)
	e2:SetTarget(cm.togtg)
	e2:SetOperation(cm.togop)
	c:RegisterEffect(e2)
	local e13=Effect.CreateEffect(c)
	e13:SetCategory(CATEGORY_TOGRAVE+CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e13:SetType(EFFECT_TYPE_QUICK_O)
	e13:SetCode(EVENT_FREE_CHAIN)
	e13:SetRange(LOCATION_MZONE)
	e13:SetCountLimit(1)
	e13:SetCondition(cm.togcon)
	--e13:SetCost(cm.togcost)
	e13:SetTarget(cm.togtg)
	e13:SetOperation(cm.togop)
	c:RegisterEffect(e13)
	--Effect 3
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_TOHAND+CATEGORY_REMOVE)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.orscon)
	e21:SetTarget(cm.orstg)
	e21:SetOperation(cm.orsop)
	c:RegisterEffect(e21)
end
c30015020.isoveruins=true
--Effect 2
function cm.togcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_END and Duel.GetTurnPlayer()~=tp
end
function cm.ff(c,tp)
	return c:IsAbleToRemove(tp,POS_FACEDOWN)
end
function cm.togcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,POS_FACEDOWN)
	local gap=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,5,#gap-3,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(#sg)
end
function cm.togtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,POS_FACEDOWN)
	local gap=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if chk==0 then return #g>=5 and #gap>=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:Select(tp,5,#gap+3,nil)
	Duel.Remove(sg,POS_FACEDOWN,REASON_COST)
	e:SetLabel(#sg-3)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,gap,ct,0,0)
end
function cm.togop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local ec=e:GetHandler()
	local gap=Duel.GetMatchingGroup(Card.IsAbleToGrave,1-tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil)
	if ct==0 then return end
	if #gap>=ct-3 then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local tg=gap:Select(1-tp,ct,ct,nil)
		if Duel.SendtoGrave(tg,REASON_EFFECT)==0 then return false end
		local rct=Duel.GetOperatedGroup():GetCount()
		local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ff),0,LOCATION_GRAVE,LOCATION_GRAVE,nil,tp,POS_FACEDOWN)
		if #rg>=rct and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_REMOVE)
			local mg=rg:Select(tp,rct,rct,nil)
			Duel.Hint(HINT_CARD,0,m) 
			Duel.BreakEffect()
			Duel.Remove(mg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
--Effect 3
function cm.regop3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rsp=e:GetOwnerPlayer()
	if rp==1-rsp and c:GetPreviousControler()==rsp then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function cm.orscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.orstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local code=c:GetOriginalCodeRule()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,c,1,0,0)
	if ct>0 then
		local mg=sg:Clone()
		mg:RemoveCard(c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,mg,1,0,0)
	end
end
function cm.orsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
	if ct==1 then
		local sc=Duel.GetFirstTarget() 
		ors.ptorm(e,tp,sc,exchk)
	end
end