--圣赐的执行
function c79083108.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79083108) 
	e1:SetCost(c79083108.accost)
	e1:SetTarget(c79083108.actg)
	e1:SetOperation(c79083108.acop)
	c:RegisterEffect(e1) 
	--remove 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCountLimit(1,19083108)
	e2:SetCost(aux.bfgcost) 
	e2:SetTarget(c79083108.rmtg)
	e2:SetOperation(c79083108.rmop)
	c:RegisterEffect(e2)
end
c79083108.named_with_Laterano=true 
function c79083108.tdfil(c) 
	return c:IsAbleToDeckAsCost() and c.named_with_Laterano 
end
function c79083108.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79083108.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,nil) end 
	local g=Duel.SelectMatchingCard(tp,c79083108.tdfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,5,5,nil) 
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c79083108.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c79083108.acop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT) 
	local xp=0 
	if Duel.IsPlayerAffectedByEffect(tp,79083610) and c:GetSequence()==0 then 
	xp=1  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083710) and c:GetSequence()==1 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083810) and c:GetSequence()==2 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083910) and c:GetSequence()==3 then 
	xp=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083010) and c:GetSequence()==4 then 
	xp=1 
	end
	local b1=Duel.IsPlayerAffectedByEffect(tp,79083110) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083210) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083310) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083410) and
	 Duel.IsPlayerAffectedByEffect(tp,79083510) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083610) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083710) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083810) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083910) and 
	 Duel.IsPlayerAffectedByEffect(tp,79083010) and 
	 Duel.IsPlayerAffectedByEffect(tp,79084010) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083110) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083210) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083310) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083410) and
	 Duel.IsPlayerAffectedByEffect(1-tp,79083510) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083610) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083710) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083810) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083910) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083010) and 
	 Duel.IsPlayerAffectedByEffect(1-tp,79084010) and 
	 Duel.IsPlayerAffectedByEffect(tp,79084110) and
	 Duel.IsPlayerAffectedByEffect(tp,79084210)
	if xp==1 and not b1 and Duel.SelectYesNo(tp,aux.Stringid(79083108,0)) then 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
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
	if Duel.IsPlayerAffectedByEffect(tp,79083610) then 
	flag=bit.bor(flag,256) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083710) then 
	flag=bit.bor(flag,512) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083810) then 
	flag=bit.bor(flag,1024) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083910) then 
	flag=bit.bor(flag,2048) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083010) then 
	flag=bit.bor(flag,4096) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083010) then 
	flag=bit.bor(flag,8192) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79083110) then 
	flag=bit.bor(flag,65536*1) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083210) then 
	flag=bit.bor(flag,65536*2) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083310) then 
	flag=bit.bor(flag,65536*4) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083410) then 
	flag=bit.bor(flag,65536*8) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083510) then 
	flag=bit.bor(flag,65536*16) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083610) then 
	flag=bit.bor(flag,65536*256) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083710) then 
	flag=bit.bor(flag,65536*512) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083810) then 
	flag=bit.bor(flag,65536*1024) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083910) then 
	flag=bit.bor(flag,65536*2048) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79083010) then 
	flag=bit.bor(flag,65536*4096) 
	end
	if Duel.IsPlayerAffectedByEffect(1-tp,79084010) then 
	flag=bit.bor(flag,65536*8192) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79084110) then 
	flag=bit.bor(flag,4194336) 
	end
	if Duel.IsPlayerAffectedByEffect(tp,79084210) then 
	flag=bit.bor(flag,2097216) 
	end 
	local zone=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,flag) 
	if zone==1 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083110)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==2 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083210)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)  
	elseif zone==4 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083310)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)  
	elseif zone==8 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083410)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==16 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083510)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==256 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,6))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083610)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==512 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,7))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083710)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==1024 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,8))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083810)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==2048 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,9))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083910)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==4096 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,10))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083010)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==8192 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,11))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79084010)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==65536*1 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083110)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*2 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083210)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*4 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083310)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*8 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083410)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*16 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083510)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp)  
	elseif zone==65536*256 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,6))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083610)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*512 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,7))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083710)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*1024 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,8))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083810)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*2048 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,9))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083910)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*4096 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,10))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083010)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp) 
	elseif zone==65536*8192 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,11))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79084010)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,1-tp)
	elseif zone==4194336 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,12))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79084110)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	elseif zone==2097216 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,13))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79084210)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	end
	end
end
function c79083108.ckfil(c) 
	return c:IsType(TYPE_RITUAL) and c.named_with_Laterano 
end
function c79083108.rmfil(c) 
	return c:GetSummonLocation()==LOCATION_EXTRA and c:IsAbleToRemove() and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c79083108.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79083108.ckfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c79083108.rmfil,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.GetMatchingGroup(c79083108.rmfil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0) 
	Duel.SetChainLimit(c79083108.chlimit)
end
function c79083108.chlimit(e,ep,tp) 
	local c=e:GetHandler() 
	local p=c:GetControler()
	if Duel.IsPlayerAffectedByEffect(p,79083110) and c:GetSequence()==0 and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083210) and c:GetSequence()==1 and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083310) and c:GetSequence()==2 and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083410) and c:GetSequence()==3 and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083510) and c:GetSequence()==4 and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083610) and c:GetSequence()==0 and c:IsLocation(LOCATION_MZONE) then 
	return false   
	elseif Duel.IsPlayerAffectedByEffect(p,79083710) and c:GetSequence()==1 and c:IsLocation(LOCATION_SZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083810) and c:GetSequence()==2 and c:IsLocation(LOCATION_SZONE) then 
	return false   
	elseif Duel.IsPlayerAffectedByEffect(p,79083910) and c:GetSequence()==3 and c:IsLocation(LOCATION_SZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(p,79083010) and c:GetSequence()==4 and c:IsLocation(LOCATION_SZONE) then 
	return false   
	elseif Duel.IsPlayerAffectedByEffect(p,79084010) and c:GetSequence()==5 and c:IsLocation(LOCATION_SZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and c:GetSequence()==5 and p==tp and c:IsLocation(LOCATION_MZONE) then 
	return false   
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and c:GetSequence()==6 and p==tp and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084110) and c:GetSequence()==6 and p~=tp and c:IsLocation(LOCATION_MZONE) then 
	return false 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084210) and c:GetSequence()==5 and p~=tp and c:IsLocation(LOCATION_MZONE) then 
	return false 
	else return true end 
end
function c79083108.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c79083108.rmfil,tp,0,LOCATION_MZONE,nil) 
	if g:GetCount()>0 then 
	Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end 
end












