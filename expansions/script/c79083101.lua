--圣赐乐土 莫斯提马
function c79083101.initial_effect(c)
	c:EnableReviveLimit()
	--attribute
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_RACE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(RACE_FIEND)
	c:RegisterEffect(e0)   
	--zone 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,79083101)
	e1:SetTarget(c79083101.zntg)
	e1:SetOperation(c79083101.znop)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c79083101.regcon)
	e2:SetOperation(c79083101.regop)
	c:RegisterEffect(e2)
	--to hand 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE) 
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetTarget(c79083101.reptg)
	e3:SetValue(c79083101.repval)
	c:RegisterEffect(e3)
end
c79083101.named_with_Laterano=true 
function c79083101.zntg(e,tp,eg,ep,ev,re,r,rp,chk) 
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
	if chk==0 then return not b1 end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
	local zone=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,flag) 
	flag=bit.bor(flag,zone)
	e:SetLabel(zone)
	local x=0 
	while x<2 and not b1 do 
	 if Duel.SelectYesNo(tp,aux.Stringid(79083101,0)) then 
	 if x==0 then 
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
	 flag0=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,flag)
	 flag=bit.bor(flag,flag0)
	 elseif x==1 then   
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
	 flag1=Duel.SelectField(tp,1,LOCATION_ONFIELD,LOCATION_ONFIELD,flag)
	 flag=bit.bor(flag,flag1)
	 end
	 x=x+1
	 else
	 x=2 
	 end 
	end 
	if flag0~=nil then 
	e:SetLabel(zone,flag0)
	end 
	if flag1~=nil then 
	e:SetLabel(zone,flag0,flag1)
	end 
end
function c79083101.znop(e,tp,eg,ep,ev,re,r,rp)
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
	x=x-1
	end 
end
function c79083101.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler().named_with_Laterano 
end
function c79083101.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--remove
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79083101,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0xfe,0xff)
	e2:SetValue(LOCATION_REMOVED)
	e2:SetCondition(c79083101.rmcon)
	e2:SetTarget(c79083101.rmtg)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c79083101.rmcon)
	e3:SetValue(c79083101.actlimit)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e3) 
	if re:GetHandler():IsCode(79083100) then 
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083101,3))
	Duel.Hint(24,0,aux.Stringid(79083101,4))
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79083100,3))
	Duel.Hint(24,0,aux.Stringid(79083100,4))
	if Duel.GetFlagEffect(tp,19083101)==0 then 
	Duel.HintSelection(Group.FromCards(c)) 
	Duel.Hint(HINT_CARD,0,79083101)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,0))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,0))
	Duel.Hint(HINT_CARD,0,79083101)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,1))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,1))
	Duel.Hint(HINT_CARD,0,79083100)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,2))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,2))
	Duel.Hint(HINT_CARD,0,79083101)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,3))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,3))
	Duel.RegisterFlagEffect(tp,19083101,0,0,0)
	elseif Duel.GetFlagEffect(tp,19083101)==1 then 
	Duel.Hint(HINT_CARD,0,79083101)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,4))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,4))
	Duel.Hint(HINT_CARD,0,79083100)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,5))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,5))
	Duel.Hint(HINT_CARD,0,79083101)
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79083111,6))
	Duel.Hint(HINT_MESSAGE,1,aux.Stringid(79083111,6))
	Duel.RegisterFlagEffect(tp,19083101,0,0,0)
	end
	end
end
function c79083101.rmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if Duel.IsPlayerAffectedByEffect(tp,79083110) and c:GetSequence()==0  then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083210) and c:GetSequence()==1 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083310) and c:GetSequence()==2 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083410) and c:GetSequence()==3 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083510) and c:GetSequence()==4 then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and c:GetSequence()==5 then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and c:GetSequence()==6 then 
	return true  
	else return false end 
end
function c79083101.rmtg(e,c)
	return c:GetOwner()~=e:GetHandlerPlayer()
end
function c79083101.actlimit(e,re,tp)
	return re:GetHandler():IsLocation(LOCATION_REMOVED)
end
function c79083101.rlfil(c,e,tp) 
	local p=c:GetControler()
	if not c:IsReleasable() then return false end 
	if Duel.IsPlayerAffectedByEffect(p,79083110) and c:GetSequence()==0 then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083210) and c:GetSequence()==1 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(p,79083310) and c:GetSequence()==2 then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083410) and c:GetSequence()==3 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(p,79083510) and c:GetSequence()==4 then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and c:GetSequence()==5 and p==tp then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and c:GetSequence()==6 and p==tp then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084110) and c:GetSequence()==6 and p~=tp then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084210) and c:GetSequence()==5 and p~=tp then 
	return true   
	else return false end   
end
function c79083101.reptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler() 
	local p=c:GetControler()
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
	if chk==0 then return xp==1 and eg:IsContains(c) and Duel.IsExistingMatchingCard(c79083101.rlfil,p,LOCATION_MZONE,LOCATION_MZONE,1,c,e,p) and c:GetDestination()~=LOCATION_HAND and Duel.GetFlagEffect(tp,79083101)==0 end
	if Duel.SelectYesNo(tp,aux.Stringid(79083101,2)) then 
	Duel.Hint(HINT_CARD,0,79083101)
	local g=Duel.SelectMatchingCard(p,c79083101.rlfil,p,LOCATION_MZONE,LOCATION_MZONE,1,1,c,e,p) 
	Duel.Release(g,REASON_EFFECT)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_HAND)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			c:RegisterFlagEffect(79083101,RESET_EVENT+0x1de0000+RESET_PHASE+PHASE_END,0,1) 
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e1:SetCode(EVENT_TO_HAND)
		e1:SetCountLimit(1)
		e1:SetCondition(c79083101.thcon)
		e1:SetOperation(c79083101.thop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	 Duel.RegisterFlagEffect(tp,79083101,RESET_PHASE+PHASE_END,0,1)
		return true
	else return false end
end
function c79083101.repval(e,c)
	return false
end
function c79083101.thfilter(c)
	return c:GetFlagEffect(79083101)~=0
end
function c79083101.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79083101.thfilter,1,nil)
end
function c79083101.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c79083101.thfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end

