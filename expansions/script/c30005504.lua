--生体合融
local m=30005504
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e0=aux.AddThisCardInGraveAlreadyCheck(c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m+m)
	e2:SetCondition(cm.con)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)   
	--e2:SetLabelObject(e0)
	c:RegisterEffect(e2)
end
--Effect 1
function cm.mfilter0(c)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:IsType(TYPE_MONSTER) and b1 
		and c:IsCanBeFusionMaterial() and c:IsAbleToDeck()
end
function cm.mfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function cm.mfilter2(c,e)
	local b1=c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)
	return c:IsType(TYPE_MONSTER) and b1 
		and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() 
		and not c:IsImmuneToEffect(e)
end
function cm.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.spfilter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x927) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		if res then return true end
		local mg2=Duel.GetMatchingGroup(cm.mfilter0,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil)
		mg2:Merge(mg1)
		res=Duel.IsExistingMatchingCard(cm.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(cm.mfilter1,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.mfilter2),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e)
	mg2:Merge(mg1)
	local sg2=Duel.GetMatchingGroup(cm.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf)
	sg1:Merge(sg2)
	local mg3=nil
	local sg3=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg3=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg3~=nil and sg3:GetCount()>0) then
		local sg=sg1:Clone()
		if sg3 then sg:Merge(sg3) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg3==nil or not sg3:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsSetCard(0x927) then
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				tc:SetMaterial(mat1)
				local mat2=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE+LOCATION_REMOVED)
				mat1:Sub(mat2)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.SendtoDeck(mat2,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		tc:CompleteProcedure()
	end
end
--Effect 2
--Effect 2
function cm.cfilter(c)
	return c:IsType(TYPE_FUSION) and c:IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.tf(c)
	return c:IsAbleToHand() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x927)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local b1=c:IsAbleToDeck()
	local b2=Duel.IsExistingMatchingCard(cm.tf,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return b1 and b2 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) 
		and Duel.SendtoDeck(c,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 
		and c:IsLocation(LOCATION_DECK) then
		Duel.DisableShuffleCheck()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.tf,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
