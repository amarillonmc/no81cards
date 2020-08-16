--升阶魔法-蜘蛛网络
function c49966675.initial_effect(c)
	 --activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c49966675.condition)
	e1:SetTarget(c49966675.target)
	e1:SetOperation(c49966675.activate)
	c:RegisterEffect(e1)
end
function c49966675.condition(e,tp,eg,ep,ev,re,r,rp)
	return  ep==tp and ev>=2000
end
function c49966675.spfilter(c,e,tp)
  return c:IsSetCard(0x1048)
		 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c49966675.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c49966675.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c49966675.exfilter1(c)
	return c:IsFacedown() and c:IsType(TYPE_XYZ) 
end
function c49966675.exfilter2(c)
	local rk=c:GetRank()
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function c49966675.fselect(g,ft1,ft2,ect,ft)
	return aux.dncheck(g) and #g<=ft and #g<=ect
		and g:FilterCount(c49966675.exfilter1,nil)<=ft1
		and g:FilterCount(c49966675.exfilter2,nil)<=ft2
end
function c49966675.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft1=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_XYZ)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		if ft>0 then ft=1 end
	end
	local ect=(c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]) or ft
	if ect>0 and (ft1>0 or ft2>0) then
		local sg=Duel.GetMatchingGroup(c49966675.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if sg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local rg=sg:SelectSubGroup(tp,c49966675.fselect,false,1,4,ft1,ft2,ect,ft)
			if rg:GetCount()>0 then
				local fid=c:GetFieldID()
				local tc=rg:GetFirst()
				while tc do
					Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
					tc=rg:GetNext()
				end
   Duel.SpecialSummonComplete()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		end
	end
end
end