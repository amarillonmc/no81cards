local m=31400104
local cm=_G["c"..m]
cm.name="巨石遗物·奥林匹亚"
if not cm.hack then
	cm.hack=true
	function cm._GRM_ex_filter(c)
		return not (c:IsLocation(LOCATION_GRAVE) and c:IsHasEffect(m) and c:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL) and not c:IsAbleToDeck())
	end
	cm._GetRitualMaterial=Duel.GetRitualMaterial
	function Duel.GetRitualMaterial(tp)
		local g=cm._GetRitualMaterial(tp)
		g:Filter(cm._GRM_ex_filter,nil)
		return g
	end
	cm._ReleaseRitualMaterial=Duel.ReleaseRitualMaterial
	function Duel.ReleaseRitualMaterial(mat)
		local tdg=mat:Filter(Card.IsHasEffect,nil,m)
		if #tdg>0 then
			mat:Sub(tdg)
			Duel.Hint(HINT_CARD,0,m)
			Duel.SendtoDeck(tdg,nil,2,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		end
		cm._ReleaseRitualMaterial(mat)
	end
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cm.srcon)
	e1:SetTarget(cm.srtg)
	e1:SetOperation(cm.srop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_EXTRA_RITUAL_MATERIAL)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(cm.exrmtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(m)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.srcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function cm.srfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.srgfilter(g,lv)
	return g:GetSum(Card.GetLevel)<=lv
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroup(cm.srfilter,tp,LOCATION_DECK,0,nil):CheckSubGroup(cm.srgfilter,nil,nil,e:GetHandler():GetLevel()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.GetMatchingGroup(cm.srfilter,tp,LOCATION_DECK,0,nil)
	aux.GCheckAdditional=aux.dncheck
	local tg=g:SelectSubGroup(tp,cm.srgfilter,false,1,#g,e:GetHandler():GetLevel())
	aux.GCheckAdditional=nil
	if tg:GetCount()>0 then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function cm.exrmtg(e,c)
	return c:IsSetCard(0x138)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		local mg=Duel.GetRitualMaterial(tp)
		mg:RemoveCard(c)
		aux.GCheckAdditional=aux.RitualCheckAdditional(c,16,"Greater")
		local res=mg:CheckSubGroup(aux.RitualCheck,1,16,tp,c,16,"Greater")
		aux.GCheckAdditional=nil
		return res and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,e:GetHandler():GetLocation())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.NecroValleyFilter(nil)(c) then return end
	local mg=Duel.GetRitualMaterial(tp)
	mg:RemoveCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	aux.GCheckAdditional=aux.RitualCheckAdditional(c,16,"Greater")
	mat=mg:SelectSubGroup(tp,aux.RitualCheck,false,1,16,tp,c,16,"Greater")
	aux.GCheckAdditional=nil
	c:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
	c:CompleteProcedure()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(16)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
end