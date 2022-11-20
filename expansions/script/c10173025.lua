--骑装火狮
function c10173025.initial_effect(c)
	c:SetSPSummonOnce(10173025)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_BEAST),2,false)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_FUSION+REASON_MATERIAL)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c10173025.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10173025,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c10173025.sptg)
	e3:SetOperation(c10173025.spop)
	c:RegisterEffect(e3)
end
function c10173025.splimit(e,se,sp,st)
	return e:GetHandler():GetLocation()~=LOCATION_EXTRA
end
function c10173025.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10173025.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c10173025.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c10173025.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c10173025.spfilter),tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
	if tc then
	   if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
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
		   Duel.SpecialSummonComplete()
	   end
	   if not c:IsRelateToEffect(e) or c:IsLocation(LOCATION_SZONE) or c:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10173025,1)) then 
	   return end
	   Duel.BreakEffect()
	   if not Duel.Equip(tp,c,tc) then return end
	   local e3=Effect.CreateEffect(c)
	   e3:SetType(EFFECT_TYPE_SINGLE)
	   e3:SetCode(EFFECT_EQUIP_LIMIT)
	   e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e3:SetValue(c10173025.eqlimit)
	   e3:SetLabelObject(tc)
	   e3:SetReset(RESET_EVENT+0x1fe0000)
	   c:RegisterEffect(e3)
	   local e4=Effect.CreateEffect(c)
	   e4:SetType(EFFECT_TYPE_EQUIP)
	   e4:SetCode(EFFECT_UPDATE_ATTACK)
	   e4:SetValue(2500)
	   e4:SetReset(RESET_EVENT+0x1fe0000)
	   c:RegisterEffect(e4)
	end
end
function c10173025.eqlimit(e,c)
	return c==e:GetLabelObject()
end