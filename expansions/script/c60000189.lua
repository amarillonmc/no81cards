--渺世行阼
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000179)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,4))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_LEAVE_GRAVE+CATEGORY_GRAVE_ACTION)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_HAND)
	e11:SetCost(cm.cpcost)
	e11:SetCondition(cm.cpcon)
	e11:SetTarget(cm.cptg)
	e11:SetOperation(cm.cpop)
	c:RegisterEffect(e11)
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetFlagEffect(m+10000000)+c:GetFlagEffect(m+20000000)+c:GetFlagEffect(m+30000000)==3
end
function cm.filter(c)
	return aux.IsCodeListed(c,60000179) and not c:IsCode(m) and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	if g:GetCount()>0 and Duel.SendtoGrave(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,2,nil,m) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(cm.val)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
		e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e4:SetTarget(cm.vtg)
		e4:SetReset(RESET_PHASE+PHASE_END)
		e4:SetLabelObject(e1)
		Duel.RegisterEffect(e4,tp)
		local e5=e4:Clone()
		e5:SetLabelObject(e2)
		Duel.RegisterEffect(e5,tp)
	end
end
function cm.val(e,c)
	return 2000+(Duel.GetFlagEffect(e:GetHandlerPlayer(),m)*1000)
end
function cm.vtg(e,c)
	return c:IsCode(60000179) and c:IsFaceup()
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if not e:GetHandler():IsPublic() then
		e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		local e11=Effect.CreateEffect(c)
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetCode(EFFECT_PUBLIC)
		e11:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e:GetHandler():RegisterEffect(e11)
	end
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.IsCodeListed(re:GetHandler(),60000179)
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	local b3=false
	if c:GetFlagEffect(m+10000000)==0 and Duel.GetFlagEffect(tp,m+10000000)==0 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then b1=true end
	if c:GetFlagEffect(m+20000000)==0 and Duel.GetFlagEffect(tp,m+20000000)==0 and Duel.IsExistingMatchingCard(cm.cpfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) then b2=true end
	if c:GetFlagEffect(m+30000000)==0 and Duel.GetFlagEffect(tp,m+30000000)==0 and Duel.IsExistingMatchingCard(cm.cpfil2,tp,LOCATION_DECK,0,1,nil) then b3=true end
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,5)},{b2,aux.Stringid(m,6)},{b3,aux.Stringid(m,7)})
	e:SetLabel(op)
	if op==1 then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_ONFIELD)
	elseif op==2 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
	elseif op==3 then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 and c:GetFlagEffect(m+10000000)==0 and Duel.GetFlagEffect(tp,m+10000000)==0 then
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=g:Select(tp,1,1,nil)
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then
			c:RegisterFlagEffect(m+10000000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			Duel.RegisterFlagEffect(tp,m+10000000,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==2 and c:GetFlagEffect(m+20000000)==0 and Duel.GetFlagEffect(tp,m+20000000)==0 then
		local g=Duel.GetMatchingGroup(cm.cpfil1,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			c:RegisterFlagEffect(m+20000000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,2))
			Duel.RegisterFlagEffect(tp,m+20000000,RESET_PHASE+PHASE_END,0,1)
		end
	elseif op==3 and c:GetFlagEffect(m+30000000)==0 and Duel.GetFlagEffect(tp,m+30000000)==0 then
		local g=Duel.GetMatchingGroup(cm.cpfil2,tp,LOCATION_DECK,0,nil)
		if #g==0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,sg)
			c:RegisterFlagEffect(m+30000000,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,3))
			Duel.RegisterFlagEffect(tp,m+30000000,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function cm.cpfil1(c)
	return c:IsCode(60000179) and c:IsAbleToHand()
end
function cm.cpfil2(c)
	return aux.IsCodeListed(c,60000179) and not c:IsCode(m) and c:IsAbleToHand() and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end







