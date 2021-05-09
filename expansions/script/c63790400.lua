--Whisper of Bramble
function c63790400.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	e1:SetValue(c63790400.tnval)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63790400,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,63790400)
	e2:SetCondition(c63790400.spcon)
	e2:SetTarget(c63790400.sptg)
	e2:SetOperation(c63790400.spop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetOperation(c63790400.sppop)
	c:RegisterEffect(e3)
	--lv
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63790400,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,63790401)
	e2:SetTarget(c63790400.tgtg)
	e2:SetOperation(c63790400.tgop)
	c:RegisterEffect(e2)
end
function c63790400.cfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_PLANT) or c:IsRace(RACE_DRAGON))
end
function c63790400.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 or Duel.IsExistingMatchingCard(c63790400.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c63790400.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c63790400.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
		end
		Duel.SpecialSummonComplete()
	end
	function c63790400.sppop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1)
		end
		Duel.SpecialSummonComplete()
	end
end
function c63790400.lvfilter(c)
	return c:GetLevel()>0 and c:IsSetCard(0x123)
end
function c63790400.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.IsExistingMatchingCard(c63790400.lvfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c63790400.lvfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	local lv=e:GetHandler():GetLevel()
	if chk==0 then return lv>0 end
	local opt
	if e:GetLabelObject():GetLevel()<lv then
		opt=Duel.SelectOption(tp,aux.Stringid(63790400,2),aux.Stringid(63790400,3))
	else
		opt=Duel.SelectOption(tp,aux.Stringid(63790400,2))
	end
	e:SetLabel(opt)
end
function c63790400.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabelObject():GetLevel()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if e:GetLabel()==0 then
			e1:SetValue(lv)
		else
			e1:SetValue(-lv)
		end
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end