-- 新昼地的扎营
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,47320301,47320352)
    local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)

	s.continuous_effect(c)
	s.detach_effect(c)
	s.banish_effect(c)
end
function s.continuous_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(s.atktg)
	e1:SetValue(500)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function s.atktg(e,c)
	return c:IsSetCard(0x5c17) or aux.IsCodeListed(c,47320301)
end

function s.detach_effect(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
end
function s.thfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.xyzfilter(c)
    if not c:IsFaceup() then return false end
    if not c:IsType(TYPE_XYZ) then return false end
    if not c:IsSetCard(0x5c17) then return false end
    local og=c:GetOverlayGroup()
	return og:IsExists(s.thfilter,1,nil)
end
function s.spfilter2(c,e,tp)
	return c:IsSetCard(0x5c17) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_OVERLAY)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
    local mg=tc:GetOverlayGroup():Filter(s.thfilter,nil)
	if tc:IsRelateToEffect(e) and #mg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local bc=mg:Select(tp,1,1,nil):GetFirst()
		if Duel.SendtoHand(bc,nil,REASON_EFFECT)~=0 then
			Duel.ConfirmCards(1-tp,bc)
			if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
				and Duel.IsExistingMatchingCard(s.spfilter2,tp,LOCATION_HAND,0,1,nil,e,tp)
				and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=Duel.SelectMatchingCard(tp,s.spfilter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
				if #sg>0 then
					Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function s.banish_effect(c)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCountLimit(1,id-1000)
	e4:SetCost(aux.bfgcost)
	e4:SetTarget(s.sptg2)
	e4:SetOperation(s.spop2)
	c:RegisterEffect(e4)
end
function s.spfilter3(c,e,tp)
	return c:IsSetCard(0x5c17) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
