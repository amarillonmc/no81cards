--迷石宫的空想
function c60000038.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WATER),3,true)
	--act limit  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(0,1)  
	e3:SetValue(c60000038.aclimit)  
	c:RegisterEffect(e3)  
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(60000038,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c60000038.thcon)
	e3:SetTarget(c60000038.thtg)
	e3:SetOperation(c60000038.thop)
	c:RegisterEffect(e3) 
end
function cm.aclimit(e,re,tp)  
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():GetLevel()<=e:GetHandler():GetLevel() 
end
function c60000038.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c60000038.thfilter(c)
	return c:IsSetCard(0xfc) and not c:IsCode(60000038) and c:IsAbleToHand()
end
function c60000038.filter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:CheckFusionMaterial() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsSetCard(0x625) 
end
function c60000038.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return ux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL)
	and Duel.IsExistingMatchingCard(c60000038.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp)end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c60000038.thop(e,tp,eg,ep,ev,re,r,rp)
	if not aux.MustMaterialCheck(nil,tp,EFFECT_MUST_BE_FMATERIAL) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c60000038.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if not tc then return end
	tc:SetMaterial(nil)
	Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	tc:CompleteProcedure()
	Duel.Hint(HINT_SOUND,0,aux.Stringid(60000038,1))
end





