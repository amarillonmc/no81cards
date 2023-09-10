--邪心英雄 黯银刃魔
function c77000421.initial_effect(c) 
	aux.AddCodeList(c,94820406)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c77000421.xsplimit)
	c:RegisterEffect(e1) 
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,77000421)
	e1:SetCost(c77000421.spcost)
	e1:SetTarget(c77000421.sptg)
	e1:SetOperation(c77000421.spop)
	c:RegisterEffect(e1)
end
function c77000421.xsplimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0x6008)  
end
function c77000421.cfilter(c,tp)
	return c:IsControler(tp) and c:IsReleasable() and c:IsSetCard(0x6008) and Duel.GetMZoneCount(tp,c)>0 
end
function c77000421.spcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return Duel.IsExistingMatchingCard(c77000421.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,e:GetHandler(),tp) end
	local g=Duel.SelectMatchingCard(tp,c77000421.cfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,e:GetHandler(),tp)
	Duel.Release(g,REASON_COST)
end
function c77000421.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c77000421.thfil(c)
	return c:IsAbleToHand() and (aux.IsCodeListed(c,94820406) or c:IsCode(94820406)) 
end 
function c77000421.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP_DEFENSE)~=0 and Duel.IsExistingMatchingCard(c77000421.thfil,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(77000421,0)) then 
		local sg=Duel.SelectMatchingCard(tp,c77000421.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(sg,tp,REASON_EFFECT) 
		Duel.ConfirmCards(1-tp,sg)   
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c77000421.splimit) 
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
end
function c77000421.splimit(e,c)
	return not c:IsRace(RACE_FIEND) 
end






