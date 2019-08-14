--阴の所在 两仪式
function c60151202.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60151202.condition2)
	e1:SetOperation(c60151202.desop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(60151202,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,60151202)
	e2:SetCondition(c60151202.spcon)
	e2:SetTarget(c60151202.sptg)
	e2:SetOperation(c60151202.spop)
	c:RegisterEffect(e2)
	--ritual level
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(c60151202.rlevel)
	c:RegisterEffect(e3)
end
function c60151202.rlevel(e,c)
	local lv=e:GetHandler():GetLevel()
	if c:IsSetCard(0xab23) then
		local clv=c:GetLevel()
		return lv*65536+clv
	else return lv end
end
function c60151202.condition2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup()
end
function c60151202.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if c:GetBattleTarget()==nil then return end
	if tc:IsRelateToBattle() and tc:IsFaceup() and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) then
		if c:GetFlagEffect(60151298)>0 then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,0))
			Duel.Hint(HINT_CARD,0,60151202)
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			local atk=c:GetAttack()
			local atk1=tc:GetAttack()
			local def1=tc:GetDefense()
			if atk>atk1 or atk>def1 then
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(60151201,1))
				Duel.Hint(HINT_CARD,0,60151202)
				Duel.SendtoGrave(tc,REASON_RULE)
			end
		end
	end
end
function c60151202.cfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsType(TYPE_MONSTER)
end
function c60151202.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60151202.cfilter,1,nil)
end
function c60151202.filter(c,e,tp)
	return c:IsSetCard(0xab23) and c:GetCode()~=60151202 and c:IsType(TYPE_MONSTER)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c60151202.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c60151202.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c60151202.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60151202.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end