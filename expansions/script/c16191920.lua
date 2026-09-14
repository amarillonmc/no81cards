--往生的魔住持 圣白莲
local s,id,o=GetID()
function s.initial_effect(c)
	--卡组检索
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RELEASE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
    e1:SetCost(s.thcost)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	--融合召唤    
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+o)
    e2:SetCost(s.spcost)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
    Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_FUSION) and c:IsFaceup())
end
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsType(TYPE_FUSION) and c:IsLocation(LOCATION_EXTRA)
end
function s.thfilter(c)
	return c:IsSetCard(0x67b0) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.fselect(g,mc,hg)
	return g:IsContains(mc) and g:FilterCount(Card.IsSetCard,nil,0x67b0)<=hg:GetCount()
end    
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
    local hg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return rg:GetCount()>0 and hg:GetCount()>0 and c:IsReleasableByEffect()
    	and rg:CheckSubGroup(s.fselect,2,2,c,hg) end   
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,rg,2,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    if not c:IsRelateToEffect(e) or not c:IsReleasableByEffect() then return end
	local rg=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
    local hg=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK,0,nil)
    if hg:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,s.fselect,false,2,2,c,hg)
    if not sg then return end
    Duel.HintSelection(sg)
    if Duel.Release(sg,REASON_EFFECT)<=0 then return end
    local oc=Duel.GetOperatedGroup():FilterCount(Card.IsSetCard,nil,0x67b0)
    if oc<=0 or hg:GetCount()<oc then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local tg=hg:Select(tp,oc,oc,nil)
    if not tg then return end
    Duel.SendtoHand(tg,nil,REASON_EFFECT)
    Duel.ConfirmCards(1-tp,tg)
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() and Duel.GetCustomActivityCount(id,tp,ACTIVITY_SPSUMMON)==0 end
    Duel.SendtoDeck(c,nil,2,REASON_COST)
    Duel.ConfirmCards(1-tp,c)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x67b0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.filter1(c,e)
	return c:IsReleasableByEffect() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,mg,f)
	return c:IsType(TYPE_FUSION) and c:IsFusionSummonableCard() and c:CheckFusionMaterial(mg)
    	and (not f or f(c)) and c:IsSetCard(0x67b0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	local c=e:GetHandler()
    	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
		local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,mg1,nil)
		local mg2=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg2=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,mg2,mf)
		end
		if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
			local tc=sg:Select(tp,1,1,nil):GetFirst()
        	Duel.ConfirmCards(1-tp,tc)
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1)
				tc:SetMaterial(mat1)
				Duel.Release(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)            	
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg2)
				tc:SetMaterial(mat2)
            	Duel.RegisterFlagEffect(tp,id,0,0,0)
				Duel.Remove(mat2,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)            
			end
        	if tc then        	    
        		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,3))
        		local e1=Effect.CreateEffect(c)
        		e1:SetDescription(aux.Stringid(id,2))
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
				e1:SetCountLimit(1)
				e1:SetLabel(Duel.GetTurnCount())
        		e1:SetLabelObject(tc)
				e1:SetCondition(s.exspcon)
				e1:SetOperation(s.exspop)
				if Duel.GetCurrentPhase()<=PHASE_STANDBY then
					e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
				else
					e1:SetReset(RESET_PHASE+PHASE_STANDBY)
				end
				Duel.RegisterEffect(e1,tp)        	
       		end     
        end    
	end
end
function s.exspcon(e,tp,eg,ep,ev,re,r,rp)
	local fc=e:GetLabelObject()
	return Duel.GetTurnCount()~=e:GetLabel() and fc and Duel.GetLocationCountFromEx(tp,tp,nil,fc)>0
    	and fc:GetFlagEffect(id)>0 and fc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
end
function s.exspop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
    local fc=e:GetLabelObject()
    fc:ResetFlagEffect(id)
    if fc then
		Duel.SpecialSummon(fc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
        if Duel.GetFlagEffect(tp,id)>0 then
        	Duel.ResetFlagEffect(tp,id)
        	fc:RegisterFlagEffect(id+o,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetLabelObject(fc)
			e1:SetCondition(s.regcon)
			e1:SetOperation(s.regop)
			e1:SetCountLimit(1)
			Duel.RegisterEffect(e1,tp)            
        end   
    	fc:CompleteProcedure()
    end 
end
function s.regcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(id+o)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function s.regop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
end