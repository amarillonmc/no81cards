--方舟骑士-阿米娅·青色怒火
function c29065513.initial_effect(c)
	aux.AddCodeList(c,29065500) 
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0) 
	--change name
	aux.EnableChangeCode(c,29065500)
	-- 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetCountLimit(1,29065513+EFFECT_COUNT_CODE_DUEL) 
	e1:SetTarget(c29065513.xxtg) 
	e1:SetOperation(c29065513.xxop)  
	c:RegisterEffect(e1) 
	
end
function c29065513.xxtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e1)  
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c29065513.efilter)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	e2:SetOwnerPlayer(tp)
	c:RegisterEffect(e2)	 
end
function c29065513.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c29065513.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	local tc=g:GetMaxGroup(Card.GetAttack):Select(tp,1,1,nil):GetFirst() 
	Duel.CalculateDamage(c,tc) 
	end 
end 









