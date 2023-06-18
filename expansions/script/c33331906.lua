--堇霆之灵 赤闪
function c33331906.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,33331906)	 
	e1:SetTarget(c33331906.target)
	e1:SetOperation(c33331906.activate)
	c:RegisterEffect(e1)  
	--to hand 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TODECK) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_REMOVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY) 
	e2:SetCountLimit(1,13331906) 
	e2:SetTarget(c33331906.thtg) 
	e2:SetOperation(c33331906.thop) 
	c:RegisterEffect(e2) 
end 
function c33331906.filter0(c)
	return (c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c33331906.filter1(c,e)
	return (c:IsLocation(LOCATION_MZONE) or c:IsFaceup()) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e)
end
function c33331906.filter2(c,e,tp,m,f,chkf)  
	e:GetHandler():AddMonsterAttribute(TYPE_NORMAL)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,e:GetHandler(),chkf)
end
function c33331906.target(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and
		Duel.IsPlayerCanSpecialSummonMonster(tp,33331906,0x3567,TYPES_NORMAL_TRAP_MONSTER,500,0,4,RACE_THUNDER,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end 
function c33331906.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsRace,1,nil,RACE_REPTILE)
end
function c33331906.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if not c:IsRelateToEffect(e) then return end 
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,33331906,0x3567,TYPES_NORMAL_TRAP_MONSTER,500,0,4,RACE_THUNDER,ATTRIBUTE_DARK) then return end
		c:AddMonsterAttribute(TYPE_NORMAL)
		if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then 
			local chkf=tp
			local mg=Duel.GetMatchingGroup(c33331906.filter1,tp,LOCATION_MZONE+LOCATION_REMOVED,0,nil,e)
			aux.FCheckAdditional=c33331906.fcheck
			local sg1=Duel.GetMatchingGroup(c33331906.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
			local mg3=nil
			local sg2=nil
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				sg2=Duel.GetMatchingGroup(c33331906.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
			end
			if (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) and Duel.SelectYesNo(tp,aux.Stringid(33331906,0)) then
				Duel.BreakEffect()  
				local sg=sg1:Clone()
				if sg2 then sg:Merge(sg2) end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local tg=sg:Select(tp,1,1,nil)
				local tc=tg:GetFirst()
				if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat=Duel.SelectFusionMaterial(tp,tc,mg,e:GetHandler(),chkf)
				tc:SetMaterial(mat)
				if mat:IsExists(Card.IsFacedown,1,nil) then
					local cg=mat:Filter(Card.IsFacedown,nil)
					Duel.ConfirmCards(1-tp,cg)
				end
				Duel.SendtoGrave(mat,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
				else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				local fop=ce:GetOperation()
				fop(ce,e,tp,tc,mat2)
			end 
			tc:CompleteProcedure() 
		end  
	aux.FCheckAdditional=nil
	end 
end 
function c33331906.thfil(c) 
	return c:IsAbleToHand() and c:IsType(TYPE_SPELL) and c:IsSetCard(0x3567) and not c:IsCode(33331906) 
end 
function c33331906.thtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c33331906.thfil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsAbleToHand() end 
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c33331906.thop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(c33331906.thfil,tp,LOCATION_DECK,0,nil) 
	if g:GetCount()>0 then 
		local sg=g:Select(tp,1,1,nil) 
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)   
		if c:IsRelateToEffect(e) then 
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)   
		end   
	end 
end 


