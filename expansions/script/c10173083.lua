--混沌融合生物
function c10173083.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10173083,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10173083)
	e1:SetCondition(c10173083.spcon)
	e1:SetOperation(c10173083.spop)
	c:RegisterEffect(e1) 
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10173083,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c10173083.spcost2)
	e2:SetTarget(c10173083.sptg2)
	e2:SetOperation(c10173083.spop2)
	c:RegisterEffect(e2)  
end
function c10173083.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_EXTRA,0,1,nil,TYPE_FUSION) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10173083.ffilter0(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173083.ffilter(c,mg,fc)
	return mg:IsExists(c10173083.ffilter2,1,c,fc,c)
end
function c10173083.ffilter2(c,fc,rc)
	local mg=Group.FromCards(c,rc)
	return fc:CheckFusionMaterial(mg,c) and fc:CheckFusionMaterial(mg,rc)
end
function c10173083.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local fc=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_EXTRA,0,1,1,nil,TYPE_FUSION):GetFirst()
	if not fc then return end
	Duel.ConfirmCards(1-tp,fc)
	local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c10173083.ffilter0),tp,LOCATION_HAND+LOCATION_GRAVE,0,c,e,tp)
	if mg:IsExists(c10173083.ffilter,1,nil,mg,fc) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.SelectYesNo(tp,aux.Stringid(10173083,2)) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local tc=mg:FilterSelect(tp,c10173083.ffilter,1,1,nil,mg,fc):GetFirst()
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=mg:FilterSelect(tp,c10173083.ffilter2,1,1,tc,fc,tc)
	   g:AddCard(tc)
	   for tc in aux.Next(g) do
		   if  Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			   local e1=Effect.CreateEffect(c)
			   e1:SetType(EFFECT_TYPE_SINGLE)
			   e1:SetCode(EFFECT_DISABLE)
			   e1:SetReset(RESET_EVENT+0x1fe0000)
			   tc:RegisterEffect(e1,true)
			   local e2=Effect.CreateEffect(c)
			   e2:SetType(EFFECT_TYPE_SINGLE)
			   e2:SetCode(EFFECT_DISABLE_EFFECT)
			   e2:SetReset(RESET_EVENT+0x1fe0000)
			   tc:RegisterEffect(e2,true)
		   end
	   end
	   Duel.SpecialSummonComplete()
	end
end
function c10173083.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c10173083.spfilter(c,tp)
	return c10173083.spfilter2(c) and Duel.GetMZoneCount(tp,c,tp)>0
end
function c10173083.spfilter2(c)
	return ((c:IsType(TYPE_SPELL) and c:IsSetCard(0x46)) or c:IsType(TYPE_FUSION)) and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsAbleToRemoveAsCost() 
end
function c10173083.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c10173083.spfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_ONFIELD,0,1,c,tp)
end
function c10173083.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c10173083.spfilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,1,c,tp)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
end
