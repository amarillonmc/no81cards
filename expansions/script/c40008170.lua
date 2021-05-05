--青色眼睛的融合
function c40008170.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40008170+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c40008170.tdcost)
	e1:SetTarget(c40008170.target)
	e1:SetOperation(c40008170.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40008170,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(c40008170.thcost)
	e2:SetTarget(c40008170.thtg)
	e2:SetOperation(c40008170.thop)
	c:RegisterEffect(e2)
end
c40008170.card_code_list={89631139}
function c40008170.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c40008170.fcheck(tp,sg,fc,mg)
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then
		return sg:IsExists(c40008170.filterchk,1,nil) end
	return true
end
function c40008170.filterchk(c)
	return c:IsCode(89631139) 
end
function c40008170.filter0(c)
	return (c:IsSetCard(0xdd) or (c:IsLevel(1) and c:IsAttribute(ATTRIBUTE_LIGHT))) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c40008170.filter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c40008170.filter2(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_LIGHT) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c40008170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c40008170.filter0,tp,LOCATION_DECK,0,nil)
		if mg:IsExists(c40008170.filterchk,1,nil) and mg2:GetCount()>0 then
			mg:Merge(mg2)
			aux.FCheckAdditional=c40008170.fcheck
		end
		local res=Duel.IsExistingMatchingCard(c40008170.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,nil,chkf)
		aux.FCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c40008170.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
end
function c40008170.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c40008170.filter1,nil,e)
	local mg2=Duel.GetMatchingGroup(c40008170.filter0,tp,LOCATION_DECK,0,nil)
	if mg1:IsExists(c40008170.filterchk,1,nil) and mg2:GetCount()>0 then
		mg1:Merge(mg2)
		aux.FCheckAdditional=c40008170.fcheck
	end
	local sg1=Duel.GetMatchingGroup(c40008170.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c40008170.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		aux.FCheckAdditional=c40008170.fcheck
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		aux.FCheckAdditional=nil
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
function c40008170.cfilter(c)
	return c:IsSetCard(0xdd) and c:IsAbleToRemoveAsCost() and c:IsFaceup()
end
function c40008170.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost()
		and Duel.IsExistingMatchingCard(c40008170.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c40008170.cfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,1,1,e:GetHandler())
	g:AddCard(e:GetHandler())
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c40008170.thfilter(c)
	return c:IsCode(53347303) and c:IsAbleToHand()
end
function c40008170.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40008170.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40008170.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstMatchingCard(c40008170.thfilter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end