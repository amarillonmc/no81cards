local m=98876566
local cm=_G["c"..m]
cm.name="狩谷 旋豹"
function cm.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),aux.FilterBoolFunction(Card.IsFusionType,TYPE_EFFECT),true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,98876566)
	e2:SetCondition(cm.spcon)
	e2:SetTarget(cm.sptg)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(cm.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--to hand
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BE_MATERIAL)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,98876567)
	e4:SetCondition(cm.thcon)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCost(cm.sp2cost)
	e5:SetTarget(cm.sp2tg)
	e5:SetOperation(cm.sp2op)
	c:RegisterEffect(e5)
end
function cm.splimit(e,se,sp,st)
	return (se:GetHandler():IsSetCard(0x989) or se:GetHandler():GetType()==TYPE_SPELL) or not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function cm.codefilter(c)
	local x=0
	for _,i in ipairs{c:GetFusionCode()} do
		if i~=c:GetOriginalCodeRule() then x=1 end
	end
	return x==1 or (c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousCodeOnField()~=c:GetOriginalCodeRule())
end
function cm.valcheck(e,c)
	local flag=0
	local g=c:GetMaterial()
	if g:IsExists(cm.codefilter,1,nil) then
		flag=1
	end
	e:GetLabelObject():SetLabel(flag)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 and e:GetLabel()==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98876572,0x989,TYPES_TOKEN_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp) end
	if chk==0 and e:GetLabel()==1 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98876572,0x989,TYPES_TOKEN_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp) end
	if e:GetLabel()==0 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	end
	if e:GetLabel()==1 then
		Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=1
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98876572,0x989,TYPES_TOKEN_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp) then
		local token=Duel.CreateToken(tp,98876572)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
	end
	if e:GetLabel()==1 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsPlayerCanSpecialSummonMonster(tp,98876572,0x989,TYPES_TOKEN_MONSTER,0,0,1,RACE_CYBERSE,ATTRIBUTE_DARK,POS_FACEUP_DEFENSE,tp) then
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
		local token1=Duel.CreateToken(tp,98876572)
		Duel.SpecialSummonStep(token1,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local token2=Duel.CreateToken(tp,98876572)
		Duel.SpecialSummonStep(token2,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		Duel.SpecialSummonComplete()
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_REMOVED) and c:IsFaceup()) and r==REASON_FUSION
end
function cm.thfilter(c)
	return c:IsCode(24094653,65801012) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE+LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cfilter(c,ft,tp)
	return ft>0 or (c:IsControler(tp) and c:GetSequence()<5)
end
function cm.rfilter(c)
	return c:IsReleasable() and c:IsSetCard(0x989)
end
function cm.rcheck(g,ft,tp)
	if g:GetCount()~=2 then return false end
	if ft>0 then return g:FilterCount(cm.rfilter,nil)==2 end
	if ft==0 then return g:IsExists(cm.cfilter,1,nil,0,tp) and g:FilterCount(cm.rfilter,nil)==2 end
	return false
end
function cm.sp2cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
		return ft>-1 and g:CheckSubGroup(cm.rcheck,2,2,ft,tp)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_MZONE,LOCATION_MZONE)
	local sg=g:SelectSubGroup(tp,cm.rcheck,false,2,2,ft,tp)
	Duel.Release(sg,REASON_COST)
end
function cm.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.sp2op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end