--次元解放者 麦哲
function c11560303.initial_effect(c)
	c:EnableReviveLimit()
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0) 
	--damage 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCountLimit(1,11560303) 
	e1:SetTarget(c11560303.distg) 
	e1:SetOperation(c11560303.disop) 
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_REMOVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,21560303)
	e2:SetTarget(c11560303.rsptg)
	e2:SetOperation(c11560303.rspop)
	c:RegisterEffect(e2)
end
c11560303.SetCard_XdMcy=true 
function c11560303.distg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_REMOVED,0,1,nil) and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,nil)  end  
	local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_HAND,0,1,1,nil):GetFirst() 
	local ctype=0
		for i,type in ipairs({TYPE_MONSTER,TYPE_SPELL,TYPE_TRAP}) do
			if tc:GetOriginalType()&type~=0 then
				ctype=ctype|type
			end
		end 
	Duel.Remove(tc,POS_FACEUP,REASON_COST)  
	Duel.SetChainLimit(c11560303.chlimit(ctype)) 
end  
function c11560303.chlimit(ctype)
	return function(e,ep,tp)
		return tp==ep or e:GetHandler():GetOriginalType()&ctype==0
	end
end
function c11560303.disfil(c) 
	return aux.NegateEffectMonsterFilter(c) and c:GetAttack()~=c:GetBaseAttack() and c:IsFaceup()   
end 
function c11560303.disop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local g1=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil) 
	local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)  
	if g1:GetCount()>0 and g2:GetCount()>0 then 
	local tc=g2:Select(tp,1,1,nil):GetFirst() 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(-g1:GetCount()*200) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	local g=Duel.GetMatchingGroup(c11560303.disfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
		if g:GetCount()==0 then return end 
		Duel.BreakEffect() 
		local sc=g:GetFirst()
		while sc do 
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e2)
		sc=g:GetNext() 
		end 
	end 
end 
function c11560303.datg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end 
function c11560303.daop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11560303,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_REMOVE)
	e1:SetCondition(c11560303.xdacon)
	e1:SetOperation(c11560303.xdaop) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11560303,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(11560303)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp) 
end 
function c11560303.dafilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c11560303.xdacon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c11560303.dafilter,1,nil)
end
function c11560303.xdaop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=eg:FilterCount(c11560303.dafilter,nil)
	Duel.Hint(HINT_CARD,0,11560303)
	Duel.Damage(1-tp,ct*200,REASON_EFFECT) 
	Duel.BreakEffect()
	Duel.Damage(1-tp,200,REASON_EFFECT)
end 
function c11560303.rspfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c.SetCard_XdMcy and not c:IsCode(11560303) 
end 
function c11560303.rsptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c11560303.rspfil,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end 
function c11560303.rspop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c11560303.rspfil,tp,LOCATION_REMOVED,0,nil,e,tp)
	if g:GetCount()>0 then 
	local sg=g:Select(tp,1,1,nil) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end 
end 









