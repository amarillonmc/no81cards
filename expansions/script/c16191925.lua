--往生的月之智 八意永琳
local s,id,o=GetID()
function s.initial_effect(c)
	--特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
    e1:SetCost(s.cost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--融合召唤	
    local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCountLimit(1,id+o)
    e2:SetCost(s.cost)
	e2:SetTarget(s.fsptg)
	e2:SetOperation(s.fspop)
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
function s.confilter(c)
	return c:IsSetCard(0x67b0) and not c:IsCode(id) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.confilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
    if e:GetActivateLocation()==LOCATION_GRAVE then
    	e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DRAW)
        Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_ONFIELD)
    else
    	e:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
    end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
    	local b1=Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_FUSION)
        	and Duel.IsPlayerCanDraw(tp,1)
        local b2=Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil)
        	and c:IsSummonLocation(LOCATION_GRAVE)
        if b1 and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then
    		Duel.BreakEffect()
        	Duel.Draw(tp,1,REASON_EFFECT)
        end
  		if b2 then
        	Duel.BreakEffect()
        	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
			if g:GetCount()>0 then
        		Duel.HintSelection(g)
				Duel.SendtoGrave(g,REASON_EFFECT)
            end       
		end
	end
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function s.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and not c:IsImmuneToEffect(e) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function s.filter2(c,mg,f)
	return c:IsType(TYPE_FUSION) and c:IsFusionSummonableCard() and c:CheckFusionMaterial(mg)
    	and (not f or f(c)) and c:IsSetCard(0x67b0)
end
function s.fsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_GRAVE,0,nil)
		local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,mg1,nil)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,mg2,mf)
			end
		end
		return res
	end
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.fspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE,0,nil,e)
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
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
        Duel.ConfirmCards(1-tp,tc)
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1)            
			tc:SetMaterial(mat1)
            Duel.HintSelection(mat1)
			Duel.SendtoDeck(mat1,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)            
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