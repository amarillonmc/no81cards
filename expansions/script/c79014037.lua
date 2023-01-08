--《那个乐队》
function c79014037.initial_effect(c)
	aux.AddCodeList(c,79014030)
	--cost
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c79014037.mtcon)
	e1:SetOperation(c79014037.mtop)
	c:RegisterEffect(e1)
	--Activate 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetCondition(c79014037.accon) 
	e1:SetOperation(function(e) 
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(79014037,15)) 
	end)
	c:RegisterEffect(e1) 
	--direct 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD) 
	e2:SetCode(EFFECT_DIRECT_ATTACK) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_SPIRIT) end) 
	c:RegisterEffect(e2) 
	--xx
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e3:SetCode(EVENT_PHASE+PHASE_END) 
	e3:SetRange(LOCATION_FZONE) 
	e3:SetCountLimit(1)
	e3:SetTarget(c79014037.xxtg) 
	e3:SetOperation(c79014037.xxop) 
	c:RegisterEffect(e3) 
	if not c79014037.global_check then
		c79014037.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c79014037.checkop)
		Duel.RegisterEffect(ge1,0) 
	end
end
function c79014037.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst() 
	while tc do 
		if tc:IsPreviousLocation(LOCATION_ONFIELD) and tc:IsType(TYPE_SPIRIT) then 
			local p=tc:GetPreviousControler() 
			local flag=Duel.GetFlagEffectLabel(p,79014037)
			if flag==nil then  
			Duel.RegisterFlagEffect(p,79014037,RESET_PHASE+PHASE_END,0,1,1) 
			else 
			Duel.SetFlagEffectLabel(p,79014037,flag+1) 
			end 
		end 
	tc=eg:GetNext()
	end
end
function c79014037.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c79014037.cfilter1(c)
	return c:IsType(TYPE_SPIRIT) and c:IsLevel(4) and c:IsAbleToDeckAsCost()
end
function c79014037.cfilter2(c)
	return c:IsAbleToRemoveAsCost(POS_FACEDOWN) 
end
function c79014037.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c79014037.cfilter1,tp,LOCATION_HAND,0,nil)
	local g2=Duel.GetMatchingGroup(c79014037.cfilter2,tp,LOCATION_EXTRA,0,nil)
	local select=2
	if g1:GetCount()>0 and g2:GetCount()>=3 then
		select=Duel.SelectOption(tp,aux.Stringid(79014037,0),aux.Stringid(79014037,1),aux.Stringid(79014037,2))
	elseif g1:GetCount()>0 then
		select=Duel.SelectOption(tp,aux.Stringid(79014037,0),aux.Stringid(79014037,2))
		if select==1 then select=2 end
	elseif g2:GetCount()>=3 then
		select=Duel.SelectOption(tp,aux.Stringid(79014037,1),aux.Stringid(79014037,2))+1
	else
		select=Duel.SelectOption(tp,aux.Stringid(79014037,2))
		select=2
	end
	if select==0 then 
		local g=g1:Select(tp,1,1,nil)
		Duel.SendtoDeck(g,nil,2,REASON_COST)
	elseif select==1 then 
		local g=g2:RandomSelect(tp,3)
		Duel.Remove(g,POS_FACEDOWN,REASON_COST)
	else
		Duel.Destroy(c,REASON_COST)
	end
end
function c79014037.ckfil(c) 
	return c:IsFaceup() and c:IsCode(79014030) 
end 
function c79014037.accon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c79014037.ckfil,tp,LOCATION_MZONE,0,1,nil)
end 
function c79014037.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,79014037)
	if chk==0 then return flag and flag>0 end 
end 
function c79014037.xxop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=Duel.GetFlagEffectLabel(tp,79014037)
	if flag and flag>0 then 
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(flag)
	e1:SetValue(c79014037.damval)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp) 
	c:SetHint(CHINT_NUMBER,flag*500)
	end 
end 
function c79014037.damval(e,re,val,r,rp,rc) 
	local x=e:GetLabel() 
	if x*500>val then 
	return 0   
	else return val-x*500 end
end





