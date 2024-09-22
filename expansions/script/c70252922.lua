--命运女郎·蒂琪
function c70252922.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c70252922.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--level up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(70252922,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetOperation(c70252922.lvop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(70252922,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,70252922)
	e4:SetCondition(c70252922.spcon)
	e4:SetCost(c70252922.spcost)
	e4:SetTarget(c70252922.sptg)
	e4:SetOperation(c70252922.spop)
	c:RegisterEffect(e4)
end
function c70252922.value(e,c)
	return c:GetLevel()*300
end
function c70252922.spfilter(c,e,tp,lv)
	return c:IsType(TYPE_SYNCHRO) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLevel(lv)
end
function c70252922.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelAbove(12) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_SMATERIAL) then return end
	local lv=c:GetLevel()
	local sg=Duel.GetMatchingGroup(c70252922.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,lv)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(70252922,2)) and c:IsReleasableByEffect() then
		Duel.Release(c,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=sg:Select(tp,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
			tc:CompleteProcedure()
		end
	end
end
function c70252922.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c70252922.cfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsSetCard(0x31)
end
function c70252922.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c70252922.cfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local tg=Duel.SelectMatchingCard(tp,c70252922.cfilter,tp,LOCATION_GRAVE,0,1,99,e:GetHandler())
	e:SetLabel(Duel.Remove(tg,POS_FACEUP,REASON_COST))
end
function c70252922.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c70252922.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(ct)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end
