--祭礼暗庭 骷莉特
function c3076.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3076,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c3076.sgtg)
	e2:SetOperation(c3076.sgop)
	c:RegisterEffect(e2)
	--overlay
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(3076,1))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetCondition(c3076.ovcon)
	e3:SetTarget(c3076.ovtg)
	e3:SetOperation(c3076.ovop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(3076,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCost(c3076.spcost)
	e4:SetTarget(c3076.sptg)
	e4:SetOperation(c3076.spop)
	c:RegisterEffect(e4)
end 
function c3076.sgfilter(c)
	return c:IsSetCard(0x851) and c:IsAbleToGrave()
end
function c3076.sgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c3076.sgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c3076.sgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c3076.sgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c3076.ovfilter(c,e,tp,mc)
	return c:IsSetCard(0x851) and mc:IsCanBeXyzMaterial(c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c3076.ovcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsLocation(LOCATION_GRAVE) and c:IsReason(REASON_BATTLE)
end
function c3076.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local rc=e:GetHandler():GetReasonCard()
	Duel.SetTargetCard(rc)
end
function c3076.ovop(e,tp,eg,ep,ev,re,r,rp)
	local rc=Duel.GetFirstTarget()
	if rc:IsRelateToEffect(e) and not Duel.GetControl(rc,tp) then
		if not rc:IsImmuneToEffect(e) and rc:IsAbleToChangeControler() then
			Duel.Destroy(rc,REASON_EFFECT)
		end
		return
	end
	Duel.BreakEffect()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	if rc:IsFacedown() or not rc:IsRelateToEffect(e) or rc:IsControler(1-tp) or rc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3076.ovfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rc)
	local sc=g:GetFirst()
	if sc then
		local mg=rc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		local c=e:GetHandler()
		if c:IsRelateToEffect(e) and sc:IsRelateToEffect(e) and not sc:IsImmuneToEffect(e) then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(rc,c))
		Duel.Overlay(sc,Group.FromCards(rc,c))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end 
end
function c3076.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c3076.filter(c,e,tp)
	return c:IsSetCard(0x851) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c3076.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c3076.filter,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)  
end
function c3076.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c3076.filter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end