--往生的不死鸟 藤原妹红
local s,id,o=GetID()
function s.initial_effect(c)
	--融合召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.fspcon)
    e1:SetCost(s.cost)
	e1:SetTarget(s.fsptg)
	e1:SetOperation(s.fspop)
	c:RegisterEffect(e1)
	--加入手卡	
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.thcon)
    e2:SetCost(s.cost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,s.counterfilter)
end
function s.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or (c:IsType(TYPE_FUSION) and c:IsFaceup())
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
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
function s.fspcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsMainPhase()
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x67b0) and c:IsCanBeFusionMaterial() and c:IsReleasableByEffect()
end
function s.filter1(c,e)
	return c:IsReleasableByEffect() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,mg,f,gc)
	return c:IsType(TYPE_FUSION) and c:IsFusionSummonableCard() and c:CheckFusionMaterial(mg,gc)
    	and (not f or f(c)) and c:IsSetCard(0x67b0) 
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.gcheck(sg)
	return sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function s.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsReleasableByEffect,nil)
        if Duel.GetTurnPlayer()==tp then
			local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
            if mg2:GetCount()>0 then
				mg1:Merge(mg2)
                aux.FCheckAdditional=s.fcheck
				aux.GCheckAdditional=s.gcheck
            end    
		end
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,mg1,nil,c)
        aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,mg3,mf,c)
			end
		end
		return res and c:IsReleasableByEffect()
	end
    local loc=LOCATION_HAND+LOCATION_MZONE
    if Duel.GetTurnPlayer()==tp then
    	loc=LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK
    end
    Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,1,tp,loc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) or not c:IsReleasableByEffect() then return end
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.filter1,nil,e)
    local exmat=false
    if Duel.GetTurnPlayer()==tp then
		local mg2=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_DECK,0,nil)
        if mg2:GetCount()>0 then
			mg1:Merge(mg2)
            exmat=true
        end    
	end
    if exmat then
		aux.FCheckAdditional=s.fcheck
		aux.GCheckAdditional=s.gcheck
	end
    local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,mg1,nil,c)
    aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,mg3,mf,c)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
        Duel.ConfirmCards(1-tp,tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c)
            tc:SetMaterial(mat1)
			Duel.Release(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)			
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,c)      
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
function s.cfilter(c,tp)
	return c:IsType(TYPE_FUSION) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
	end
end