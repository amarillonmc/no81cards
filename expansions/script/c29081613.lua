--深海猎人自我归一
local m=29081613
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddCodeList(c,29063234,22702055)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Activate in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e3)
	--NegateEffect "Arknights-Specter the Unchained":ACTIVATE FROM GRAVE
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,0))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.cost)
	e5:SetCondition(cm.con)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate1(cm.activate))
	e5:SetLabelObject(e1)
	c:RegisterEffect(e5)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,false)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,29063234) and e:GetLabelObject():CheckCountLimit(tp)
end
function cm.activate1(op)
	return function(e,tp,eg,ep,ev,re,r,rp)
				op(e,tp,eg,ep,ev,re,r,rp)
				local c=e:GetHandler()
				c:CancelToGrave()
				Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
			end
end
function cm.filter(c,e,tp)
	return c:IsCode(29063234)
end
function cm.check(c,e,tp)
	return c:IsCode(29072102) and c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(cm.spcheck,tp,LOCATION_HAND+LOCATION_DECK,0,1,c,e,tp)
end
function cm.spcheck(c,e,tp)
	return c:IsCode(29063234) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local spchk=Duel.IsEnvironment(22702055)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp)
		return (not spchk and Duel.IsExistingMatchingCard(aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,nil,cm.filter,e,tp,mg,nil,Card.GetLevel,"Greater")) or (spchk and Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp))
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsEnvironment(22702055) then
		::cancel::
		local mg=Duel.GetRitualMaterial(tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=Duel.SelectMatchingCard(tp,aux.RitualUltimateFilter,tp,LOCATION_HAND,0,1,1,nil,cm.filter,e,tp,mg,nil,Card.GetLevel,"Greater")
		local tc=tg:GetFirst()
		if tc then
			mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
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
			local lv=mat:GetSum(Card.GetLevel)
			Duel.ReleaseRitualMaterial(mat)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		end
	else
		if Duel.IsExistingMatchingCard(cm.check,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,e,tp) then
			local mg=Duel.GetMatchingGroup(cm.check,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e,tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
			local rg=mg:Select(tp,1,1,nil)
			Duel.ReleaseRitualMaterial(rg)
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,cm.spcheck,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
			local tc=sg:GetFirst()
			if tc then
				tc:SetMaterial(rg)
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
				tc:CompleteProcedure()
			end
		end
	end
end