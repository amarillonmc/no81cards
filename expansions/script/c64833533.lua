local m=64833533
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,64833531)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.attrcomp(c,tc)
	local count=0
	if c:GetRace()==tc:GetRace() then count=count+1 end
	if c:GetAttribute()==tc:GetAttribute() then count=count+1 end
	if c:GetLevel()==tc:GetLevel() then count=count+1 end
	if c:GetAttack()==tc:GetAttack() then count=count+1 end
	if c:GetDefense()==tc:GetDefense() then count=count+1 end
	return count==1
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterialEx(tp)
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,nil,e,tp,mg,nil,aux.GetCappedAttack,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	::cancel::
	local mg=Duel.GetRitualMaterialEx(tp)
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.RitualUltimateFilter),tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,nil,e,tp,mg,nil,aux.GetCappedAttack,"Greater")
	local tc=tg:GetFirst()
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if tc:IsLocation(LOCATION_DECK) then
			mg=mg:Filter(cm.attrcomp,tc,tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=cm.RitualCheckAdditional(tc,tc:GetAttack(),"Greater")
		local mat=mg:SelectSubGroup(tp,cm.RitualCheck,true,1,#mg,tp,tc,tc:GetAttack(),"Greater")
		aux.GCheckAdditional=nil
		if not mat then goto cancel end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end
function cm.RitualCheckGreater(g,c,atk)
	if atk==0 then return false end
	Duel.SetSelectedCard(g)
	return g:CheckWithSumGreater(aux.GetCappedAttack,atk)
end
function cm.RitualCheckEqual(g,c,atk)
	if atk==0 then return false end
	return g:CheckWithSumEqual(aux.GetCappedAttack,atk,#g,#g)
end
function cm.RitualCheck(g,tp,c,atk,greater_or_equal)
	return cm["RitualCheck"..greater_or_equal](g,c,atk) and Duel.GetMZoneCount(tp,g,tp)>0 and (not c.mat_group_check or c.mat_group_check(g,tp))
		and (not aux.RCheckAdditional or aux.RCheckAdditional(tp,g,c))
end
function cm.RitualCheckAdditional(c,atk,greater_or_equal)
	if greater_or_equal=="Equal" then
		return  function(g)
					return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and g:GetSum(aux.GetCappedAttack)<=atk
				end
	else
		return  function(g,ec)
					if atk==0 then return #g<=1 end
					if ec then
						return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g,ec)) and g:GetSum(aux.GetCappedAttack)-aux.GetCappedAttack(ec)<=atk
					else
						return not aux.RGCheckAdditional or aux.RGCheckAdditional(g)
					end
				end
	end
end
function cm.RitualUltimateFilter(c,filter,e,tp,m1,m2,attack_function,greater_or_equal,chk)
	if not c:IsCode(64833531) or not c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) then return false end
	local mg=m1:Filter(Card.IsCanBeRitualMaterial,c,c)
	if m2 then
		mg:Merge(m2)
	end
	if c.mat_filter then
		mg=mg:Filter(c.mat_filter,c,tp)
	else
		mg:RemoveCard(c)
	end
	if c:IsLocation(LOCATION_DECK) then
		mg=mg:Filter(cm.attrcomp,c,c)
	end
	local atk=attack_function(c)
	aux.GCheckAdditional=cm.RitualCheckAdditional(c,atk,greater_or_equal)
	local res=mg:CheckSubGroup(cm.RitualCheck,1,#mg,tp,c,atk,greater_or_equal)
	aux.GCheckAdditional=nil
	return res
end

function cm.filter(c,e,tp)
	return c:IsCode(64833531)
end
function cm.mfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0xccf) and c:IsAbleToRemove()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg1=Duel.GetRitualMaterial(tp)
		local mg2=nil
		return Duel.IsExistingMatchingCard(cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,nil,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg1=Duel.GetRitualMaterial(tp)
	local mg2=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.RitualUltimateFilter,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,cm.filter,e,tp,mg1,mg2,Card.GetLevel,"Greater")
	local tc=g:GetFirst()
	if tc then
		local mg=mg1:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		mg:Merge(mg2)
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		if tc:IsLocation(LOCATION_DECK) then
			mg=mg:Filter(cm.attrcomp,tc,tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		aux.GCheckAdditional=aux.RitualCheckAdditional(tc,tc:GetLevel(),"Greater")
		local mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,tc:GetLevel(),tp,tc,tc:GetLevel(),"Greater")
		aux.GCheckAdditional=nil
		if not mat or mat:GetCount()==0 then return end
		tc:SetMaterial(mat)
		Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end