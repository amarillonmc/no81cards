--勒比卢的炎咆
function c11560320.initial_effect(c)
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
	e1:SetTarget(c11560320.target)
	e1:SetOperation(c11560320.activate)
	c:RegisterEffect(e1)   
	--sp and to deck 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetRange(LOCATION_REMOVED) 
	e2:SetCountLimit(1,11560320) 
	e2:SetCost(c11560320.sptdcost) 
	e2:SetTarget(c11560320.sptdtg) 
	e2:SetOperation(c11560320.sptdop) 
	c:RegisterEffect(e2) 
end
c11560320.SetCard_XdMcy=true  
function c11560320.dfilter(c)
	return c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsAbleToDeck()
end
function c11560320.exfil(c)
	return c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c11560320.filter(c,e,tp)
	return c.SetCard_XdMcy 
end
function c11560320.rcheck(tp,g,c)
	return true 
end
function c11560320.rgcheck(g)
	return true 
end
function c11560320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local dg=Duel.GetMatchingGroup(c11560320.dfilter,tp,LOCATION_REMOVED,0,nil) 
		local xg=Duel.GetMatchingGroup(c11560320.exfil,tp,LOCATION_DECK,0,nil) 
		if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
		dg:Merge(xg) 
		end 
		aux.RCheckAdditional=c11560320.rcheck
		aux.RGCheckAdditional=c11560320.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,nil,c11560320.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c11560320.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c11560320.dfilter,tp,LOCATION_REMOVED,0,nil)
	local xg=Duel.GetMatchingGroup(c11560320.exfil,tp,LOCATION_DECK,0,nil) 
	if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
	dg:Merge(xg) 
	end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c11560320.rcheck
	aux.RGCheckAdditional=c11560320.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_REMOVED,0,1,1,nil,c11560320.filter,e,tp,m,dg,Card.GetLevel,"Greater")
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
	tc:RegisterFlagEffect(11560320,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCondition(c11560320.descon)
		e1:SetOperation(c11560320.desop)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(tc)
		Duel.RegisterEffect(e1,tp)
	end  
	--if Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=20 and e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,11560320)==0 and Duel.SelectYesNo(tp,aux.Stringid(11560320,0)) then 
	--e:GetHandler():CancelToGrave() 
	--Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) 
	--Duel.RegisterFlagEffect(tp,11560320,RESET_PHASE+PHASE_END,0,1)
	--end   
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil 
end
function c11560320.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(11560320)~=0
end
function c11560320.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c11560320.sptdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end 
function c11560320.mgfil(c,e,tp) 
	return c:IsType(TYPE_MONSTER) and c.SetCard_XdMcy and c:IsCanBeEffectTarget(e)  
end 
function c11560320.espfil(c,e,tp,mg) 
	if Duel.GetLocationCountFromEx(tp,tp,mg,c)<=0 then return false end 
	if not c.SetCard_XdMcy then return false end 
	if not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return false end 
	if c:IsType(TYPE_SYNCHRO) then 
		return c:IsSynchroSummonable(nil,mg) 
	elseif c:IsType(TYPE_LINK) then 
		return c:IsLinkSummonable(mg)
	elseif c:IsType(TYPE_FUSION) then 
		return c:CheckFusionMaterial(mg)
	elseif c:IsType(TYPE_XYZ) then 
		return c:IsXyzSummonable(mg) 
	else 
		return false 
	end  
end 
function c11560320.mgck(g,e,tp) 
	return Duel.IsExistingMatchingCard(c11560320.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,g) 
end 
function c11560320.sptdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c11560320.mgfil,tp,LOCATION_REMOVED,0,nil,e,tp)
	if chk==0 then return g:CheckSubGroup(c11560320.mgck,1,5,e,tp) end 
	local mg=g:SelectSubGroup(tp,c11560320.mgck,false,1,5,e,tp) 
	Duel.SetTargetCard(mg) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,mg,mg:GetCount(),0,0) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end 
function c11560320.sptdop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local mg=g:Filter(Card.IsRelateToEffect,nil,e)
	if mg:GetCount()==g:GetCount() and Duel.IsExistingMatchingCard(c11560320.espfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg) then 
		local tc=Duel.SelectMatchingCard(tp,c11560320.espfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,mg):GetFirst() 
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then 
			Duel.BreakEffect() 
			Duel.SendtoDeck(mg,nil,2,REASON_EFFECT)
		end   
	end 
end 





