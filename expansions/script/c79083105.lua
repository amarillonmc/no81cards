--圣赐的乐园
function c79083105.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1) 
	--zone 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79083105,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c79083105.zntg) 
	e2:SetOperation(c79083105.znop) 
	c:RegisterEffect(e2) 
	--serch 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(79083105,1))
	e3:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON) 
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,19083105)
	e3:SetCost(c79083105.srcost)
	e3:SetTarget(c79083105.srtg)
	e3:SetOperation(c79083105.srop)
	c:RegisterEffect(e3)
	--cannot target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetValue(aux.tgoval)
	e4:SetCondition(c79083105.idcon)
	c:RegisterEffect(e4)
	--indes 
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(c79083105.efilter)
	e5:SetOwnerPlayer(tp)
	e5:SetCondition(c79083105.idcon)
	c:RegisterEffect(e5)
end
c79083105.named_with_Laterano=true 
function c79083105.zntg(e,tp,eg,ep,ev,re,r,rp,chk) 
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
	 Duel.IsPlayerAffectedByEffect(tp,79084010) 
	if chk==0 then return not b1 end 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
	local zone=Duel.SelectField(tp,1,LOCATION_ONFIELD,0,flag) 
	flag=bit.bor(flag,zone)
	e:SetLabel(zone)
end
function c79083105.znop(e,tp,eg,ep,ev,re,r,rp)
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
function c79083105.rlfil(c,e,tp) 
	local p=c:GetControler()
	if not c:IsAbleToGrave() then return false end 
	if Duel.IsPlayerAffectedByEffect(p,79083110) and c:GetSequence()==0 and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083210) and c:GetSequence()==1 and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083310) and c:GetSequence()==2 and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083410) and c:GetSequence()==3 and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083510) and c:GetSequence()==4 and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083610) and c:GetSequence()==0 and c:IsLocation(LOCATION_MZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(p,79083710) and c:GetSequence()==1 and c:IsLocation(LOCATION_SZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083810) and c:GetSequence()==2 and c:IsLocation(LOCATION_SZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(p,79083910) and c:GetSequence()==3 and c:IsLocation(LOCATION_SZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083010) and c:GetSequence()==4 and c:IsLocation(LOCATION_SZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(p,79084010) and c:GetSequence()==5 and c:IsLocation(LOCATION_SZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and c:GetSequence()==5 and p==tp and c:IsLocation(LOCATION_MZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and c:GetSequence()==6 and p==tp and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084110) and c:GetSequence()==6 and p~=tp and c:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084210) and c:GetSequence()==5 and p~=tp and c:IsLocation(LOCATION_MZONE) then 
	return true 
	else return false end   
end
function c79083105.srcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c79083105.rlfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp) end 
	local g=Duel.SelectMatchingCard(tp,c79083105.rlfil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp) 
	Duel.SendtoGrave(g,REASON_COST)
end
function c79083105.srfilter(c,e,tp,check)
	return (c.named_with_Laterano)
		and (c:IsAbleToHand() or (c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and check and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false)))
end
function c79083105.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	if chk==0 then return Duel.IsExistingMatchingCard(c79083105.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,check) end
end
function c79083105.srop(e,tp,eg,ep,ev,re,r,rp)
	local check=Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c79083105.srfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,check)
	local tc=g:GetFirst()
	if tc then
		if tc:IsAbleToHand() and (not (check and tc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,true,false) and tc:IsType(TYPE_MONSTER) and tc:IsType(TYPE_RITUAL)) or Duel.SelectOption(tp,1190,1152)==0) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,true,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c79083105.idcon(e) 
	local tp=e:GetHandlerPlayer()
	local b1=Duel.IsPlayerAffectedByEffect(tp,79083110) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083210) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083310) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083410) or
	 Duel.IsPlayerAffectedByEffect(tp,79083510) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083610) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083710) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083810) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083910) or 
	 Duel.IsPlayerAffectedByEffect(tp,79083010) or 
	 Duel.IsPlayerAffectedByEffect(tp,79084010) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083110) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083210) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083310) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083410) or
	 Duel.IsPlayerAffectedByEffect(1-tp,79083510) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083610) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083710) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083810) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083910) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79083010) or 
	 Duel.IsPlayerAffectedByEffect(1-tp,79084010) or 
	 Duel.IsPlayerAffectedByEffect(tp,79084110) or
	 Duel.IsPlayerAffectedByEffect(tp,79084210) 
	 return b1 
end
function c79083105.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end


