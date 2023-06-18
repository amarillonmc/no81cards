--吸血鬼的呼唤者
function c98920149.initial_effect(c)
	 --atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920149,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,98920149)
	e1:SetTarget(c98920149.atktg1)
	e1:SetOperation(c98920149.atkop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c98920149.atkfilter1(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:GetAttack()>0
end
function c98920149.afilter(c,e,tp)
	return c:IsSetCard(0x8e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98920149.cfilter(c,e,tp)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsSetCard(0x8e)
		and Duel.IsExistingMatchingCard(c98920149.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,c:GetLevel())
end
function c98920149.spfilter(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c98920149.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local op=e:GetLabel()
		return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE)
			and (op==0 and c98920149.afilter(chkc,e,tp) or op==1 and c98920149.dfilter(chkc,e,tp))
	end
	local b1=Duel.IsExistingTarget(c98920149.afilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=Duel.IsExistingTarget(c98920149.cfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (b1 or b2) end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(98920149,0),aux.Stringid(98920149,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(98920149,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(98920149,1))+1
	end
	e:SetLabel(op)
	local filter=c98920149.afilter
	if op==1 then filter=c98920149.cfilter end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c98920149.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local op=e:GetLabel()
	if tc:IsRelateToEffect(e) then
		if op==0 then
		   Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	end
	if op==1 then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920149.spfilter),tp,0,LOCATION_GRAVE,1,1,nil,e,tp,tc:GetLevel()):GetFirst()
		if sc and Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_CHANGE_RACE)
			 e1:SetValue(RACE_ZOMBIE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 sc:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end