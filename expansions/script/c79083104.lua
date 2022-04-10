--圣赐乐土 蕾缪乐
function c79083104.initial_effect(c)
	c:EnableReviveLimit()
	--zone and SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,79083104)
	e1:SetCost(c79083104.zncost)
	e1:SetTarget(c79083104.zntg)
	e1:SetOperation(c79083104.znop)
	c:RegisterEffect(e1) 
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79083104,1))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79083104)
	e2:SetCondition(c79083104.discon)
	e2:SetCost(c79083104.discost)
	e2:SetTarget(c79083104.distg)
	e2:SetOperation(c79083104.disop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(79083104,ACTIVITY_SPSUMMON,c79083104.counterfilter)
end
c79083104.named_with_Laterano=true 
function c79083104.counterfilter(c)
	return c.named_with_Laterano 
end
function c79083104.zncost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(79083104,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79083104.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79083104.splimit(e,c)
	return not c.named_with_Laterano 
end
function c79083104.zntg(e,tp,eg,ep,ev,re,r,rp,chk) 
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
	if chk==0 then return not b1 and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
	local zone=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,flag) 
	e:SetLabel(zone) 
end
function c79083104.znop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local zone,flag0,flag1=e:GetLabel()
	local x=3 
	while x>0 do  
	if x==3 then 
	if zone==nil then return end 
	elseif x==2 then 
	if flag0==nil then return end 
	zone=flag0 
	elseif x==1 then 
	if flag1==nil then return end 
	zone=flag1 
	end
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
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP,zone) 
	c:RegisterFlagEffect(79083104,RESET_EVENT+RESETS_STANDARD,0,1)
	x=x-1
	end 
end
function c79083104.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c79083104.ctfil(c)
	return c:IsAbleToDeckAsCost() and c.named_with_Laterano 
end
function c79083104.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79083104.ctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79083104.ctfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil) 
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
function c79083104.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendtoDeck(tp,re:GetHandler()) and e:GetHandler():GetFlagEffect(79083104)==0 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c79083104.disop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then 
	if re:GetHandler():IsStatus(STATUS_LEAVE_CONFIRMED) then 
	re:GetHandler():CancelToGrave()
	end
		Duel.SendtoDeck(eg,nil,0,REASON_EFFECT) 
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
	if xp==1 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(79083104,1)) then 
	Duel.Draw(tp,1,REASON_EFFECT)
	end
	end 
end



