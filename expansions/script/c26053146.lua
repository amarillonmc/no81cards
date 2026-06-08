-- 雷霆仪·火
local m=26053146
local cm=_G["c"..m]
function cm.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target1)
	e1:SetOperation(cm.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m+1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.thfilter(c)
	return c:IsSetCard(0xeae9) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.matfilter(c)
	return c:IsSetCard(0xeae9) and c:IsLocation(LOCATION_DECK) and c:IsAbleToGrave()
end
function cm.rfilter(c)
	return c:IsRace(RACE_THUNDER)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,nil)
		local exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_DECK,0,nil,cm.matfilter)
		return Duel.IsExistingMatchingCard(Auxiliary.RitualUltimateFilter,tp,LOCATION_GRAVE,0,1,nil,cm.rfilter,e,tp,mg,exg,Card.GetLevel,"Equal",true)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	::RitualUltimateSelectStart::
	local mg=Duel.GetRitualMaterial(tp):Filter(cm.matfilter,nil)
	local exg=Duel.GetMatchingGroup(Auxiliary.RitualExtraFilter,tp,LOCATION_DECK,0,nil,cm.matfilter)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,Auxiliary.NecroValleyFilter(Auxiliary.RitualUltimateFilter),tp,LOCATION_GRAVE,0,1,1,nil,cm.rfilter,e,tp,mg,exg,Card.GetLevel,"Equal")
	local tc=tg:GetFirst()
	local mat
	if tc then
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if exg then
			mg:Merge(exg)
		end
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,tc,tp)
		else
			mg:RemoveCard(tc)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local lv=Card.GetLevel(tc)
		Auxiliary.GCheckAdditional=Auxiliary.RitualCheckAdditional(tc,lv,"Equal")
		mat=mg:SelectSubGroup(tp,Auxiliary.RitualCheck,true,1,lv,tp,tc,lv,"Equal")
		Auxiliary.GCheckAdditional=nil
		if not mat then goto RitualUltimateSelectStart end
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,POS_FACEUP,REASON_RITUAL+REASON_EFFECT+REASON_MATERIAL)
		--Duel.ReleaseRitualMaterial(mat)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetLabel(tp)
    e1:SetOperation(cm.retop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1, tp)
end
function cm.retop(e,tp,eg,ep,ev,re,r,rp)
    local tp=e:GetLabel()
    local g=Duel.GetFieldGroup(tp, LOCATION_MZONE, 0)
    if #g>0 then
        Duel.SendtoHand(g, nil, REASON_EFFECT)
    end
end