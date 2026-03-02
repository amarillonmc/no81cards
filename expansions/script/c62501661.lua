--四相之什弥尼斯
function c62501661.initial_effect(c)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e0:SetCondition(c62501661.excondition)
	e0:SetCost(c62501661.excost)
	e0:SetDescription(aux.Stringid(62501661,4))
	c:RegisterEffect(e0)
	--public
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	c:RegisterEffect(e1)
	--activate:select effect
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SUMMON+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,62501661)
	e2:SetCost(c62501661.cost)
	e2:SetTarget(c62501661.target)
	e2:SetOperation(c62501661.activate)
	c:RegisterEffect(e2)
	c62501661.second_effect=e2
end
c62501661.has_text_type=TYPE_SPIRIT
function c62501661.cfilter(c)
	return c:IsSetCard(0xea2) and c:IsFaceup()
end
function c62501661.excondition(e)
	return Duel.IsExistingMatchingCard(c62501661.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c62501661.excost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHandAsCost,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,c62501661.exfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c62501661.exfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceup() and c:IsAbleToHandAsCost()
end
function c62501661.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(c62501661.exfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501661,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,c62501661.exfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_COST)
		e:SetLabel(1) else e:SetLabel(0)
	end
end
function c62501661.filter(c,e,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsFaceupEx()
end
function c62501661.mfilter(c)
	return c:GetLevel()>0 and c:IsType(TYPE_SPIRIT) and c:IsReleasable(REASON_EFFECT|REASON_MATERIAL|REASON_RITUAL)
end
function c62501661.thfilter(c)
	return c:IsSetCard(0xea2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c62501661.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c62501661.thfilter,tp,LOCATION_DECK,0,1,nil)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	local mg2=Duel.GetMatchingGroup(c62501661.mfilter,tp,LOCATION_DECK,0,nil)
	local b2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c62501661.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	local b3=b1 and b2
	if chk==2 then return b3 end
	if chk==0 then return b1 or b2 end
end
function c62501661.activate(e,tp,eg,ep,ev,re,r,rp)
	local op,sel=e:GetLabel()
	local b1=Duel.IsExistingMatchingCard(c62501661.thfilter,tp,LOCATION_DECK,0,1,nil)
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	local mg2=Duel.GetMatchingGroup(c62501661.mfilter,tp,LOCATION_DECK,0,nil)
	local b2=Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,c62501661.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
	local b3=b1 and b2 and op==1
	if not sel then
		sel=aux.SelectFromOptions(tp,
			{b1,aux.Stringid(62501661,1),1},
			{b2,aux.Stringid(62501661,2),2},
			{b3,aux.Stringid(62501661,2),3})
	end
	if sel~=2 then c62501661.thop(e,tp,eg,ep,ev,re,r,rp) end
	if sel==3 then Duel.BreakEffect() end
	if sel~=1 then c62501661.spop(e,tp,eg,ep,ev,re,r,rp) end
end
function c62501661.sumfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsSummonable(true,nil)
end
function c62501661.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c62501661.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #tg>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		if Duel.IsExistingMatchingCard(c62501661.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(62501661,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
			local sg=Duel.SelectMatchingCard(tp,c62501661.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			if sg:GetCount()>0 then
				Duel.Summon(tp,sg:GetFirst(),true,nil)
			end
		end
	end
end
function c62501661.spop(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg1=Duel.GetRitualMaterial(tp):Filter(Card.IsType,nil,TYPE_SPIRIT)
	local mg2=Duel.GetMatchingGroup(c62501661.mfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,c62501661.filter,e,tp,mg1,mg2,Card.GetLevel,"Equal")
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
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
