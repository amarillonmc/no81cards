--罗穆路斯·奎里努斯
function c77032561.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c77032561.sprcon)
	e1:SetOperation(c77032561.sprop)
	c:RegisterEffect(e1) 
	--atk 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_BASE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000 end) 
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_BASE_DEFENSE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(function(e) 
	local tp=e:GetHandlerPlayer() 
	return Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*1000 end) 
	c:RegisterEffect(e1) 
	--xx
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(77032561,1))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c77032561.xxcon) 
	e2:SetCost(c77032561.xxcost)
	e2:SetTarget(c77032561.xxtg1) 
	e2:SetOperation(c77032561.xxop1) 
	c:RegisterEffect(e2) 
	local e2=Effect.CreateEffect(c) 
	e2:SetDescription(aux.Stringid(77032561,2))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_CHAINING) 
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCondition(c77032561.xxcon) 
	e2:SetCost(c77032561.xxcost)
	e2:SetTarget(c77032561.xxtg2) 
	e2:SetOperation(c77032561.xxop2) 
	c:RegisterEffect(e2) 
end
function c77032561.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0  
end
function c77032561.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler() 
	local g=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:IsReleasable() end,tp,LOCATION_ONFIELD,0,nil)
	return g:CheckSubGroup(c77032561.rlgck,3,3,tp)
end
function c77032561.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(function(c) return c:IsFacedown() and c:IsReleasable() end,tp,LOCATION_ONFIELD,0,nil)
	local rg=g:SelectSubGroup(tp,c77032561.rlgck,false,3,3,tp) 
	Duel.Release(rg,REASON_COST) 
end
function c77032561.xxcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp   
end 
function c77032561.xxcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	local flag=Duel.GetFlagEffectLabel(tp,77032561) 
	if chk==0 then return true end 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(77032561,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(77032561,0))
	if flag==nil then 
		Duel.RegisterFlagEffect(tp,77032561,RESET_PHASE+PHASE_END,0,1,1) 
	else  
		Duel.SetFlagEffectLabel(tp,77032561,flag+1)  
	end 
end 
function c77032561.setfil(c) 
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable(true)  
end 
function c77032561.xxtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032561.setfil,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 end 
end 
function c77032561.xxop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77032561.setfil,tp,LOCATION_GRAVE,0,nil) 
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SSet(tp,tc,1-tp) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)	   
	end 
end 
function c77032561.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE,1-tp)  
end 
function c77032561.xxtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c77032561.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end 
function c77032561.xxop2(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c77032561.spfil,tp,LOCATION_GRAVE,0,nil,e,tp) 
	if g:GetCount()>0 and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then 
		local tc=g:Select(tp,1,1,nil):GetFirst() 
		Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEDOWN_DEFENSE) 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)  
	end 
end 





