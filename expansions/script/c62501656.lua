--什弥尼斯的祭典
function c62501656.initial_effect(c)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	c:RegisterEffect(e1)
	--activate:select effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,62501656)
	e2:SetCost(c62501656.cost)
	e2:SetTarget(c62501656.target)
	e2:SetOperation(c62501656.activate)
	c:RegisterEffect(e2)
	c62501656.second_effect=e2
	--act limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_HAND)
	e3:SetOperation(c62501656.chainop)
	c:RegisterEffect(e3)
end
c62501656.has_text_type=TYPE_SPIRIT
function c62501656.exfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c62501656.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c62501656.exfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501656,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c62501656.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_COST)
		e:SetLabel(1) else e:SetLabel(0)
	end
end
function c62501656.filter(c,e,tp)
	return c:IsType(TYPE_SPIRIT)
end
function c62501656.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_SPIRIT) and c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function c62501656.rcheck(tp,g,c)
	return g:GetCount()<3
end
function c62501656.rgcheck(g,ec)
	return g:GetCount()<3
end
function c62501656.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	local mg2=Duel.GetMatchingGroup(c62501656.mfilter,tp,LOCATION_DECK,0,nil)
	local b1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,c62501656.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	aux.RCheckAdditional=c62501656.rcheck
	aux.RGCheckAdditional=c62501656.rgcheck
	local b2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c62501656.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local b3=b1 and b2 and Duel.IsPlayerCanSpecialSummonCount(tp,2)
	if chk==2 then return b3 end
	if chk==0 then return b1 or b2 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0)
end
function c62501656.activate(e,tp,eg,ep,ev,re,r,rp)
	local op,sel=e:GetLabel()
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	local mg2=Duel.GetMatchingGroup(c62501656.mfilter,tp,LOCATION_DECK,0,nil)
	local b1=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,nil,c62501656.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	aux.RCheckAdditional=c62501656.rcheck
	aux.RGCheckAdditional=c62501656.rgcheck
	local b2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,c62501656.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
	local b3=b1 and b2 and Duel.IsPlayerCanSpecialSummonCount(tp,2) and op==1
	if not sel then
		sel=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(62501656,1),1},
			{b2,aux.Stringid(62501656,2),2},
			{b3,aux.Stringid(62501656,2),3})
	end
	if sel~=2 then c62501656.spop1(e,tp,eg,ep,ev,re,r,rp) end
	if sel==3 then Duel.BreakEffect() end
	if sel~=1 then c62501656.spop2(e,tp,eg,ep,ev,re,r,rp) end
end
function c62501656.spop1(e,tp,eg,ep,ev,re,r,rp)
	::cancel1::
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_DECK,0,1,1,nil,c62501656.filter,e,tp,mg1,nil,Card.GetLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then goto cancel1 end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function c62501656.spop2(e,tp,eg,ep,ev,re,r,rp)
	::cancel2::
	aux.RCheckAdditional=c62501656.rcheck
	aux.RGCheckAdditional=c62501656.rgcheck
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	local mg2=Duel.GetMatchingGroup(c62501656.mfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,c62501656.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			goto cancel2
		end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
function c62501656.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:GetActivateLocation()==LOCATION_MZONE and rc:IsControler(tp) and rc:IsSummonType(SUMMON_TYPE_NORMAL) and rc:IsSetCard(0xea2) and re:IsActiveType(TYPE_MONSTER) then
		Duel.SetChainLimit(c62501656.chainlm)
	end
end
function c62501656.chainlm(e,rp,tp)
	return tp==rp
end
