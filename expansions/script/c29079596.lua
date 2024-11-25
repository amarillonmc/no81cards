--方舟骑士-特蕾西娅
c29079596.named_with_Arknight=1
function c29079596.initial_effect(c)
	aux.AddCodeList(c,29065500)
	--effect gain
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c29079596.sprcon)
	e1:SetOperation(c29079596.sprop)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_HAND+LOCATION_GRAVE,0)
	e2:SetTarget(c29079596.eftg)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--flag
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(c29079596.regop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCountLimit(1,29079596+EFFECT_COUNT_CODE_DUEL)
	e4:SetTarget(c29079596.sptg)
	e4:SetOperation(c29079596.spop)
	c:RegisterEffect(e4)
end
function c29079596.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetFlagEffect(tp,c:GetOriginalCode()+29079596)<1
end
function c29079596.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	c:RegisterFlagEffect(29079596,RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END,0,1)
end
function c29079596.eftg(e,c)
	local b1=c:IsSetCard(0x87af)
	local b2=(_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)
	return (b1 or b2) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_MONSTER) and not c:IsCode(29079596)
end
function c29079596.cfilter(c)
	return c:GetFlagEffect(29079596)>0
end
function c29079596.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c29079596.cfilter,nil)
	for tc in aux.Next(g) do
		Duel.RegisterFlagEffect(tp,tc:GetOriginalCode()+29079596,RESET_PHASE+PHASE_END,0,1)
	end
end
function c29079596.spfilter(c,e,tp)
	return c:IsCode(29065500) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29079596.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29079596.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c29079596.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c29079596.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
		tc:CopyEffect(29079596,RESET_EVENT+RESETS_STANDARD)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(29079596,0))
	end
end
