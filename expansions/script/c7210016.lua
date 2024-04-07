--善恶幼体 双生
function c7210016.initial_effect(c)
	--attribute dark
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetRange(0xff+LOCATION_OVERLAY)
	e0:SetValue(ATTRIBUTE_DARK) 
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,7210016)
	e1:SetCondition(c7210016.spcon)
	e1:SetCost(c7210016.spcost)
	e1:SetTarget(c7210016.sptg)
	e1:SetOperation(c7210016.spop)
	c:RegisterEffect(e1)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,17210016)
	e2:SetCondition(c7210016.macon)
	e2:SetTarget(c7210016.matg)
	e2:SetOperation(c7210016.maop)
	c:RegisterEffect(e2)
	--Immune
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7210016,2))
	e3:SetType(EFFECT_TYPE_XMATERIAL)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	--count
	Duel.AddCustomActivityCounter(7210016,ACTIVITY_SPSUMMON,c7210016.counterfilter)
end
function c7210016.counterfilter(c)
	return c:IsSetCard(0x6f8)
end
function c7210016.cfilter(c)
	return c:IsFacedown() or c:IsSetCard(0x6f8)
end
function c7210016.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return ct==Duel.GetMatchingGroupCount(c7210016.cfilter,tp,LOCATION_ONFIELD,0,nil)
end
function c7210016.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(7210016,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c7210016.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c7210016.splimit(e,c)
	return not c:IsSetCard(0x6f8)
end
function c7210016.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	e:GetHandler():RegisterFlagEffect(7210016,RESET_EVENT+RESET_CHAIN,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
end
function c7210016.thfilter(c)
	return c:IsSetCard(0x6f8) and c:IsAbleToHand()
end
function c7210016.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c7210016.thfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(7210016,0)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c7210016.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
			if tc:IsType(TYPE_MONSTER) and tc:IsLevelBelow(4) and tc:IsLocation(LOCATION_HAND) and Duel.SelectYesNo(tp,aux.Stringid(7210016,1)) then
				Duel.BreakEffect()
				Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end
function c7210016.tgfilter(c,e,tp,eg)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e) and c:IsControler(tp) and eg:IsContains(c) and c:IsType(TYPE_XYZ) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c7210016.macon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c7210016.tgfilter,1,nil,e,tp,eg)
end
function c7210016.matg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and eg:IsContains(chkc) end
	if chk==0 then return eg:IsExists(c7210016.tgfilter,1,nil,e,tp,eg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c7210016.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg)
end
function c7210016.maop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
