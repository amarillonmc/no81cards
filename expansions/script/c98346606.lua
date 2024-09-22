--死去的女儿
local s,id,o=GetID()
function s.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(c98346606.spcon)
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
function c98346606.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()&(PHASE_DAMAGE+PHASE_DAMAGE_CAL)==0
end
function c98346606.costfilter(c,e)
	return c:IsReleasable() and c:IsFaceup()
end
function c98346606.gcheck(g,e,tp)
	return Duel.IsExistingMatchingCard(c98346606.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,g,g:GetSum(Card.GetBaseAttack))
end
function c98346606.spfilter(c,e,tp,g,atk)
	local atke=Card.GetBaseAttack(e:GetHandler())
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsSetCard(0xaf7) and c:IsAttackBelow(atk+atke)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98346606.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c98346606.costfilter,tp,0,LOCATION_MZONE,nil,e)
	if chk==0 then return e:IsCostChecked() and g:CheckSubGroup(c98346606.gcheck,1,1,e,tp) and e:GetHandler():IsReleasable() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=g:SelectSubGroup(tp,c98346606.gcheck,false,1,1,e,tp)
	sg:AddCard(e:GetHandler())
	local atk=sg:GetSum(Card.GetBaseAttack)
	Duel.Release(sg,REASON_COST)
	e:SetLabel(atk)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98346606.spop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,c98346606.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,nil,atk):GetFirst()
	if sc then
		sc:SetMaterial(nil)
		if Duel.SpecialSummon(sc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)>0 then
			sc:CompleteProcedure()
		end
	end
end
function c98346606.desfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf7)
end
function c98346606.descon(e)
	return not Duel.IsExistingMatchingCard(c98346606.desfilter,e:GetHandler():GetControler(),LOCATION_ONFIELD,0,1,e:GetHandler()) and e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end