--机巧忍者 九九八一
function c98940033.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,c98940033.matfilter,2,2)
	--must attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e0)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c98940033.matcheck)
	c:RegisterEffect(e1)
	--direct attack
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetCode(EFFECT_DIRECT_ATTACK)
	e12:SetRange(LOCATION_MZONE)
	e12:SetTargetRange(LOCATION_MZONE,0)
	e12:SetLabelObject(e1)
	e12:SetCondition(c98940033.xacon)
	e12:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x11))
	c:RegisterEffect(e12)
	--be target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98940033,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_BECOME_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e2:SetCondition(c98940033.spcon)
	e2:SetTarget(c98940033.sptg)
	e2:SetOperation(c98940033.spop)
	c:RegisterEffect(e2)
 --negate attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98940033,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetTarget(c98940033.natg)
	e1:SetOperation(c98940033.naop)
	c:RegisterEffect(e1)
end
function c98940033.matfilter(c)  
	return c:IsLinkSetCard(0x11)
end  
function c98940033.matcheck(e,c)
	local c=e:GetHandler()
	local g=c:GetMaterial()
	if g:IsExists(c98940033.cfilter,1,nil) then
	   e:SetLabel(1)
	else 
	   e:SetLabel(0)
	end
end
function c98940033.cfilter(c)
	return c:IsSetCard(0x11) and c:IsSetCard(0x2b)
end
function c98940033.xacon(e)
	local flag=e:GetLabelObject():GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and flag==1
end
function c98940033.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsContains(e:GetHandler()) and Duel.IsChainDisablable(ev)
end
function c98940033.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98940033.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98940033.spfilter(c,e,tp)
	return c:IsSetCard(0x11) and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false)
end
function c98940033.natg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
end
function c98940033.naop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.NegateAttack() and c:IsRelateToEffect(e) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c98940033.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(98940033,2)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g1=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(g1,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98940033.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if not Duel.NegateEffect(ev) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98940033.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
	end
end