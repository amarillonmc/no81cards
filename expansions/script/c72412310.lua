--护虹的彩拟翅 欧泊
function c72412310.initial_effect(c)
  	  aux.AddCodeList(c,37626500)
		--flag
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCode(72412310)
	c:RegisterEffect(e1)
	if c72412310.gcheck then return end
	c72412310.gcheck = true 
	--adjust
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(c72412310.chop)
	Duel.RegisterEffect(e1,tp)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
                e2:SetCountLimit(1)
	e2:SetCondition(c72412310.condition)
	e2:SetCost(c72412310.cost)
	e2:SetTarget(c72412310.target)
	e2:SetOperation(c72412310.op)
	c:RegisterEffect(e2)
end
function c72412310.condition(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c72412310.costfilter(c,type)
	return c:IsType(type) and c:IsDiscardable()
end
function c72412310.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local type=bit.band(re:GetActiveType(),0x7)
	if chk==0 then return Duel.IsExistingMatchingCard(c72412310.costfilter,tp,LOCATION_HAND,0,1,nil,type) end
	Duel.DiscardHand(tp,c38891741.cfilter,1,1,REASON_COST+REASON_DISCARD,nil,type)
end
function c72412310.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_TODECK,eg,1,0,0)
	end
end
function c72412310.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	if re:GetHandler():IsRelateToEffect(re) then 
		Duel.SendtoDeck(eg,nil,2,REASON_EFFECT)
	end
end

function c72412310.cfilter(c)
	return c:IsOriginalCodeRule(37626500) and c:GetType() & 0x82 == 0x82 and c:GetFlagEffect(m) == 0 and c:GetActivateEffect()
end
function c72412310.chop(e,tp)
	local g = Duel.GetMatchingGroup(c72412310.cfilter,tp,0xff,0xff,nil)
	for tc in aux.Next(g) do 
		tc:RegisterFlagEffect(m,0,0,1)
		local ae = tc:GetActivateEffect()
		ae:SetTarget(c72412310.rittg)
		ae:SetOperation(c72412310.ritop)
	end
end
function c72412310.dfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevelAbove(1) and c:IsAbleToGrave()
end
function c72412310.filter(c,e,tp)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c72412310.rcheck(tp,g,c)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c72412310.rgcheck(g)
	return g:FilterCount(Card.IsLocation,nil,LOCATION_DECK)<=1
end
function c72412310.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if not c:IsHasEffect(72412310) and c:IsLocation(LOCATION_GRAVE) then return false end
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 and c:IsHasEffect(72412310) then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(Auxiliary.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	Auxiliary.GCheckAdditional=nil
	return res
end
function c72412310.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		local dg=Duel.GetMatchingGroup(c72412310.dfilter,tp,LOCATION_DECK,0,nil)
		aux.RCheckAdditional=c72412310.rcheck
		aux.RGCheckAdditional=c72412310.rgcheck
		local res=Duel.IsExistingMatchingCard(c72412310.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c72412310.filter,e,tp,mg,dg,Card.GetLevel,"Equal")
		aux.RCheckAdditional=nil
		aux.RGCheckAdditional=nil
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c72412310.ritop(e,tp,eg,ep,ev,re,r,rp)
	local m=Duel.GetRitualMaterial(tp)
	local dg=Duel.GetMatchingGroup(c72412310.dfilter,tp,LOCATION_DECK,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.RCheckAdditional=c72412310.rcheck
	aux.RGCheckAdditional=c72412310.rgcheck
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c72412310.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c72412310.filter,e,tp,m,dg,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	if tc then
		local mg=m:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc:IsHasEffect(72412310) then
			mg:Merge(dg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Equal")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Equal")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then
			aux.RCheckAdditional=nil
			aux.RGCheckAdditional=nil
			return
		end
		tc:SetMaterial(mat)
		local dmat=mat:Filter(Card.IsLocation,nil,LOCATION_DECK)
		if dmat:GetCount()>0 then
			mat:Sub(dmat)
			Duel.SendtoGrave(dmat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	aux.RCheckAdditional=nil
	aux.RGCheckAdditional=nil
end
