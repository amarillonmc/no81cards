--死去的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(c98346606.sptg)
	e1:SetOperation(c98346606.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--selfdestroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c98346606.descon)
	c:RegisterEffect(e3)
end
function c98346606.tgfilter(c,e,tp,atk,mc)
	return c:IsReleasable() and c:IsFaceup() and c:GetBaseAttack()>=0
		and Duel.IsExistingMatchingCard(c98346606.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,atk+c:GetBaseAttack(),Group.FromCards(c,mc))
end
function c98346606.spfilter(c,e,tp,atk,mg)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsSetCard(0xaf7) and c:IsAttackBelow(atk)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0
end
function c98346606.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local atk=c:GetBaseAttack()
	if chk==0 then return Duel.IsExistingTarget(c98346606.tgfilter,tp,0,LOCATION_MZONE,1,nil,e,tp,atk,c)
		and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectTarget(tp,c98346606.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp,atk,c)
	g:AddCard(c)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98346606.spop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	if not c:IsRelateToEffect(e) or not tc:IsRelateToEffect(e) then return end
	local g=Group.FromCards(c,tc)
	if Duel.Release(g,REASON_EFFECT)==2 and c:GetBaseAttack()>=0 and tc:GetBaseAttack()>=0 then
		local atk=c:GetBaseAttack()+tc:GetBaseAttack()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=Duel.SelectMatchingCard(tp,c98346606.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,atk,nil)
		local sc=sg:GetFirst()
		if sc then
			sc:SetMaterial(nil)
			if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
				sc:CompleteProcedure()
			end
		end
	end
end
function c98346606.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf7)
end
function c98346606.descon(e)
	return not Duel.IsExistingMatchingCard(c98346606.desfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,e:GetHandler()) and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end