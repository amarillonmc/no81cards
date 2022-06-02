--古代龙的觉醒
if not pcall(function() require("expansions/script/c40009451") end) then require("script/c40009451") end
local m,cm = rscf.DefineCard(40009463)
function cm.initial_effect(c) 
	local e2=rsef.I(c,"atk",{1,m+100},"atk,def","tg",LOCATION_GRAVE,nil,aux.bfgcost,rstg.target(cm.afilter,nil,LOCATION_MZONE),cm.aop)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,40009463)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.afilter(c)
	return aux.IsCodeListed(c,40009452) and c:IsComplexType(TYPE_RITUAL+TYPE_MONSTER) and c:IsFaceup()
end
function cm.aop(e,tp)
	local tc=rscf.GetTargetCard(Card.IsFaceup)
	if not tc then return end
	local e1,e2=rscf.QuickBuff({e:GetHandler(),tc},"atkf,deff",{tc:GetAttack()*2,tc:GetDefense()*2}) 
end
function cm.spfilter(c,e,tp,mc)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_RITUAL) and (not c.mat_filter or c.mat_filter(mc,tp))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
		and mc:IsCanBeRitualMaterial(c)
end
function cm.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp,c)
	local ft=Duel.GetMZoneCount(tp,c,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return sg:CheckSubGroup(cm.gcheck,1,ft,c)
end
function cm.filter2(c,e,tp)
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp,c)
	local ft=Duel.GetMZoneCount(tp,c,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	return sg:CheckSubGroup(cm.gcheck,1,ft,c)
end
function cm.gcheck(g,mc)
	local atk,def = g:GetSum(Card.GetAttack), g:GetSum(Card.GetDefense)
	return mc:IsAttackAbove(atk) and mc:IsDefenseAbove(def) and (#g==1 or not g:IsExists(cm.cfilter,1,nil,g,mc))
end
function cm.cfilter(c,g,mc)
	local g2=g:Clone()
	g2:RemoveCard(c)
	local atk,def = g2:GetSum(Card.GetAttack), g2:GetSum(Card.GetDefense)
	return mc:IsAttackAbove(atk) and mc:IsDefenseAbove(def)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	if chk==0 then
		return mg:IsExists(cm.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end

function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:FilterSelect(tp,cm.filter2,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,mc,e,tp,mc)
	local ft = Duel.GetMZoneCount(tp,mc,tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:SelectSubGroup(tp,cm.gcheck,false,1,ft,mc)
	local tc=tg:GetFirst()
	for tc in aux.Next(tg) do
		tc:SetMaterial(mat)
	end
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	for tc in aux.Next(tg) do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
--[[function cm.spfilter(c,matg,e,tp)
	return c:IsRace(RACE_DINOSAUR) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) and (not c.mat_filter or c.mat_filter(matg,tp))
end
function cm.gcheck3(g,e,tp)
	local rg=Duel.GetMatchingGroup(cm.spfilter,tp,rsloc.hg,0,g,g,e,tp)
	local sct = rscon.bsdcheck(tp) and 1 or #rg
	return rg:CheckSubGroup(cm.gcheck2,1,sct,g)
end 
function cm.gcheck2(g,matg)
	local atk, def = g:GetSum(Card.GetAttack), g:GetSum(Card.GetDefense)
	return Duel.GetMZoneCount(tp,matg,tp)>=#g and matg:CheckWithSumGreater(Card.GetAttack,atk,#matg,#matg) and matg:CheckWithSumGreater(Card.GetDefense,def,#matg,#matg)
end
function cm.gcheck3(g,e,tp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.spfilter),tp,rsloc.hg,0,g,g,e,tp)
	local sct = rscon.bsdcheck(tp) and 1 or #rg
	return rg:CheckSubGroup(cm.gcheck2,1,sct,g)
end 
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return mg:CheckSubGroup(cm.gcheck,1,#mg,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.activate(e,tp)
	local mg=Duel.GetRitualMaterial(tp)
	if not mg:CheckSubGroup(cm.gcheck3,1,#mg,e,tp) then return end
	rshint.Select(tp,HINTMSG_RELEASE)
	local matg=mg:select
end]]--