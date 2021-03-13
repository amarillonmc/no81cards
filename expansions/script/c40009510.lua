--旭光之骑士 格吉特
function c40009510.initial_effect(c)
	aux.AddCodeList(c,40009510)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009510,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	--e1:SetCountLimit(1,40009510)
	e1:SetTarget(c40009510.sptg1)
	e1:SetOperation(c40009510.spop1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(40009510,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCountLimit(1,40009510)
	e3:SetCondition(c40009510.spcon)
	e3:SetTarget(c40009510.sptg)
	e3:SetOperation(c40009510.spop)
	c:RegisterEffect(e3)
end
function c40009510.filter1(c,e,tp)
	return c:IsRace(RACE_WARRIOR) and c:IsLevelBelow(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c40009510.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c40009510.filter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c40009510.spop1(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c40009510.filter1,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c40009510.spcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO 
end
function c40009510.spfilter(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) and not c:IsCode(40009510) and c:IsCanBeEffectTarget(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009510.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local mg=e:GetHandler():GetReasonCard():GetMaterial()
	if chkc then return mg:IsContains(chkc) and c40009510.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and mg:IsExists(c40009510.spfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=mg:FilterSelect(tp,c40009510.spfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c40009510.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local sel=0
			local lvl=1
			if tc:IsLevel(1) then
				sel=Duel.SelectOption(tp,aux.Stringid(40009510,2))
			else
				sel=Duel.SelectOption(tp,aux.Stringid(40009510,2),aux.Stringid(40009510,3))
			end
			if sel==1 then
				lvl=-1
			end
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_LEVEL)
			e1:SetValue(lvl)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
		end
	end
end


