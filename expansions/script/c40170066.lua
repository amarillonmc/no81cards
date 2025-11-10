--龙炎之剑士
local s,id=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,45231177,36319131,id)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetCost(s.spcost)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,id+1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.thcon)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.cfilter(c,e,tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,c)
	local ft=Duel.GetUsableMZoneCount(tp)
	return c:IsCode(36319131,45231177) and not c:IsPublic() and c:CheckFusionMaterial()
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and ft1>0 and ft2>0 and ft>1
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local tc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.ShuffleExtra(tp)
	tc:CreateEffectRelation(e)
	e:SetLabelObject(tc)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) end
	local g=Group.FromCards(c,e:GetLabelObject())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,2,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,tc)
	local ft=Duel.GetUsableMZoneCount(tp)
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
		and ft1>0 and ft2>0 and ft>1
		and c:IsRelateToEffect(e) then
		if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and tc and tc:IsRelateToEffect(e) then
			tc:SetMaterial(nil)
			if Duel.SpecialSummonStep(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP) then
				tc:CompleteProcedure()
			end
		end
		Duel.SpecialSummonComplete()
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttack()>e:GetHandler():GetBaseAttack()
end
function s.thfilter(c)
	return (c:IsSetCard(0x1ac) and c:IsType(TYPE_SPELL+TYPE_TRAP) or aux.IsCodeListed(c,45231177)) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end