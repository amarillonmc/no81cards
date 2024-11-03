--青眼的追忆
local m=91090024
local cm=c91090024
function c91090024.initial_effect(c)
		aux.AddCodeList(c,89631139)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_GRAVE_ACTION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target2)
	e2:SetOperation(cm.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,m+1)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.operation)
	c:RegisterEffect(e3)
end
function cm.filter10(c)
	return c:IsLevel(1) and c:IsType(TYPE_TUNER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand() 
end
function cm.filter11(c)
	return aux.IsCodeListed(c,89631139) and c:IsAbleToGrave() and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter10,tp,LOCATION_DECK,0,1,nil)  and Duel.IsExistingMatchingCard(cm.filter11,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter10,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		if Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then 
		Duel.ConfirmCards(1-tp,g)
		local g2=Duel.SelectMatchingCard(tp,cm.filter11,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then Duel.SendtoGrave(g2,REASON_EFFECT) end
		end
	end
end
function cm.filter0(c,e)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToDeck() and not c:IsImmuneToEffect(e)
end
function cm.filter1(c,e,tp,m,f,chkf)
	if not (c:IsType(TYPE_FUSION) and (aux.IsMaterialListCode(c,89631139) or aux.IsMaterialListCode(c,23995346)) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)) then return false end
	aux.FCheckAdditional=c.ultimate_fusion_check or cm.fcheck
	local res=c:CheckFusionMaterial(m,nil,chkf)
	aux.FCheckAdditional=nil
	return res
end
function cm.fcheck(tp,sg,fc)
	return sg:IsExists(Card.IsFusionCode,1,nil,89631139) and aux.IsMaterialListCode(fc,89631139)
		or sg:IsExists(Card.IsFusionCode,1,nil,23995346) and aux.IsMaterialListCode(fc,23995346)
end
function cm.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetMatchingGroup(cm.filter0,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
		local res=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.desfilter(c)
	return c:IsFusionCode(89631139,23995346) and c:IsOnField()
end
function cm.activate2(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter0),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg,nil,chkf)
	local mg3=nil
	local sg2=nil
	local ct=0
	local spchk=0
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		aux.FCheckAdditional=tc.ultimate_fusion_check or cm.fcheck
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg,nil,chkf)
			ct=mat1:FilterCount(cm.desfilter,nil)
			tc:SetMaterial(mat1)
			if mat1:IsExists(Card.IsFacedown,1,nil) then
				local cg=mat1:Filter(Card.IsFacedown,nil)
				Duel.ConfirmCards(1-tp,cg)
			end
			if mat1:Filter(cm.cfilter,nil):GetCount()>0 then
				local cg=mat1:Filter(cm.cfilter,nil)
				Duel.HintSelection(cg)
			end
			Duel.SendtoDeck(mat1,nil,SEQ_DECKSHUFFLE,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			spchk=1
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			ct=mat2:FilterCount(cm.desfilter,nil)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
			spchk=1
		end
		tc:CompleteProcedure()
	end
	aux.FCheckAdditional=nil
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
end
function cm.filter(c,e,tp)
	return c:IsCode(89604813) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end

function cm.fit2(g)
	return g:CheckWithSumEqual(Card.GetLevel,12,1,#g) 
end
function cm.fit3(g)
	return  g:IsExists(Card.IsCode,1,nil,89631139)
end
function cm.costfilter(c)
	return c:IsLevelAbove(0)  and c:IsAbleToGrave()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_DECK,0,nil)
	if chk==0 then return  Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp) and g:CheckSubGroup(cm.fit2) and g:IsExists(Card.IsCode,1,nil,89631139)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_DECK,0,nil)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g2=g:SelectSubGroup(tp,cm.fit3,false,1,1)
	local g1=g:SelectWithSumEqual(tp,Card.GetLevel,4,1,#g)
	g1:Merge(g2)
	if g1:GetCount()>0 then
	Duel.SendtoGrave(g1,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end