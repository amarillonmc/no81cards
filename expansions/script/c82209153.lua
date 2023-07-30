--光蝶升华
local m=82209153
local cm=c82209153
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(m,ACTIVITY_SPSUMMON,cm.counterfilter)  
end
function cm.counterfilter(c)  
	return c:IsLevelAbove(1) or c:IsRankAbove(1)
end 
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()
	if chk==0 then return Duel.GetCustomActivityCount(m,tp,ACTIVITY_SPSUMMON)==0 end  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e1,tp)  
end   
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)  
	return not (c:IsLevelAbove(1) or c:IsRankAbove(1))
end  
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)+3
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=ct end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local option
	local options={}
	local optionHints={}
	local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)+3
	Duel.ConfirmDecktop(tp,ct)  
	local g=Duel.GetDecktopGroup(tp,ct)  
	if g:GetCount()>1 then
		local live=false
		if cm.fuscheck(e,tp,eg,ep,ev,re,r,rp,g) then
			live=true
			table.insert(options,0)
			table.insert(optionHints,aux.Stringid(m,0))
		end
		if cm.syncheck(e,tp,eg,ep,ev,re,r,rp,g) then
			live=true
			table.insert(options,1)
			table.insert(optionHints,aux.Stringid(m,1))
		end
		if cm.xyzcheck(e,tp,eg,ep,ev,re,r,rp,g) then
			live=true
			table.insert(options,2)
			table.insert(optionHints,aux.Stringid(m,2))
		end
		if live then
			option=options[Duel.SelectOption(tp,table.unpack(optionHints))+1]
		else
			Duel.ShuffleDeck(tp)
			return
		end
		if option==0 then
			cm.fusop(e,tp,eg,ep,ev,re,r,rp,g)
		elseif option==1 then
			cm.synop(e,tp,eg,ep,ev,re,r,rp,g)
		elseif option==2 then
			cm.xyzop(e,tp,eg,ep,ev,re,r,rp,g)
		end
	end
end



--fusion
function cm.fmatfilter(c)  
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end  
function cm.fgfilter2(g,fc,chkf)
	return fc:CheckFusionMaterial(g,nil,chkf)
end
function cm.fusfilter2(c,e,tp,mg,f,chkf)  
	return c:IsType(TYPE_FUSION) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) 
		and mg:CheckSubGroup(cm.fgfilter2,2,2,c,chkf)
end  
function cm.fuscheck(e,tp,eg,ep,ev,re,r,rp,g)  
	local chkf=tp  
	local mg1=g:Filter(cm.fmatfilter,nil)
	if mg1:GetCount()<2 then return false end
	local res=Duel.IsExistingMatchingCard(cm.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
	if not res then  
		local ce=Duel.GetChainMaterial(tp)  
		if ce~=nil then  
			local fgroup=ce:GetTarget()  
			local mg2=fgroup(ce,e,tp)  
			local mf=ce:GetValue()  
			res=Duel.IsExistingMatchingCard(cm.fusfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,chkf)
		end   
	end  
	return res 
end  
function cm.fusop(e,tp,eg,ep,ev,re,r,rp,g)  
	local chkf=tp  
	local mg1=g:Filter(cm.fmatfilter,nil)  
	local sg1=Duel.GetMatchingGroup(cm.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(cm.fusfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)  
	end  
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then  
		local sg=sg1:Clone()  
		if sg2 then sg:Merge(sg2) end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then  
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)  
			tc:SetMaterial(mat1)  
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) 
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end  
end  



--synchro 
function cm.smatfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeSynchroMaterial()
end
function cm.synfilter(c,sg,tp)
	return c:IsType(TYPE_SYNCHRO) and c:IsSynchroSummonable(nil,sg) and Duel.GetLocationCountFromEx(tp,tp,nil,c)
end
function cm.sgfilter(g,tp)
	return Duel.IsExistingMatchingCard(cm.synfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp)
end
function cm.syncheck(e,tp,eg,ep,ev,re,r,rp,g)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
	local mg=g:Filter(cm.smatfilter,nil,e,tp)
	
	return mg:GetCount()>0 and mg:CheckSubGroup(cm.sgfilter,2,2,tp)
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,g)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Filter(cm.smatfilter,nil,e,tp):SelectSubGroup(tp,cm.sgfilter,false,2,2,tp)
	if (not sg) or sg:GetCount()~=2 then return end
	local tc=sg:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e2)  
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.AdjustAll()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)~=sg:GetCount() then return end
	local tg=Duel.GetMatchingGroup(cm.synfilter,tp,LOCATION_EXTRA,0,nil,og,tp)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		if rg:GetCount()>0 then
			Duel.SynchroSummon(tp,rg:GetFirst(),nil,og)
		end
	end
end



--xyz
function cm.xmatfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeXyzMaterial(nil)
end
function cm.xyzfilter(c,sg,tp)
	return c:IsType(TYPE_XYZ) and c:IsXyzSummonable(sg,2,2) and Duel.GetLocationCountFromEx(tp,tp,nil,c)
end
function cm.xgfilter(g,tp)
	return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g,tp)
end
function cm.xyzcheck(e,tp,eg,ep,ev,re,r,rp,g)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return false end
	local mg=g:Filter(cm.xmatfilter,nil,e,tp)
	
	return mg:GetCount()>0 and mg:CheckSubGroup(cm.xgfilter,2,2,tp)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp,g)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:Filter(cm.xmatfilter,nil,e,tp):SelectSubGroup(tp,cm.xgfilter,false,2,2,tp)
	if (not sg) or sg:GetCount()~=2 then return end
	local tc=sg:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e1)  
			local e2=Effect.CreateEffect(c)  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)  
			tc:RegisterEffect(e2)  
		end
		tc=sg:GetNext()
	end
	Duel.SpecialSummonComplete()
	local og=Duel.GetOperatedGroup()
	Duel.AdjustAll()
	if og:FilterCount(Card.IsLocation,nil,LOCATION_MZONE)~=sg:GetCount() then return end
	local tg=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil,og,tp)
	if tg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rg=tg:Select(tp,1,1,nil)
		if rg:GetCount()>0 then
			Duel.XyzSummon(tp,rg:GetFirst(),og)
		end
	end
end