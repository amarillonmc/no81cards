--动物朋友 御神牛様
local m=33711402
local cm=_G["c"..m]
function cm.initial_effect(c)
   --link summon
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
	c:EnableReviveLimit()   
	--Sps
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x442) and g:GetClassCount(Card.GetCode)==#g and g:GetSum(Card.GetLevel)>=21
end
function cm.spfilter(c,tp,zone)
	local seq=c:GetPreviousSequence()
	if c:GetPreviousControler()~=tp then seq=seq+16 end
	return c:IsPreviousLocation(LOCATION_MZONE) and bit.extract(zone,seq)~=0 and c:IsSetCard(0x442)
end
function cm.spfilter1(c,e,tp,tc)
	local code=tc:GetCode()
	if c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)<=0 then return false end
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,false,POS_FACEUP) 
end
function cm.spop(e,tp,eg)
	local sg=eg:Filter(cm.spfilter,nil,tp,e:GetHandler():GetLinkedZone())
	if sg:GetCount()>0 then
		for tc in aux.Next(sg) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local spg=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,tc)
			if spg:GetCount()>0 then
				Duel.SpecialSummonStep(spg:GetFirst(),0,tp,tp,true,false,POS_FACEUP)
			end
		end
		Duel.SpecialSummonComplete()
	end
end