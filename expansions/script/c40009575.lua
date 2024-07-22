--焰之巫女的祈祷 
function c40009575.initial_effect(c) 
	aux.AddCodeList(c,40009579,40009571)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c40009575.target)
	e1:SetOperation(c40009575.activate)
	c:RegisterEffect(e1) 
	--to hand
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE) 
	e2:SetCondition(aux.exccon)
	e2:SetCost(c40009575.thcost)
	e2:SetTarget(c40009575.thtg)
	e2:SetOperation(c40009575.thop)
	c:RegisterEffect(e2)
end
function c40009575.filter(c,e,tp)
	return c:IsRace(RACE_DRAGON)
end
function c40009575.RitualUltimateFilter(c,filter,e,tp,m1,m2,level_function,greater_or_equal,chk)
	if bit.band(c:GetType(),0x81)~=0x81 or (filter and not filter(c,e,tp,chk)) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	local lv=level_function(c)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,lv,greater_or_equal)
	local res=mg:CheckSubGroup(aux.RitualCheck,1,lv,tp,c,lv,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end
function c40009575.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		return Duel.IsExistingMatchingCard(c40009575.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,c40009575.filter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c40009575.activate(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg1=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c40009575.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,c40009575.filter,e,tp,mg1,nil,Card.GetLevel,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,true,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		if Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)~=0
			and tc:IsFacedown() then
			Duel.ConfirmCards(1-tp,tc)
		end
		tc:CompleteProcedure()
	end
end
function c40009575.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() 
	and Duel.IsExistingMatchingCard(function(c) return c:IsCode(40009571) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,1,e:GetHandler()) 
	and Duel.IsExistingMatchingCard(function(c) return c:IsCode(40009579) and c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end 
	local rg=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(40009571) and c:IsAbleToRemoveAsCost() end,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	rg:AddCard(e:GetHandler()) 
	Duel.Remove(rg,POS_FACEUP,REASON_EFFECT) 
	local g=Duel.SelectMatchingCard(tp,function(c) return c:IsCode(40009579) and c:IsAbleToDeckAsCost() end,tp,LOCATION_GRAVE,0,1,1,e:GetHandler()) 
	Duel.SendtoDeck(g,nil,2,REASON_COST) 
end 
function c40009575.thfilter(c)
	return aux.IsCodeListed(c,40009579) and not c:IsCode(40009575) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c40009575.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009575.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c40009575.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c40009575.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end



