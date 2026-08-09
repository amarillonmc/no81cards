--炽烈的心之辉 紫茉莉
local s,id,o=GetID()
function s.initial_effect(c)
	--选择效果适用
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)
	e1:SetTarget(s.eftg)
	e1:SetOperation(s.efop)
	c:RegisterEffect(e1)   
	--复制
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.copycon1)
    e2:SetCost(s.copycost)
	e2:SetTarget(s.copytg)
	e2:SetOperation(s.copyop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_END_PHASE)
	e3:SetCondition(s.copycon2)
	c:RegisterEffect(e3)   
end
function s.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function s.filter1(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function s.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x57b0) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function s.eftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
    local chkf=tp
	local mg=Duel.GetMatchingGroup(s.filter0,tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToGrave() and res
    local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id)<2
    else
    	con=Duel.GetFlagEffect(tp,id)<1
    end
	if chk==0 then return con and (b1 or b2) end
    Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_EXTRA)
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,c,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_HAND)
end
function s.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter0),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil)
	local res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
	if not res then
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			local mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			res=Duel.IsExistingMatchingCard(s.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
		end
	end
    local b1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
    local b2=c:IsAbleToGrave() and res
    if not b1 and not b2 then return end    
	if not c:IsRelateToEffect(e) then return end
    local op=aux.SelectFromOptions(tp,
		{b1,1152,1},
		{b2,aux.Stringid(id,4),2})
    if op==1 then
    	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    elseif op==2 then
    	if Duel.SendtoGrave(c,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_GRAVE) then
        	local chkf=tp
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.filter1),tp,LOCATION_GRAVE+LOCATION_HAND,0,nil,e)
			local sg1=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
			local mg3=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(s.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
			end
			if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
					local mat=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
					tc:SetMaterial(mat)
					if mat:IsExists(Card.IsFacedown,1,nil) then
						local cg=mat:Filter(Card.IsFacedown,nil)
						Duel.ConfirmCards(1-tp,cg)
					end
					if mat:IsExists(s.fdfilter,1,nil) then
						local cg=mat:Filter(s.fdfilter,nil)
						Duel.HintSelection(cg)
					end        			                                                                                                          
                    Duel.SendtoDeck(mat,nil,0,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
    				local rg=Duel.GetOperatedGroup()
					local kg=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
					local ct1=kg:FilterCount(Card.IsControler,nil,tp)
					local ct2=kg:FilterCount(Card.IsControler,nil,1-tp)
					if ct1>0 then
						if ct1>1 then
							Duel.SortDecktop(tp,tp,ct1)
						end
					end
					if ct2>0 then
						if ct2>1 then
							Duel.SortDecktop(tp,1-tp,ct2)
						end
					end
    				for i=1,ct1 do
    					if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then break end
        				local ctg1=Duel.GetDecktopGroup(tp,ct1)
    					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        				local mvc1=ctg1:Select(tp,1,1,nil):GetFirst()
        				Duel.MoveSequence(mvc1,SEQ_DECKBOTTOM)
        				ct1=ct1-1
   	 				end	
    				for i=1,ct2 do
    					if not Duel.SelectYesNo(tp,aux.Stringid(id,5)) then break end
        				local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    					Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        				local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        				Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        				ct2=ct2-1
    				end	                            
					Duel.BreakEffect()
					Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
					local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
					local fop=ce:GetOperation()
					fop(ce,e,tp,tc,mat2)
				end
				tc:CompleteProcedure()	
        	end        	                     
        end
    end	
end
function s.fdfilter(c)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() or c:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED)
end
function s.copycon1(e,tp,eg,ep,ev,re,r,rp)
	return not cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.copycon2(e,tp,eg,ep,ev,re,r,rp)
	return cor.IsCanBeQuickEffect(e:GetHandler(),tp,16191870)
end
function s.copyfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0x57b0) and c:CheckActivateEffect(false,true,false)~=nil
end
function s.costfilter(c,e,tp)
	return c:IsAbleToDeckOrExtraAsCost() 
    	and Duel.IsExistingMatchingCard(s.copyfilter,tp,LOCATION_GRAVE,0,1,c)
end
function s.copycost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,c,e,tp) 
        and c:IsAbleToDeckAsCost() end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,c,e,tp)
	g:AddCard(c)
    Duel.HintSelection(g)
    Duel.SendtoDeck(g,nil,0,REASON_COST)
    Duel.ConfirmCards(1-tp,c)
    local rg=Duel.GetOperatedGroup()
	local kg=rg:Filter(Card.IsLocation,nil,LOCATION_DECK)
	local ct1=kg:FilterCount(Card.IsControler,nil,tp)
	local ct2=kg:FilterCount(Card.IsControler,nil,1-tp)
	if ct1>0 then
		if ct1>1 then
			Duel.SortDecktop(tp,tp,ct1)
		end
	end
	if ct2>0 then
		if ct2>1 then
			Duel.SortDecktop(tp,1-tp,ct2)
		end
	end
    for i=1,ct1 do
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,2)) then break end
        local ctg1=Duel.GetDecktopGroup(tp,ct1)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        local mvc1=ctg1:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc1,SEQ_DECKBOTTOM)
        ct1=ct1-1
    end	
    for i=1,ct2 do
    	if not Duel.SelectYesNo(tp,aux.Stringid(id,5)) then break end
        local ctg2=Duel.GetDecktopGroup(1-tp,ct2)
    	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,3))
        local mvc2=ctg2:Select(tp,1,1,nil):GetFirst()
        Duel.MoveSequence(mvc2,SEQ_DECKBOTTOM)
        ct2=ct2-1
    end	
end
function s.copytg(e,tp,eg,ep,ev,re,r,rp,chk)
    local con
	if Duel.IsPlayerAffectedByEffect(tp,16191885) then
    	con=Duel.GetFlagEffect(tp,id+o)<2
    else
    	con=Duel.GetFlagEffect(tp,id+o)<1
    end
	if chk==0 then return con end
    Duel.RegisterFlagEffect(tp,id+o,RESET_PHASE+PHASE_END,0,1)
end
function s.copyop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.copyfilter),tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
	if tc then
    	Duel.HintSelection(Group.FromCards(tc))
        local te,ceg,cep,cev,cre,cr,crp=tc:CheckActivateEffect(false,true,true)
        e:SetProperty(te:GetProperty())
        local tg=te:GetTarget()
		if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
        local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end        
    end
end
--
Corflos={}
cor=Corflos
function Corflos.RanuticusFilter(c)
	return (c:IsLocation(LOCATION_MZONE) and c:IsAllTypes(TYPE_XYZ+TYPE_MONSTER) or c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER))
    	and c:IsOriginalSetCard(0x57b0)
end
function Corflos.IsCanBeQuickEffect(c,tp,code)
	return Duel.IsPlayerAffectedByEffect(tp,code)~=nil and Corflos.RanuticusFilter~=nil and Corflos.RanuticusFilter(c)
end