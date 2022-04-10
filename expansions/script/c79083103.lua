--圣赐乐土 送葬人
function c79083103.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,79083103+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79083103.hspcon)
	e1:SetValue(c79083103.hspval)
	e1:SetOperation(c79083103.hspop)
	c:RegisterEffect(e1)	
	--Damage
	local e2=Effect.CreateEffect(c)  
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,19083103)
	e2:SetTarget(c79083103.datg)
	e2:SetOperation(c79083103.daop) 
	c:RegisterEffect(e2)
end
c79083103.named_with_Laterano=true 
function c79083103.hspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local flag=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,1) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083210) then 
	flag=bit.bor(flag,2) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083310) then 
	flag=bit.bor(flag,4) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083410) then 
	flag=bit.bor(flag,8) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083510) then 
	flag=bit.bor(flag,16) 
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,flag)>0
end
function c79083103.hspval(e,c)
	local tp=c:GetControler()
	local flag=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,1) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083210) then 
	flag=bit.bor(flag,2) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083310) then 
	flag=bit.bor(flag,4) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083410) then 
	flag=bit.bor(flag,8) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083510) then 
	flag=bit.bor(flag,16) 
	end
	return SUMMON_TYPE_RITUAL,flag 
end
function c79083103.hspop(e,tp,eg,ep,ev,re,r,rp,c) 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083103,1)) 
	Duel.Hint(24,0,aux.Stringid(79083103,2)) 
end
function c79083103.datg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1200)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,1200)
end
function c79083103.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)  
	local xp=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) and c:GetSequence()==0 then 
	xp=1  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083210) and c:GetSequence()==1 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083310) and c:GetSequence()==2 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083410) and c:GetSequence()==3 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083510) and c:GetSequence()==4 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and c:GetSequence()==5 then 
	xp=1  
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and c:GetSequence()==6 then 
	xp=1 
	end 
	if xp==1 and (Duel.CheckLocation(tp,LOCATION_MZONE,5) or Duel.CheckLocation(tp,LOCATION_MZONE,6)) and Duel.SelectYesNo(tp,aux.Stringid(79083103,0)) then  
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083103,3)) 
	Duel.Hint(24,0,aux.Stringid(79083103,4)) 
	local flag=0 
	local flag=bit.bor(flag,1)
	local flag=bit.bor(flag,2)
	local flag=bit.bor(flag,4)
	local flag=bit.bor(flag,8)
	local flag=bit.bor(flag,16)
	local flag=bit.bor(flag,65536*1)
	local flag=bit.bor(flag,65536*2)
	local flag=bit.bor(flag,65536*4)
	local flag=bit.bor(flag,65536*8)
	local flag=bit.bor(flag,65536*16)
	local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,LOCATION_MZONE,flag)
	if zone==4194336 then 
	Duel.MoveSequence(c,5) 
	elseif zone==2097216 then 
	Duel.MoveSequence(c,6) 
	end 
	Duel.Damage(1-tp,c:GetBaseAttack()/2,REASON_EFFECT)
	end
end







