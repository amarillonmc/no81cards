local m=15000290
local cm=_G["c"..m]
cm.name="王战之影 甘洛特"
function cm.initial_effect(c)
	c:SetUniqueOnField(1,0,15000290)
	--decrease atk/def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,15000290)
	e3:SetCost(cm.spcost)
	e3:SetCondition(cm.spcon)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,nil,0x134)*-100
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
end
function cm.spfilter(c,e,tp)
	return c:IsLevel(9) and c:IsSetCard(0x134) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function cm.fselect(g,tp,chk)
	return g:GetClassCount(Card.GetLevel)==1
		and (g:GetCount()==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.IsExistingMatchingCard(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,1,nil,g,g:GetCount(),g:GetCount())
		and aux.dncheck(g)
		and ((chk==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()-1)
		or (chk~=0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=g:GetCount()))
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
	if chkc then return cm.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsPlayerCanSpecialSummonCount(tp,2)
		and (g:CheckSubGroup(cm.fselect,1,1,tp,chk) or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and g:CheckSubGroup(cm.fselect,1,99,tp,chk) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=g:SelectSubGroup(tp,cm.fselect,false,1,99,tp,chk)
	Duel.SetTargetCard(tg)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tg,tg:GetCount(),tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local ag=tg:Filter(Card.IsRelateToEffect,nil,e)
	if (ag:GetCount()~=1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) or Duel.GetLocationCount(tp,LOCATION_MZONE)<ag:GetCount() or ag:GetCount()==0 then return end
	if ag and ag:GetCount()==tg:GetCount() then
		local tc=ag:GetFirst()
		while tc do
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			tc=ag:GetNext()
		end
		Duel.SpecialSummonComplete()
		local xyzg=Duel.GetMatchingGroup(Card.IsXyzSummonable,tp,LOCATION_EXTRA,0,nil,ag,ag:GetCount(),ag:GetCount())
		if xyzg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
			Duel.XyzSummon(tp,xyz,ag)
		end
	end
end