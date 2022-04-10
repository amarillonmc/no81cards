--圣赐的律法
function c79083107.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)  
	--ritual 
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,79083107) 
	e2:SetCost(c79083107.cost)
	e2:SetTarget(c79083107.target)
	e2:SetOperation(c79083107.activate)
	c:RegisterEffect(e2)  
	--neg 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c79083107.ngcon)  
	e3:SetOperation(c79083107.ngop) 
	c:RegisterEffect(e3) 
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e4:SetTarget(c79083107.xctfil)
	e4:SetValue(aux.tgoval)
	c:RegisterEffect(e4) 
	--xx
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c79083107.actcon)
	e5:SetOperation(c79083107.actop)
	c:RegisterEffect(e5)
	Duel.AddCustomActivityCounter(79083107,ACTIVITY_SPSUMMON,c79083107.counterfilter)
end
c79083107.named_with_Laterano=true 
function c79083107.counterfilter(c)
	return c.named_with_Laterano 
end
function c79083107.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(79083107,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c79083107.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c79083107.splimit(e,c)
	return not c.named_with_Laterano 
end
function c79083107.filter(c,e,tp)
	return c.named_with_Laterano 
end
function c79083107.mfilter(c)
	return c:IsRace(RACE_FAIRY)
end
function c79083107.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c79083107.mfilter,nil)
		local mg2=nil
		return Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,c79083107.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		e:SetLabel(0)
end
function c79083107.activate(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local mg=Duel.GetRitualMaterial(tp):Filter(c79083107.mfilter,nil)
	local mg2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,c79083107.filter,e,tp,mg,mg2,Card.GetLevel,"Greater")
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
		Duel.HintSelection(Group.FromCards(tc))
		if tc:GetSequence()==0 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083110)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)  
		elseif tc:GetSequence()==1 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,2))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083210)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
		elseif tc:GetSequence()==2 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,3))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083310)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)   
		elseif tc:GetSequence()==3 then  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,4))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083410)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
		elseif tc:GetSequence()==4 then 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(79083110,5))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(79083510)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
		end
	end
end 
function c79083107.ngcon(e,tp,eg,ep,ev,re,r,rp) 
	if rp==tp then return false end 
	if Duel.GetFlagEffect(tp,79083107)~=0 then return false end 
	local rc=re:GetHandler() 
	local p=rc:GetControler()
	if Duel.IsPlayerAffectedByEffect(p,79083110) and rc:GetSequence()==0 and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083210) and rc:GetSequence()==1 and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083310) and rc:GetSequence()==2 and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083410) and rc:GetSequence()==3 and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083510) and rc:GetSequence()==4 and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083610) and rc:GetSequence()==0 and rc:IsLocation(LOCATION_MZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(p,79083710) and rc:GetSequence()==1 and rc:IsLocation(LOCATION_SZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083810) and rc:GetSequence()==2 and rc:IsLocation(LOCATION_SZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(p,79083910) and rc:GetSequence()==3 and rc:IsLocation(LOCATION_SZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(p,79083010) and rc:GetSequence()==4 and rc:IsLocation(LOCATION_SZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(p,79084010) and rc:GetSequence()==5 and rc:IsLocation(LOCATION_SZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and rc:GetSequence()==5 and p==tp and rc:IsLocation(LOCATION_MZONE) then 
	return true   
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and rc:GetSequence()==6 and p==tp and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084110) and rc:GetSequence()==6 and p~=tp and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084210) and rc:GetSequence()==5 and p~=tp and rc:IsLocation(LOCATION_MZONE) then 
	return true 
	else return false end	  
end
function c79083107.ngop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.SelectYesNo(tp,aux.Stringid(79083107,0)) then 
	Duel.RegisterFlagEffect(tp,79083107,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,79083107) 
	Duel.NegateEffect(ev) 
	if re:GetHandler():IsAbleToRemove(tp,POS_FACEDOWN) then 
	Duel.Remove(re:GetHandler(),POS_FACEDOWN,REASON_EFFECT)
	end
	end
end
function c79083107.xctfil(e,c) 
	local tp=e:GetHandlerPlayer()
	local p=c:GetControler()
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
function c79083107.actcon(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsPlayerAffectedByEffect(tp,79083610) and c:GetSequence()==0 then 
	return true 
	elseif Duel.IsPlayerAffectedByEffect(tp,79083710) and c:GetSequence()==1 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083810) and c:GetSequence()==2 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083910) and c:GetSequence()==3 then 
	return true  
	elseif Duel.IsPlayerAffectedByEffect(tp,79083010) and c:GetSequence()==4 then 
	return true 
	else return false end 
end
function c79083107.actop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local rc=re:GetHandler() 
	local p=rc:GetControler() 
	local x=0 
	if Duel.IsPlayerAffectedByEffect(p,79083110) and rc:GetSequence()==0 and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083210) and rc:GetSequence()==1 and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083310) and rc:GetSequence()==2 and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083410) and rc:GetSequence()==3 and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083510) and rc:GetSequence()==4 and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083610) and rc:GetSequence()==0 and rc:IsLocation(LOCATION_MZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(p,79083710) and rc:GetSequence()==1 and rc:IsLocation(LOCATION_SZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083810) and rc:GetSequence()==2 and rc:IsLocation(LOCATION_SZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(p,79083910) and rc:GetSequence()==3 and rc:IsLocation(LOCATION_SZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(p,79083010) and rc:GetSequence()==4 and rc:IsLocation(LOCATION_SZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(p,79084010) and rc:GetSequence()==5 and rc:IsLocation(LOCATION_SZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(tp,79084110) and rc:GetSequence()==5 and p==tp and rc:IsLocation(LOCATION_MZONE) then 
	x=1   
	elseif Duel.IsPlayerAffectedByEffect(tp,79084210) and rc:GetSequence()==6 and p==tp and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084110) and rc:GetSequence()==6 and p~=tp and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	elseif Duel.IsPlayerAffectedByEffect(1-tp,79084210) and rc:GetSequence()==5 and p~=tp and rc:IsLocation(LOCATION_MZONE) then 
	x=1 
	else return false end  
	if x==1 then 
	Duel.Hint(HINT_CARD,0,79083107)
	Duel.SetChainLimit(c79083107.chainlm) 
	end 
end
function c79083107.chainlm(e,rp,tp)
	return tp==rp
end






