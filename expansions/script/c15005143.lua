local m=15005143
local cm=_G["c"..m]
cm.name="完型神的定义"
function cm.initial_effect(c)
	aux.AddCodeList(c,15005130)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--redirect
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCondition(cm.recon)
	e0:SetValue(LOCATION_DECKBOT)
	c:RegisterEffect(e0)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
end
function cm.recon(e)
	return e:GetHandler():IsFaceup()
end
function cm.spfilter(c,e,tp,sc)
	return (aux.IsCodeListed(c,15005130) or c:IsCode(15005130)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.rfilter(c,e,tp)
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_MACHINE) and Duel.GetMZoneCount(tp,c)>=1 and g:CheckSubGroup(cm.spgcheck,1,#g,c) and c:IsReleasable() and c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.spgcheck(g,sc)
	return g:GetSum(Card.GetLevel)>=sc:GetLevel()+2
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.rfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) and Duel.IsPlayerCanSpecialSummon(tp) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sc=Duel.SelectMatchingCard(tp,cm.rfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if sc and Duel.Release(sc,REASON_EFFECT)~=0 and Duel.IsPlayerCanSpecialSummon(tp) then
		local ct=1
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local spg=Group.CreateGroup()
		local check=0
		while (ct<=dcount and check==0) do
			local g=Duel.GetDecktopGroup(tp,ct)
			local fg=g:Filter(cm.spfilter,nil,e,tp,sc)
			if fg:CheckSubGroup(cm.spgcheck,1,#fg,sc) then
				check=1
				spg=fg
			end
			ct=ct+1
		end
		if check==0 then
			Duel.ConfirmDecktop(tp,dcount)
			Duel.ShuffleDeck(tp)
			return
		end
		Duel.ConfirmDecktop(tp,ct-1)
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 or spg:GetCount()==0 then return end
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
		if ft>=1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spcg=Group.CreateGroup()
			if ft>=spg:GetCount() then
				spcg=spg
			else
				spcg=spg:Select(tp,ft,ft,nil)
			end
			local tc=spcg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				tc=spcg:GetNext()
			end
			Duel.SpecialSummonComplete()
		end
	end
end