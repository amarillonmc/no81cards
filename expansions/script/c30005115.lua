--六域六躯六魂
local m=30005115
local cm=_G["c"..m]
function cm.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_SPSUMMON_COUNT)
	--Effect 1  
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Effect 1
function cm.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and  (c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA)
		or c:IsFaceup())
end
function cm.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
end
function cm.fselect(g)
	return g:GetClassCount(Card.GetLocation)==g:GetCount() 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(cm.spfilter1,tp,0,LOCATION_GRAVE,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_PZONE,0,nil,e,tp)
	if chk==0 then return  g:GetClassCount(Card.GetLocation)>3 
		and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and #g1~=0 and #g2~=0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_REMOVED,0,nil,e,tp)
	local g1=Duel.GetMatchingGroup(cm.spfilter1,tp,0,LOCATION_GRAVE,nil,e,tp)
	local g2=Duel.GetMatchingGroup(cm.spfilter1,tp,LOCATION_PZONE,0,nil,e,tp)
	if Duel.GetLocationCountFromEx(tp,tp,nil,c)==0 
		or #g==0 or #g1==0 or #g2==0
		or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,cm.fselect,false,4,4)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local sg2=g2:Select(tp,1,1,nil)
	if #sg~=0 and #sg1~=0 and #sg2~=0 then
		sg:Merge(sg1)
		sg:Merge(sg2)
		if sg:GetCount()==6 then
			local tc=sg:GetFirst()
			while tc do
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_SET_ATTACK_FINAL)
				e1:SetValue(0)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
				e2:SetValue(0)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				tc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				tc:RegisterEffect(e3)
				local e4=Effect.CreateEffect(c)
				e4:SetType(EFFECT_TYPE_SINGLE)
				e4:SetCode(EFFECT_DISABLE_EFFECT)
				e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
				tc:RegisterEffect(e4)
				tc=sg:GetNext()
			end
			Duel.SpecialSummonComplete()		
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_COUNT_LIMIT)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end

