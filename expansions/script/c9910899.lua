--记忆之扉
function c9910899.initial_effect(c)
	aux.AddCodeList(c,9910871)
	--code
	aux.EnableChangeCode(c,9910871,LOCATION_SZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9910899,0))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_HANDES_SELF)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(2,9910899)
	e2:SetTarget(c9910899.thtg)
	e2:SetOperation(c9910899.thop)
	c:RegisterEffect(e2)
	--fusion
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9910899,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(2,9910899)
	e3:SetTarget(c9910899.sptg)
	e3:SetOperation(c9910899.spop)
	c:RegisterEffect(e3)
end
c9910899.fusion_effect=true
function c9910899.thfilter(c)
	return aux.IsCodeListed(c,9910871) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910899.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910899.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_HANDES_SELF,nil,0,tp,1)
end
function c9910899.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910899.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 and g:GetFirst():IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD,nil)
	end
end
function c9910899.mfilter1(c,e)
	return not c:IsImmuneToEffect(e)
end
function c9910899.mfilter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToRemove()
end
function c9910899.mfilter3(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsFaceup()
end
function c9910899.mfilter4(c,e)
	return c9910899.mfilter3(c) and not c:IsImmuneToEffect(e)
end
function c9910899.mfilter5(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave()
end
function c9910899.spfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9910899.spfilter2(c,e,tp,m,f,chkf,code)
	return c:IsType(TYPE_FUSION) and c:IsCode(code) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c9910899.fcheck(tp,sg,fc)
	return aux.drccheck(sg)
end
function c9910899.fcheck2(tp,sg,fc)
	return aux.drccheck(sg) and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function c9910899.gcheck2(sg)
	return aux.drccheck(sg) and sg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)<=1
end
function c9910899.fcheck3(tp,sg,fc)
	return aux.drccheck(sg) and sg:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function c9910899.gcheck3(tp)
	return  function(sg)
				return aux.drccheck(sg) and sg:FilterCount(Card.IsControler,nil,1-tp)<=1
			end
end
function c9910899.fcheck4(tp,sg,fc)
	return aux.drccheck(sg) and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c9910899.gcheck4(sg)
	return aux.drccheck(sg) and sg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c9910899.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		aux.FCheckAdditional=c9910899.fcheck
		local res=Duel.IsExistingMatchingCard(c9910899.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		local mg2=Duel.GetMatchingGroup(c9910899.mfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		mg2:Merge(mg1)
		local mg3=Duel.GetMatchingGroup(c9910899.mfilter3,tp,0,LOCATION_MZONE,nil)
		mg3:Merge(mg1)
		local mg4=Duel.GetMatchingGroup(c9910899.mfilter5,tp,LOCATION_DECK,0,nil)
		mg4:Merge(mg1)
		aux.FCheckAdditional=c9910899.fcheck2
		aux.GCheckAdditional=c9910899.gcheck2
		res=res or Duel.IsExistingMatchingCard(c9910899.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,nil,chkf,9910881)
		aux.FCheckAdditional=c9910899.fcheck3
		aux.GCheckAdditional=c9910899.gcheck3(tp)
		res=res or Duel.IsExistingMatchingCard(c9910899.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,nil,chkf,9910885)
		aux.FCheckAdditional=c9910899.fcheck4
		aux.GCheckAdditional=c9910899.gcheck4
		res=res or Duel.IsExistingMatchingCard(c9910899.spfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg4,nil,chkf,9910890)
		aux.FCheckAdditional=c9910899.fcheck
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg0=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c9910899.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg0,mf,chkf)
			end
		end
		aux.FCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9910899.racefilter(c,rc)
	return c:GetRace()>0
end
function c9910899.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c9910899.mfilter1,nil,e)
	aux.FCheckAdditional=c9910899.fcheck
	local sg1=Duel.GetMatchingGroup(c9910899.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	local mg2=Duel.GetMatchingGroup(c9910899.mfilter2,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
	mg2:Merge(mg1)
	local mg3=Duel.GetMatchingGroup(c9910899.mfilter4,tp,0,LOCATION_MZONE,nil,e)
	mg3:Merge(mg1)
	local mg4=Duel.GetMatchingGroup(c9910899.mfilter5,tp,LOCATION_DECK,0,nil)
	mg4:Merge(mg1)
	aux.FCheckAdditional=c9910899.fcheck2
	aux.GCheckAdditional=c9910899.gcheck2
	local sg2=Duel.GetMatchingGroup(c9910899.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,nil,chkf,9910881)
	sg1:Merge(sg2)
	aux.FCheckAdditional=c9910899.fcheck3
	aux.GCheckAdditional=c9910899.gcheck3(tp)
	local sg3=Duel.GetMatchingGroup(c9910899.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,nil,chkf,9910885)
	sg1:Merge(sg3)
	aux.FCheckAdditional=c9910899.fcheck4
	aux.GCheckAdditional=c9910899.gcheck4
	local sg4=Duel.GetMatchingGroup(c9910899.spfilter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg4,nil,chkf,9910890)
	sg1:Merge(sg4)
	aux.FCheckAdditional=c9910899.fcheck
	aux.GCheckAdditional=nil
	local mg0=nil
	local sg0=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg0=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg0=Duel.GetMatchingGroup(c9910899.spfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,mf,chkf)
	end
	if sg1:GetCount()>0 or (sg0~=nil and sg0:GetCount()>0) then
		local sg=sg1:Clone()
		if sg0 then sg:Merge(sg0) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg0==nil or not sg0:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc:IsCode(9910881) then
				aux.FCheckAdditional=c9910899.fcheck2
				aux.GCheckAdditional=c9910899.gcheck2
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
				aux.FCheckAdditional=c9910899.fcheck
				aux.GCheckAdditional=nil
				tc:SetMaterial(mat1)
				local rg=mat1:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
				mat1:Sub(rg)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
				Duel.Remove(rg,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			elseif tc:IsCode(9910885) then
				aux.FCheckAdditional=c9910899.fcheck3
				aux.GCheckAdditional=c9910899.gcheck3(tp)
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
				aux.FCheckAdditional=c9910899.fcheck
				aux.GCheckAdditional=nil
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			elseif tc:IsCode(9910890) then
				aux.FCheckAdditional=c9910899.fcheck4
				aux.GCheckAdditional=c9910899.gcheck4
				local mat1=Duel.SelectFusionMaterial(tp,tc,mg4,nil,chkf)
				aux.FCheckAdditional=c9910899.fcheck
				aux.GCheckAdditional=nil
				tc:SetMaterial(mat1)
				Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			else
				local mat2=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
				tc:SetMaterial(mat2)
				Duel.SendtoGrave(mat2,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			end
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat=Duel.SelectFusionMaterial(tp,tc,mg0,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat)
		end
		if c:IsCode(9910871) then tc:RegisterFlagEffect(9910871,RESET_EVENT+RESET_TURN_SET+RESET_TOHAND+RESET_TODECK+RESET_TOFIELD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(9910871,0)) end
		tc:CompleteProcedure()
		local mg=tc:GetMaterial()
		local wg=mg:Filter(c9910899.racefilter,nil)
		local att=0
		for wbc in aux.Next(wg) do
			att=att|wbc:GetRace()
		end
		if att>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_RACE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(att)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
	aux.FCheckAdditional=nil
end
