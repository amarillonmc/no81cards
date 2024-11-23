--虚景创成 天位数·十
function c33331810.initial_effect(c) 
	--Activate 
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_ACTIVATE) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	c:RegisterEffect(e1) 
	--draw 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1,33331810) 
	e2:SetCost(c33331810.drcost) 
	e2:SetTarget(c33331810.drtg) 
	e2:SetOperation(c33331810.drop) 
	c:RegisterEffect(e2) 
	--immune 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetValue(1) 
	e2:SetCondition(c33331810.imcon)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
end
function c33331810.ickfil(c) 
	return c:IsFaceup() and c:IsCode(33331808) 
end 
function c33331810.imcon(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.IsExistingMatchingCard(c33331810.ickfil,tp,LOCATION_MZONE,0,1,nil)
end 
function c33331810.ctdfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x566) 
end 
function c33331810.tdgck(g) 
	return g:GetCount()==1 or g:GetCount()==10  
end 
function c33331810.drcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c33331810.ctdfil,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:CheckSubGroup(c33331810.tdgck,1,10) end 
	local sg=g:SelectSubGroup(tp,c33331810.tdgck,false,1,10) 
	Duel.SendtoGrave(sg,REASON_COST)  
	if sg:GetCount()==10 then 
	e:SetLabel(1) 
	else e:SetLabel(0) end 
end 
function c33331810.drtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2) 
end 
function c33331810.atkfil(c) 
	return c:IsFaceup() and c:IsCode(33331808) 
end 
function c33331810.drop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if Duel.IsPlayerCanDraw(tp,2) and Duel.Draw(tp,2,REASON_EFFECT)~=0 and e:GetLabel()==1 and Duel.IsExistingMatchingCard(c33331810.atkfil,tp,LOCATION_MZONE,0,1,nil) then 
		local g=Duel.GetMatchingGroup(c33331810.atkfil,tp,LOCATION_MZONE,0,nil)   
		local tc=g:GetFirst()  
		while tc do 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetAttack()*10)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1) 
		tc=g:GetNext() 
		end 
	end 
end 







