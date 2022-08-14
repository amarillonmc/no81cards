--传说之魂 勇敢
local m=33350007
local cm=_G["c"..m]
function c33350007.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_COIN+CATEGORY_TOHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.destg2)
	e1:SetOperation(cm.desop2)
	c:RegisterEffect(e1)
	--local e2=e1:Clone()
	--e2:SetType(EFFECT_TYPE_IGNITION)
	--e2:SetCondition(cm.conditon2)
	--e2:SetTarget(cm.destg2)
	--e2:SetOperation(cm.desop2)
	--c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_TO_HAND)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetTargetRange(1,1)
	e4:SetTarget(cm.rmlimit)
	c:RegisterEffect(e4)
end
cm.setname="TaleSouls"
function cm.sfilter(c,e,tp)
	return c.setname=="TaleSouls" 
end
function cm.spfilter(c,e,tp)
	return c:IsCode(33350001) and c:IsFaceup()
end
function cm.conditon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.conditon2(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.sfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function cm.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()==0 then return end
	local coin=Duel.AnnounceCoin(tp)
	local res=Duel.TossCoin(tp,1)
	if coin~=res then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local tc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function cm.destg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,1)
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.desop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.sfilter,tp,LOCATION_DECK,0,nil)
	local ng=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()==0 then return end
	local n1=Duel.AnnounceCoin(1-tp)
	local n2=Duel.AnnounceCoin(1-tp)
	local ic=0
	if Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_REMOVED+LOCATION_GRAVE,0,1,nil,e,tp) then
		local n3=Duel.AnnounceCoin(1-tp)
		local n4=Duel.AnnounceCoin(1-tp)
		local n5=Duel.AnnounceCoin(1-tp)
		local l1,l2,l3,l4,l5=Duel.TossCoin(1-tp,5)
		if n1==l1 then ic=ic+1 end
		if n2==l2 then ic=ic+1 end
		if n3==l3 then ic=ic+1 end
		if n4==l4 then ic=ic+1 end
		if n5==l5 then ic=ic+1 end
	else
		local l1,l2=Duel.TossCoin(tp,2)
		if n1==l1 then ic=ic+1 end
		if n2==l2 then ic=ic+1 end
	end
	if ic~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
		local dg=g:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(dg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,dg)
		end
		if ic>1 then
			local yg=ng:Select(tp,1,1,nil)
			Duel.HintSelection(yg)
			Duel.Destroy(yg,REASON_EFFECT)
		end
		if ic>2 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_IMMUNE_EFFECT)
			e1:SetValue(cm.efilter)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(3000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DIRECT_ATTACK)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e3)
		end
	end
end
--效果2

function cm.rmlimit(e,c,tp,r)
	return c==e:GetHandler() and r==REASON_EFFECT
end