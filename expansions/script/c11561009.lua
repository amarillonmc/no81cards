--光枪之魔导 安
function c11561009.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_SPELLCASTER),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit() 
	--to grave fusion 
	local e1=Effect.CreateEffect(c)  
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,11561009) 
	e1:SetTarget(c11561009.tgtg) 
	e1:SetOperation(c11561009.tgop) 
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DAMAGE+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,21561009)
	e2:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) end) 
	e2:SetTarget(c11561009.xxtg)
	e2:SetOperation(c11561009.xxop)
	c:RegisterEffect(e2)
end
function c11561009.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) end  
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3) 
end 
function c11561009.filter0(c)
	return c:IsOnField() and c:IsAbleToRemove()
end
function c11561009.filter1(c,e)
	return c:IsOnField() and c:IsAbleToRemove() and not c:IsImmuneToEffect(e)
end
function c11561009.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsCode(11561010) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c11561009.filter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c11561009.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 then	 
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp):Filter(c11561009.filter1,nil,e)
		local mg2=Duel.GetMatchingGroup(c11561009.filter3,tp,LOCATION_GRAVE,0,nil)
		mg1:Merge(mg2)
		local sg1=Duel.GetMatchingGroup(c11561009.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
		local mg3=nil
		local sg2=nil
		local ce=Duel.GetChainMaterial(tp)
		if ce~=nil then
			local fgroup=ce:GetTarget()
			mg3=fgroup(ce,e,tp)
			local mf=ce:GetValue()
			sg2=Duel.GetMatchingGroup(c11561009.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
		end
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=20 and (sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0)) then 
			local sg=sg1:Clone()
			if sg2 then sg:Merge(sg2) end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tg=sg:Select(tp,1,1,nil)
			local tc=tg:GetFirst()
			if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat1)
				Duel.Remove(mat1,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
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
function c11561009.thfil(c) 
	return c:IsAbleToHand() and c:IsLevel(4) and c:IsRace(RACE_SPELLCASTER)   
end 
function c11561009.xxtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.IsExistingMatchingCard(c11561009.thfil,tp,LOCATION_DECK,0,1,nil) end 
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,3)  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) 
end 
function c11561009.xxop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()  
	if Duel.IsPlayerCanDiscardDeck(tp,3) and Duel.DiscardDeck(tp,3,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c11561009.thfil,tp,LOCATION_DECK,0,1,nil) then  
		local g=Duel.SelectMatchingCard(tp,c11561009.thfil,tp,LOCATION_DECK,0,1,1,nil)   
		Duel.SendtoHand(g,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,g)   
		if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=20 then 
			Duel.Damage(1-tp,2400,REASON_EFFECT) 
			Duel.Recover(tp,2400,REASON_EFFECT) 
		end 
	end 
end 













