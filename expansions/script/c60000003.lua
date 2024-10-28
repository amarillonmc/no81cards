--承岚 FR-0045B
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.discon)
	e1:SetCost(cm.discost)
	e1:SetTarget(cm.distg)
	e1:SetOperation(cm.disop)
	c:RegisterEffect(e1)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetRange(0xff)
	e3:SetCost(cm.icost)
	e3:SetCondition(cm.icon)
	e3:SetTarget(cm.itg)
	e3:SetOperation(cm.iop)
	c:RegisterEffect(e3)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
end
function cm.costfilter1(c)
	return c:IsPublic() and c:IsAbleToGraveAsCost()
end
function cm.costfilter2(c)
	return c:IsSetCard(0x3623) and c:IsAbleToGraveAsCost()
end
function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() 
		and (Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,LOCATION_HAND,1,c)
		or (Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_HAND,0,1,c)
		and Duel.GetFlagEffect(tp,m))) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=nil
	local wt=0
	if Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,LOCATION_HAND,1,c)
		and Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_HAND,0,1,c)
		and Duel.GetFlagEffect(tp,m)==0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		wt=1
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	elseif not Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,LOCATION_HAND,1,c)
		and Duel.IsExistingMatchingCard(cm.costfilter2,tp,LOCATION_HAND,0,1,c)
		and Duel.GetFlagEffect(tp,m)==0 then
		wt=1
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	end
	if wt==1 then
		g=Duel.SelectMatchingCard(tp,cm.costfilter2,tp,LOCATION_HAND,0,1,1,c)
	elseif wt==0 then
		g=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,LOCATION_HAND,1,1,c)
	end
	g:AddCard(c)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end

function cm.icost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not (c:IsPublic() or c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) then Duel.ConfirmCards(1-tp,c) end
end
function cm.icon(e,tp,eg,ep,ev,re,r,rp)
	local tf=false
	local c=e:GetHandler()
	local loc=0
	if c:IsLocation(LOCATION_DECK) then loc=1 
	elseif c:IsLocation(LOCATION_HAND) then loc=2
	elseif c:IsLocation(LOCATION_ONFIELD) then loc=3
	elseif c:IsLocation(LOCATION_GRAVE) then loc=4
	elseif c:IsLocation(LOCATION_REMOVED) then loc=5 end
	if loc==0 then return end
	if e:GetLabel()==0 then
		tf=false
	elseif e:GetLabel()~=loc then
		tf=true
		Duel.RegisterFlagEffect(tp,m+10000000,0,0,1)
	end
	e:SetLabel(loc)
	return tf
end
function cm.itg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500*Duel.GetFlagEffect(tp,m+10000000))
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500*Duel.GetFlagEffect(tp,m+10000000))
end
function cm.iop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_CARD,0,m)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end