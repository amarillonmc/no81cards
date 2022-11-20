--机构瓦解
function c10113008.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCountLimit(1,10113008+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c10113008.cost)
	e1:SetTarget(c10113008.target)
	e1:SetOperation(c10113008.activate)
	c:RegisterEffect(e1)	
end
function c10113008.costfilter(c,tp)
	local ft=Duel.GetLocationCount(c:GetOwner(),LOCATION_MZONE)
	return c:IsFaceup() and c:IsRace(RACE_MACHINE) and (c:GetRank()>0 or c:GetLevel()>0) and c:IsAbleToDeckOrExtraAsCost() and Duel.IsPlayerCanSpecialSummonMonster(tp,10113009,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,c:GetOwner()) and ((c:GetControler()==c:GetOwner() and ft>-1) or (c:GetControler()~=c:GetOwner() and ft>0))
end
function c10113008.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function c10113008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c10113008.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c10113008.costfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
	e:SetLabelObject(g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c10113008.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ft,ft2=Duel.GetLocationCount(tc:GetOwner(),LOCATION_MZONE),0
	if ft<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,10113009,0,0x4011,0,0,1,RACE_MACHINE,ATTRIBUTE_EARTH,POS_FACEUP_DEFENSE,tc:GetOwner()) then return end
	local rc=0
	if tc:IsType(TYPE_XYZ) then rc=tc:GetOriginalRank()
	else rc=tc:GetOriginalLevel()
	end
	if ft>rc then ft=rc end
	local t={}
	local i=1
	local p=1
	for i=1,ft do 
		t[p]=i p=p+1
	end
	t[p]=nil
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft2=1
	else
	   Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10113008,0))
	   ft2=Duel.AnnounceNumber(tp,table.unpack(t))
	end
	for i=1,ft2 do
		local token=Duel.CreateToken(tp,10113009)
		Duel.SpecialSummonStep(token,0,tp,tc:GetOwner(),false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
end