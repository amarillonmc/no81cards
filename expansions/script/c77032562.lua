--罗穆路斯
function c77032562.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77032562.sprcon)
	e1:SetOperation(c77032562.sprop)
	c:RegisterEffect(e1)	
	--set
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,77032562) 
	e2:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,77032561) 
	if chk==0 then return Duel.IsExistingMatchingCard(function(c) return c:IsFacedown() and c:IsReleasable() end,tp,LOCATION_ONFIELD,0,1,nil) end 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsFacedown() and c:IsReleasable() end,tp,LOCATION_ONFIELD,0,1,1,nil) 
	Duel.Release(g,REASON_COST) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(77032562,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(77032562,0))
	if flag==nil then 
		Duel.RegisterFlagEffect(tp,77032561,RESET_PHASE+PHASE_END,0,1,1) 
	else  
		Duel.SetFlagEffectLabel(tp,77032561,flag+1)  
	end end)  
	e2:SetTarget(c77032562.settg) 
	e2:SetOperation(c77032562.setop) 
	c:RegisterEffect(e2) 
end
function c77032562.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0  
end
function c77032562.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:IsReleasable() end,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c77032562.rlgck,1,1,tp)
end
function c77032562.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:IsReleasable() end,tp,LOCATION_ONFIELD,0,nil)
	local rg=g:SelectSubGroup(tp,c77032562.rlgck,false,1,1,tp) 
	Duel.Release(rg,REASON_COST) 
end 
function c77032562.setfil(c) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)  
end 
function c77032562.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032562.setfil,tp,LOCATION_DECK,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end 
end 
function c77032562.setop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local ft=Duel.GetLocationCount(1-tp,LOCATION_SZONE) 
	local g=Duel.GetMatchingGroup(c77032562.setfil,tp,LOCATION_DECK,0,nil) 
	local x=g:GetCount() 
	if x>2 then x=2 end 
	if x>ft then x=ft end 
	local sg=g:Select(tp,1,x,nil) 
	Duel.SSet(tp,sg,1-tp) 
end   

