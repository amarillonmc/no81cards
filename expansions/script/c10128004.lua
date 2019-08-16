--奇妙物语 黏黏糖虫
function c10128004.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10128004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c10128004.target)
	e1:SetOperation(c10128004.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10128004,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c10128004.sptg)
	e2:SetOperation(c10128004.spop)
	c:RegisterEffect(e2) 
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3) 
end
function c10128004.spfilter2(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x6336) and c:GetSequence()<5 and Duel.IsPlayerCanSpecialSummonMonster(tp,c:GetCode(),0x6336,0x21,0,0,1,RACE_INSECT,ATTRIBUTE_LIGHT)
end
function c10128004.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) and c10128004.spfilter2(chkc,tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(c10128004.spfilter2,tp,LOCATION_SZONE,0,1,e:GetHandler(),tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c10128004.spfilter2,tp,LOCATION_SZONE,0,1,1,e:GetHandler(),tp)
	g:AddCard(e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,tp,LOCATION_SZONE)
end
function c10128004.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc,c=Duel.GetFirstTarget(),e:GetHandler()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() or Duel.IsPlayerAffectedByEffect(tp,59822133) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetCode(),0x6336,0x21,0,0,1,RACE_INSECT,ATTRIBUTE_WIND) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Group.FromCards(c,tc)
	for rc in aux.Next(g) do
		rc:AddMonsterAttribute(TYPE_EFFECT,ATTRIBUTE_WIND,RACE_INSECT,1,0,0)
		Duel.SpecialSummonStep(rc,1,tp,tp,true,false,POS_FACEUP)
		--rc:AddMonsterAttributeComplete()
	end
	Duel.SpecialSummonComplete()
end
function c10128004.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,0,tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end
function c10128004.spfilter(c,e,tp)
	return c:IsSetCard(0x6336) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c10128004.cfilter(c,e,tp,rc)
	local g=Group.FromCards(c,rc)
	return c:IsSetCard(0x6336) and c:IsReleasableByEffect() and Duel.IsExistingMatchingCard(c10128004.cfilter2,tp,LOCATION_ONFIELD,0,1,g,c,tp,e)
end
function c10128004.cfilter2(c,rc,tp,e)
	local g=Group.FromCards(c,rc)
	return c:IsSetCard(0x6336) and c:IsReleasableByEffect() and Duel.GetLocationCountFromEx(tp,tp,g)>0 and Duel.IsExistingMatchingCard(c10128004.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
end
function c10128004.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=Duel.GetMatchingGroup(c10128004.cfilter,tp,LOCATION_ONFIELD,0,c,e,tp,c)
	if cg:GetCount()<=0 or not Duel.SelectYesNo(tp,aux.Stringid(10128004,1)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc1=cg:Select(tp,1,1,nil):GetFirst()
	local g=Group.FromCards(c,tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c10128004.cfilter2,tp,LOCATION_ONFIELD,0,1,1,g,tc1,tp,e)
	rg:AddCard(tc1)
	Duel.Release(rg,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c10128004.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end