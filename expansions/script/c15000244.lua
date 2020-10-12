local m=15000244
local cm=_G["c"..m]
cm.name="记忆：永寂之国"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15000244)
	--activate  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE)  
	e1:SetCode(EVENT_FREE_CHAIN)  
	c:RegisterEffect(e1) 
	--swith
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.swcon)
	e2:SetTarget(cm.swtg)
	e2:SetOperation(cm.swop)
	c:RegisterEffect(e2)
end
function cm.swfilter1(c)  
	return c:IsFacedown() and c:GetSequence()<5  
end
function cm.swfilter2(c)  
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()~=0
end
function cm.swcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()
	local tp=c:GetControler()
	local ag=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_FZONE,0,nil,TYPE_FIELD)
	local bg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_FZONE,nil,TYPE_FIELD)
	local a=0
	local b=0
	if ag:GetCount()~=0 then a=1 end
	if bg:GetCount()~=0 then b=1 end
	return ((a==1 and ag:GetFirst():IsCode(15000240) and Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler())) or (b==1 and bg:GetFirst():IsCode(15000240) and Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler()))) or ((a==1 and ag:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler())) or (b==1 and bg:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler())))
end
function cm.swtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()  
	local tp=c:GetControler()
	if chk==0 then return true end  
	local ag=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_FZONE,0,nil,TYPE_FIELD)
	local bg=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_FZONE,nil,TYPE_FIELD)
	local a=0
	local b=0
	if ag:GetCount()~=0 then a=1 end
	if bg:GetCount()~=0 then b=1 end
	if ((a==1 and ag:GetFirst():IsCode(15000240) and Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler())) or (b==1 and bg:GetFirst():IsCode(15000240) and Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler()))) and not Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler()) then e:SetLabel(0) end
	if ((a==1 and ag:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler())) or (b==1 and bg:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler()))) and not Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler()) then e:SetLabel(1) end
	if (((a==1 and ag:GetFirst():IsCode(15000240) and Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler())) or (b==1 and bg:GetFirst():IsCode(15000240) and Duel.IsExistingMatchingCard(cm.swfilter1,tp,0,LOCATION_SZONE,1,e:GetHandler()))) and ((a==1 and ag:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler())) or (b==1 and bg:GetFirst():IsCode(15000241) and Duel.IsExistingMatchingCard(cm.swfilter2,tp,0,LOCATION_MZONE,1,e:GetHandler())))) then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
		local x=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
		if x==0 then e:SetLabel(0) end
		if x==1 then e:SetLabel(1) end
	end
end
function cm.swop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local tp=c:GetControler()
	local x=e:GetLabel()
	if x==1 then
		local g=Duel.GetMatchingGroup(cm.swfilter2,tp,0,LOCATION_MZONE,nil)  
		local tc=g:GetFirst()  
		while tc do  
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
			e1:SetValue(tc:GetBaseAttack()/2)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
			tc:RegisterEffect(e1)  
			tc=g:GetNext()  
		end
	end
	if x==0 then
		local tc=Duel.SelectMatchingCard(tp,cm.swfilter1,tp,0,LOCATION_SZONE,1,1,e:GetHandler()):GetFirst()
		if c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_CANNOT_TRIGGER)  
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(1)  
			tc:RegisterEffect(e1)	
		end
	end
end