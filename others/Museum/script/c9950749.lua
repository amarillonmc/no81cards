--罗马·神祖罗穆路斯
function c9950749.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,7,4,c9950749.ovfilter,aux.Stringid(9950749,1),4,c9950749.xyzop)
	c:EnableReviveLimit()
   local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_ONFIELD+LOCATION_GRAVE,0)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(9950690)
	c:RegisterEffect(e2)
 local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9950749,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9950749)
	e1:SetCost(c9950749.cost)
	e1:SetTarget(c9950749.target)
	e1:SetOperation(c9950749.operation)
	c:RegisterEffect(e1)
  --special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9950749,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c9950749.spcon)
	e2:SetTarget(c9950749.sptg)
	e2:SetOperation(c9950749.spop)
	c:RegisterEffect(e2)
--spsummon bgm
	 local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9950749.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
end
function c9950749.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950749,0))
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950749,2))
end
function c9950749.cfilter(c)
	return c:IsSetCard(0xba5) and c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c9950749.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xcba8) and c:IsType(TYPE_SYNCHRO)
end
function c9950749.xyzop(e,tp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9950749.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c9950749.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c9950749.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c9950749.filter(c,e,tp)
	return c:IsSetCard(0xcba8) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9950749.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c9950749.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c9950749.filter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c9950749.filter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c9950749.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
 Duel.Hint(HINT_SOUND,0,aux.Stringid(9950749,3))
end
function c9950749.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c9950749.spfilter(c,e,tp)
	return c:IsSetCard(0xba5) and not c:IsCode(9950749) and c:IsType(TYPE_XYZ) and c:IsRankBelow(7)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c9950749.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL)
		and Duel.IsExistingMatchingCard(c9950749.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
		and e:GetHandler():IsCanOverlay() end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9950749.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_XMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9950749.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)~=0 then
		tc:CompleteProcedure()
		if c:IsRelateToEffect(e) then
			Duel.Overlay(tc,Group.FromCards(c))
		end
	end
end
