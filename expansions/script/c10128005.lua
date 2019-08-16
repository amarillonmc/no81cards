--奇妙物语 红烧南瓜
function c10128005.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128005,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c10128005.target)
	e1:SetOperation(c10128005.activate)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128005,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c10128005.sptg)
	e2:SetOperation(c10128005.spop)
	c:RegisterEffect(e2) 
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3) 
end
function c10128005.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and chkc:IsControler(tp) and c10128005.spfilter(chkc,e,tp) end
	if chk==0 then return eg:IsExists(c10128005.spfilter,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=eg:FilterSelect(tp,c10128005.spfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c10128005.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0x6336,0x21,0,0,1,RACE_PLANT,ATTRIBUTE_LIGHT) then return end
	tc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_LIGHT,RACE_PLANT,1,0,0)
	Duel.SpecialSummonStep(tc,1,tp,tp,true,false,POS_FACEUP)
	--tc:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
end
function c10128005.spfilter(c,e,tp)
	return c:IsControler(tp) and bit.band(c:GetType(),0x10002)==0x10002 and c:IsCanBeEffectTarget(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,0,0,1,RACE_PLANT,ATTRIBUTE_LIGHT)
end
function c10128005.filter(c)
	return c:IsFaceup() and c:IsSummonType(SUMMON_TYPE_SPECIAL) and c:IsAbleToRemove()
end
function c10128005.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,0,0,LOCATION_MZONE)
end
function c10128005.activate(e,tp,eg,ep,ev,re,r,rp)
	local pg=Duel.GetMatchingGroup(c10128005.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if pg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10128005,2)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSITION)
	local tc=pg:Select(tp,1,1,nil):GetFirst()
	if Duel.Remove(tc,0,REASON_EFFECT+REASON_TEMPORARY)~=0 then
	   tc:RegisterFlagEffect(36553319,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	   local e1=Effect.CreateEffect(e:GetHandler())
	   e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	   e1:SetCode(EVENT_PHASE+PHASE_END)
	   e1:SetReset(RESET_PHASE+PHASE_END)
	   e1:SetLabelObject(tc)
	   e1:SetCountLimit(1)
	   e1:SetCondition(c10128005.retcon)
	   e1:SetOperation(c10128005.retop)
	   Duel.RegisterEffect(e1,tp)
	end
end
function c10128005.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabelObject():GetFlagEffect(36553319)~=0
end
function c10128005.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
