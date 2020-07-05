local m=82206028
local cm=_G["c"..m]
cm.name="植占师8-月亮"
function cm.initial_effect(c)
	--spsummon  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetRange(LOCATION_HAND)  
	e1:SetCountLimit(1,m)  
	e1:SetTarget(cm.target)  
	e1:SetOperation(cm.operation)  
	c:RegisterEffect(e1) 
	--to hand  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,1))  
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_TO_GRAVE)  
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCountLimit(1,82216028)  
	e3:SetTarget(cm.thtg)  
	e3:SetOperation(cm.thop)  
	c:RegisterEffect(e3)	   
end
function cm.filter1(c,e)  
	return c:IsLocation(LOCATION_HAND) and not c:IsImmuneToEffect(e)  
end  
function cm.filter2(c,e,tp,m,f,gc,chkf)  
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x129d) and (not f or f(c))  
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)  
end  
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	local c=e:GetHandler()  
	if chk==0 then  
		local chkf=tp  
		local mg1=Duel.GetFusionMaterial(tp):Filter(Card.IsLocation,nil,LOCATION_HAND)  
		local res=Duel.GetLocationCountFromEx(tp)>0  
			and Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,c,chkf)  
		if not res then  
			local ce=Duel.GetChainMaterial(tp)  
			if ce~=nil then  
				local fgroup=ce:GetTarget()  
				local mg2=fgroup(ce,e,tp)  
				local mf=ce:GetValue()  
				res=Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,mf,c,chkf)  
			end  
		end  
		return res  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)  
end  
function cm.operation(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	local chkf=tp  
	if not c:IsRelateToEffect(e) or c:IsImmuneToEffect(e) then return end  
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.filter1,nil,e)  
	local sg1=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,c,chkf)  
	local mg2=nil  
	local sg2=nil  
	local ce=Duel.GetChainMaterial(tp)  
	if ce~=nil then  
		local fgroup=ce:GetTarget()  
		mg2=fgroup(ce,e,tp)  
		local mf=ce:GetValue()  
		sg2=Duel.GetMatchingGroup(cm.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,c,chkf)  
	end  
	if (Duel.GetLocationCountFromEx(tp)>0 and sg1:GetCount()>0) or (sg2~=nil and sg2:GetCount()>0) then  
		local sg=sg1:Clone()  
		if sg2 then sg:Merge(sg2) end  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local tg=sg:Select(tp,1,1,nil)  
		local tc=tg:GetFirst()  
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then  
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)  
			tc:SetMaterial(mat1)  
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
			Duel.BreakEffect()  
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)  
		else  
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,c,chkf)  
			local fop=ce:GetOperation()  
			fop(ce,e,tp,tc,mat2)  
		end  
		tc:CompleteProcedure()  
	end  
end  
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)  
end  
function cm.thfilter(c)  
	return c:IsSetCard(0x29d) and c:IsAbleToHand()  
end  
function cm.thop(e,tp,eg,ep,ev,re,r,rp)  
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)  
	Duel.ConfirmDecktop(p,3)  
	local g=Duel.GetDecktopGroup(p,3)  
	if g:GetCount()>0 and g:IsExists(cm.thfilter,1,nil) and Duel.SelectYesNo(p,aux.Stringid(m,2)) then  
		Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)  
		local sg=g:FilterSelect(p,cm.thfilter,1,1,nil)  
		Duel.SendtoHand(sg,nil,REASON_EFFECT)  
		Duel.ConfirmCards(1-p,sg)  
		Duel.ShuffleHand(p)  
	end  
	Duel.ShuffleDeck(p)  
end