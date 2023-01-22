--虚景创形 相对原理
function c33331807.initial_effect(c) 
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x566),2,2)
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0) 
	--set
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_IGNITION) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,33331807) 
	e1:SetCost(c33331807.setcost) 
	e1:SetTarget(c33331807.settg) 
	e1:SetOperation(c33331807.setop) 
	c:RegisterEffect(e1)  
	--change effect
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,13331807) 
	e2:SetCondition(c33331807.chcon) 
	e2:SetTarget(c33331807.chtg)
	e2:SetOperation(c33331807.chop)
	c:RegisterEffect(e2)
end 
function c33331807.ctfil(c) 
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x566) and c:IsType(TYPE_MONSTER)   
end 
function c33331807.setcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c33331807.ctfil,tp,LOCATION_GRAVE,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,c33331807.ctfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end 
function c33331807.setfil(c) 
	return c:IsSSetable() and c:IsSetCard(0x566) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
end 
function c33331807.settg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c33331807.setfil,tp,LOCATION_DECK,0,1,nil) end  
end 
function c33331807.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33331807.setfil,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SSet(tp,tc)	
	end 
end  
function c33331807.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end  
function c33331807.ckfil(c) 
	return c:IsFaceup() and c:IsType(TYPE_TOKEN)   
end 
function c33331807.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33331807.ckfil,tp,LOCATION_MZONE,0,1,nil) end
end
function c33331807.chop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c33331807.repop)
end
function c33331807.repop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33331807.ckfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
		local dg=g:Select(tp,1,1,nil) 
		Duel.Destroy(dg,REASON_EFFECT) 
	end 
end



