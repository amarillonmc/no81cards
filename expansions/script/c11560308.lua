--次元超越
function c11560308.initial_effect(c)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e0)	 
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c11560308.target)
	e1:SetOperation(c11560308.activate)
	c:RegisterEffect(e1) 
	--set 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_REMOVED) 
	e2:SetCountLimit(1,11560308)
	e2:SetCost(c11560308.stcost) 
	e2:SetTarget(c11560308.sttg) 
	e2:SetOperation(c11560308.stop) 
	c:RegisterEffect(e2)
end
c11560308.SetCard_XdMcy=true  
function c11560308.dfilter(c)
	return c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsAbleToDeck()
end
function c11560308.exfil(c)
	return c.SetCard_XdMcy and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function c11560308.filter(c,e,tp)
	return c.SetCard_XdMcy 
end
function c11560308.rcheck(tp,g,c)
	return true 
end
function c11560308.rgcheck(g)
	return true 
end
function c11560308.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp) 
		local dg=Duel.GetMatchingGroup(c11560308.dfilter,tp,LOCATION_REMOVED,0,nil) 
		local xg=Duel.GetMatchingGroup(c11560308.exfil,tp,LOCATION_DECK,0,nil) 
		if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
		dg:Merge(xg) 
		end 
		aux.RCheckAdditional=c11560308.rcheck
		aux.RGCheckAdditional=c11560308.rgcheck
		local res=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,c11560308.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c11560308.activate(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c11560308.dfilter,tp,LOCATION_REMOVED,0,nil)
	local xg=Duel.GetMatchingGroup(c11560308.exfil,tp,LOCATION_DECK,0,nil) 
	if Duel.IsPlayerAffectedByEffect(tp,11560310) then 
	dg:Merge(xg) 
	end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c11560308.rcheck
	aux.RGCheckAdditional=c11560308.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,c11560308.filter,e,tp,m,dg,Card.GetLevel,"Equal")
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
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
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
	tc:RegisterFlagEffect(11560308,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCondition(c11560308.descon)
	e1:SetOperation(c11560308.desop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabelObject(tc)
	Duel.RegisterEffect(e1,tp)
	end  
	--if Duel.GetFieldGroupCount(tp,LOCATION_REMOVED,0)>=20 and e:GetHandler():IsAbleToHand() and Duel.GetFlagEffect(tp,11560308)==0 and Duel.SelectYesNo(tp,aux.Stringid(11560308,0)) then 
	--e:GetHandler():CancelToGrave() 
	--Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT) 
	--Duel.RegisterFlagEffect(tp,11560308,RESET_PHASE+PHASE_END,0,1)
	--end   
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	--local e1=Effect.CreateEffect(e:GetHandler())
	--e1:SetType(EFFECT_TYPE_FIELD)
	--e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e1:SetTargetRange(1,0)
	--e1:SetTarget(c11560308.splimit)
	--e1:SetReset(RESET_PHASE+PHASE_END)
	--Duel.RegisterEffect(e1,tp)
end
function c11560308.splimit(e,c)
	return not c.SetCard_XdMcy 
end
function c11560308.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:GetFlagEffect(11560308)~=0
end
function c11560308.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end
function c11560308.stcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end 
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST) 
end 
function c11560308.stfil(c)
	return c.SetCard_XdMcy and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function c11560308.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11560308.stfil,tp,LOCATION_DECK,0,1,nil) end 
end 
function c11560308.stop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c11560308.stfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst()) 
	local tc=g:GetFirst() 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1,true)   
	end
end



