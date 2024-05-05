--次元接触
function c11560309.initial_effect(c)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)	 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11560309.target)
	e1:SetOperation(c11560309.activate)
	c:RegisterEffect(e1) 
	--remove  
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_REMOVED) 
	e2:SetCountLimit(1,11560309)
	e2:SetCost(c11560309.stcost) 
	e2:SetTarget(c11560309.sttg) 
	e2:SetOperation(c11560309.stop) 
	c:RegisterEffect(e2)
end
c11560309.SetCard_XdMcy=true  
function c11560309.dfilter(c)
	return c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsAbleToDeck()
end
function c11560309.exfil(c)
	return c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c11560309.filter(c,e,tp)
	return c.SetCard_XdMcy 
end
function c11560309.rcheck(tp,g,c)
	return true 
end
function c11560309.rgcheck(g)
	return true 
end
function c11560309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local mg1=Duel.GetRitualMaterial(1-tp):Filter(Card.IsOnField,nil)  
		mg:Merge(mg1)
		local dg=Duel.GetMatchingGroup(c11560309.dfilter,tp,LOCATION_REMOVED,0,nil)
		local xg=Duel.GetMatchingGroup(c11560309.exfil,tp,LOCATION_DECK,0,nil) 
		if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
		dg:Merge(xg) 
		end 
		aux.RCheckAdditional=c11560309.rcheck
		aux.RGCheckAdditional=c11560309.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,c11560309.filter,e,tp,mg,dg,Card.GetLevel,"Greater")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_REMOVED)
end
function c11560309.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local mg1=Duel.GetRitualMaterial(1-tp):Filter(Card.IsOnField,nil)  
	m:Merge(mg1)
	local dg=Duel.GetMatchingGroup(c11560309.dfilter,tp,LOCATION_REMOVED,0,nil)
	local xg=Duel.GetMatchingGroup(c11560309.exfil,tp,LOCATION_DECK,0,nil) 
	if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
	dg:Merge(xg) 
	end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c11560309.rcheck
	aux.RGCheckAdditional=c11560309.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(aux.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,c11560309.filter,e,tp,m,dg,Card.GetLevel,"Greater")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(dg)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_REMOVED)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoDeck(dmat,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		local emat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if emat:GetCount()>0 then
			mat:Sub(emat)
			Duel.Remove(emat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end 
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()  
	if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
	Duel.Hint(HINT_CARD,0,11560310) 
	tc:RegisterFlagEffect(11560309,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(c11560309.descon)
	e1:SetOperation(c11560309.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
	end  
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function c11560309.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(11560309)~=0
end
function c11560309.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c11560309.stcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) 
end  
function c11560309.sttg(e,tp,eg,ep,ev,re,r,rp,chk)   
	local x=0 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,e:GetHandler()) 
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then x=x+1 end 
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then x=x+1 end 
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then x=x+1 end   
	local rg=Duel.GetDecktopGroup(tp,x)  
	if chk==0 then return x>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==x end 
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,x,tp,LOCATION_DECK)
end 
function c11560309.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_REMOVED,0,e:GetHandler()) 
	local x=0 
	if g:IsExists(Card.IsType,1,nil,TYPE_MONSTER) then x=x+1 end 
	if g:IsExists(Card.IsType,1,nil,TYPE_SPELL) then x=x+1 end 
	if g:IsExists(Card.IsType,1,nil,TYPE_TRAP) then x=x+1 end   
	local rg=Duel.GetDecktopGroup(tp,x)  
	if x>0 and rg:FilterCount(Card.IsAbleToRemove,nil)==x then 
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	end 
end 




