--韶光的祈福 希尔维娅
function c9910463.initial_effect(c)
	c:EnableCounterPermit(0x950)
	--link summon
	aux.AddLinkProcedure(c,c9910463.matfilter,3,99,c9910463.lcheck)
	c:EnableReviveLimit()
	--extra material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_EXTRA_LINK_MATERIAL)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c9910463.matval)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c9910463.condition)
	e2:SetTarget(c9910463.target)
	e2:SetOperation(c9910463.operation)
	c:RegisterEffect(e2)
end
function c9910463.matfilter(c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c9910463.lcheck(g)
	local res=true
	local loct={}
	for i=1,6 do loct[i]=0 end
	local tc=g:GetFirst()
	while tc do
		if tc:GetSummonLocation()==LOCATION_HAND then loct[1]=loct[1]+1
		elseif tc:GetSummonLocation()==LOCATION_DECK then loct[2]=loct[2]+1
		elseif tc:GetSummonLocation()==LOCATION_GRAVE then loct[3]=loct[3]+1
		elseif tc:GetSummonLocation()==LOCATION_EXTRA then loct[4]=loct[4]+1
		elseif tc:GetSummonLocation()==LOCATION_REMOVED then loct[5]=loct[5]+1
		elseif tc:GetSummonLocation()==LOCATION_SZONE then loct[6]=loct[6]+1
		else res=false end
		tc=g:GetNext()
	end
	for i=1,6 do
		if loct[i]>1 then res=false end
	end
	return res
end
function c9910463.matval(e,lc,mg,c,tp)
	local ct=Duel.GetMatchingGroupCount(c9910463.sgfilter,tp,LOCATION_MZONE,0,nil)
	if e:GetHandler()~=lc or ct==0 then return false,nil end
	return true,not mg or not mg:IsExists(Card.IsControler,ct,nil,1-tp)
end
function c9910463.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9910463.spfilter(c,e,tp)
	return c:IsSetCard(0x9950) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
		and (c:IsLocation(LOCATION_GRAVE) and Duel.GetMZoneCount(tp)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
end
function c9910463.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910463.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function c9910463.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local loc=LOCATION_ONFIELD 
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9910463.spfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0
		and Duel.GetMatchingGroupCount(Card.IsCanAddCounter,tp,loc,loc,nil,0x950,1)>0 then
		local ct=3
		while ct>0 do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
			local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,loc,loc,1,1,nil,0x950,1):GetFirst()
			if not tc then break end
			tc:AddCounter(0x950,1)
			ct=ct-1
		end
	end
end
