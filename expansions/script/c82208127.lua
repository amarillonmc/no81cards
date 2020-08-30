local m=82208127
local cm=_G["c"..m]
cm.name="龙法师 齿械龙"
function cm.initial_effect(c)
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)   
	e1:SetCondition(cm.spcon)  
	c:RegisterEffect(e1)  
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)  
	e2:SetTargetRange(0x0c,0)  
	e2:SetValue(aux.tgoval)  
	c:RegisterEffect(e2)
	--cannot destroy
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)  
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)  
	e3:SetValue(aux.indoval)  
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--extra atk 
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,0))  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1)  
	e5:SetCondition(cm.atkcon)
	e5:SetCost(cm.atkcost)  
	e5:SetTarget(cm.atktg)  
	e5:SetOperation(cm.atkop)  
	c:RegisterEffect(e5) 
end
function cm.filter(c)  
	return c:IsFaceup() and c:IsSetCard(0x6299)  
end  
function cm.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)  
end  
function cm.atkfilter(c)  
	return c:GetAttribute()~=0  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsAbleToEnterBP()  
end  
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,7) end  
	Duel.DiscardDeck(tp,7,REASON_COST)  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	if chk==0 then return ct>0 and e:GetHandler():GetEffectCount(EFFECT_EXTRA_ATTACK)==0 end  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local g=Duel.GetMatchingGroup(cm.atkfilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)  
	local att=0  
	local tc=g:GetFirst()  
	while tc do  
		att=bit.bor(att,tc:GetAttribute())  
		tc=g:GetNext()  
	end  
	local ct=0  
	while att~=0 do  
		if bit.band(att,0x1)~=0 then ct=ct+1 end  
		att=bit.rshift(att,1)  
	end  
	if c:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(c)  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetCode(EFFECT_EXTRA_ATTACK)  
		e1:SetValue(ct)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		c:RegisterEffect(e1)  
	end  
end  