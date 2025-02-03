--翎骨龙魄
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000179)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(cm.handcon)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_TODECK+CATEGORY_LEAVE_GRAVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.bkcon)
	e3:SetOperation(cm.bkop)
	c:RegisterEffect(e3)
end
function cm.confil(c)
	return c:IsCode(60000179) and c:IsFaceup()
end
function cm.handcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62b)>0 end
	if Duel.GetCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62b)>=4 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.RemoveCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62b,4,REASON_COST)
		e:SetLabel(44)
	else
		Duel.RemoveCounter(e:GetHandlerPlayer(),LOCATION_MZONE,0,0x62b,1,REASON_COST)
		e:SetLabel(11)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.grfil,tp,LOCATION_GRAVE,0,1,nil,tp) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ag=Duel.GetMatchingGroup(cm.grfil,tp,LOCATION_GRAVE,0,nil,tp)
	if #ag==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=ag:Select(tp,1,1,nil):GetFirst()
	if e:GetLabel()==11 then
		if tc:CheckActivateEffect(true,true,false)==nil then return end
		local te=tc:CheckActivateEffect(true,true,false)
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	elseif e:GetLabel()==44 then
		for i=1,3 do
			if tc:CheckActivateEffect(true,true,false)==nil then return end
			local te=tc:CheckActivateEffect(true,true,false)
			e:SetLabelObject(te:GetLabelObject())
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
	local i=math.random(5,6)
	Duel.Hint(24,0,aux.Stringid(60000179,i))
end
function cm.grfil(c,tp)
	return aux.IsCodeListed(c,60000179) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,2,nil,c:GetCode()) and not c:IsCode(m) and c:CheckActivateEffect(true,true,false)~=nil and not c:IsCode(60000191)
end
function cm.bkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(e:GetHandlerPlayer(),m)~=0
end
function cm.bkop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	if #Duel.GetDecktopGroup(tp,1)==0 then
		Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	else
		local op=Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))
		if op==0 then
			Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
			Duel.BreakEffect()
			local num=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
			local ug=Duel.GetFieldGroup(tp,LOCATION_DECK,0):Sub(Duel.GetDecktopGroup(tp,num-1))
			Duel.SendtoHand(ug,nil,REASON_EFFECT)
		elseif op==1 then
			Duel.SendtoDeck(c,nil,1,REASON_EFFECT)
			Duel.BreakEffect()
			local ug=Duel.GetDecktopGroup(tp,1)
			Duel.SendtoHand(ug,nil,REASON_EFFECT)
		end
	end
end
--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end




