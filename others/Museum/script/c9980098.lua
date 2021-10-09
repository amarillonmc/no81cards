--风神录-神明的威光
function c9980098.initial_effect(c)
   --xyz summon
	aux.AddXyzProcedure(c,nil,3,2,c9980098.ovfilter,aux.Stringid(9980098,0),2,c9980098.xyzop)
	c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980098,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980098)
	e1:SetCost(c9980098.spcost)
	e1:SetTarget(c9980098.sptg)
	e1:SetOperation(c9980098.spop)
	c:RegisterEffect(e1)
 --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980098,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c9980098.sumcon)
	e1:SetTarget(c9980098.sumtg)
	e1:SetOperation(c9980098.sumop)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980098.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9980098.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980098,2))
end
function c9980098.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x3bc6) and c:IsLevelAbove(4)
end
function c9980098.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,9980098)==0 end
	Duel.RegisterFlagEffect(tp,9980098,RESET_PHASE+PHASE_END,0,1)
end
function c9980098.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9980098.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c9980098.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,15341822,0,0x4011,0,0,1,RACE_PLANT,ATTRIBUTE_WIND) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,15341822)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
function c9980098.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and ep~=tp
end
function c9980098.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c9980098.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end