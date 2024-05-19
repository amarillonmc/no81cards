--异帽机的渴求
local m=21080010
local cm=_G["c"..m]
function cm.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_MONSTER),3,99,cm.lcheck)
	c:EnableReviveLimit()
	aux.AddCodeList(c,15005130)
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(m,1))
	e13:SetCategory(CATEGORY_REMOVE)
	e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	e13:SetRange(LOCATION_MZONE)
	e13:SetTarget(cm.destg)
	e13:SetOperation(cm.desop)
	c:RegisterEffect(e13)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.lcheck(g)
	return g:IsExists(aux.IsCodeListed,3,nil,15005130) or (g:IsExists(aux.IsCode,1,nil,15005130) and g:IsExists(aux.IsCodeListed,2,nil,15005130)) or (g:IsExists(aux.IsCode,2,nil,15005130) and g:IsExists(aux.IsCodeListed,1,nil,15005130)) or (g:IsExists(aux.IsCode,3,nil,15005130))
end
function cm.desfilter1(c)
	return Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cm.cfilter(c,ec)
	return c:IsFaceup() and ec:GetLinkedGroup():IsContains(c) and Duel.IsExistingMatchingCard(nil,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c)
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter1,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,cm.desfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	if #g1==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,g1)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
end
function cm.spfilter(c,e,tp,sc)
	return (aux.IsCodeListed(c,15005130) or c:IsCode(15005130)) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp,sc)>=1
end
function cm.spgcheck(g)
	return g:GetSum(Card.GetLevel)>=10
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_DECK,0,nil,e,tp,c)
		return e:GetHandler():IsReleasable() and Duel.IsPlayerCanSpecialSummon(tp) and g:CheckSubGroup(cm.spgcheck) and not Duel.IsPlayerAffectedByEffect(tp,63060238) and not Duel.IsPlayerAffectedByEffect(tp,97148796)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsReleasable()) then return end
	if Duel.Release(c,REASON_EFFECT)~=0 and Duel.IsPlayerCanSpecialSummon(tp) then
		local ct=1
		local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
		local spg=Group.CreateGroup()
		local check=0
		while (ct<=dcount and check==0) do
			local g=Duel.GetDecktopGroup(tp,ct)
			local fg=g:Filter(cm.spfilter,nil,e,tp,c)
			if fg:CheckSubGroup(cm.spgcheck) then
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
			if ft<=Duel.GetLocationCount(tp,LOCATION_MZONE) then
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