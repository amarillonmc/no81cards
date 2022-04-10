--圣赐的寻道
function c79083106.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,79083106)
	e1:SetTarget(c79083106.target)
	e1:SetOperation(c79083106.activate)
	c:RegisterEffect(e1) 
	--zone 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,19083106)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c79083106.zntg)
	e2:SetOperation(c79083106.znop)
	c:RegisterEffect(e2)
end
c79083106.named_with_Laterano=true 
function c79083106.filter(c,e,tp)
	return c:IsRace(RACE_FAIRY)
end
function c79083106.cfilter(c)
	return c:IsFaceup() and c.named_with_Laterano 
end
function c79083106.mfilter(c)
	return c.named_with_Laterano 
end
function c79083106.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
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
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c79083106.mfilter,nil)
		local mg2=nil
		if xp==1 then
			mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c79083106.mfilter)
		end
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c79083106.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if xp==1 then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,LOCATION_GRAVE)
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function c79083106.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp):Filter(c79083106.mfilter,nil)
	local mg2=nil
	if e:GetLabel()==1 then
		mg2=Duel.GetMatchingGroup(aux.RitualExtraFilter,tp,LOCATION_GRAVE,0,nil,c79083106.mfilter)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c79083106.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if mg2 then
			mg:Merge(mg2)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure() 
		if tc.named_with_Laterano then 
		Duel.HintSelection(Group.FromCards(tc))
		if tc:GetSequence()==0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083210)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)  
		elseif tc:GetSequence()==1 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083110)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083310)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)  
		elseif tc:GetSequence()==2 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083210)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)   
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083410)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
		elseif tc:GetSequence()==3 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083310)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083510)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
		elseif tc:GetSequence()==4 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083410)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
		end
		end
	end
end
function c79083106.zntg(e,tp,eg,ep,ev,re,r,rp,chk) 
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
	local zone=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,flag) 
	flag=bit.bor(flag,zone)
	e:SetLabel(zone)
	local x=0 
	while x<1 and not b1 do 
	 if Duel.SelectYesNo(tp,aux.Stringid(79083101,0)) then 
	 if x==0 then 
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79083104,0))
	 flag0=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,flag)
	 flag=bit.bor(flag,flag0)
	 end
	 x=x+1
	 else
	 x=1 
	 end 
	end 
	if flag0~=nil then 
	e:SetLabel(zone,flag0)
	end 
end
function c79083106.znop(e,tp,eg,ep,ev,re,r,rp)
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
	if zone==65536*1 then  
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

