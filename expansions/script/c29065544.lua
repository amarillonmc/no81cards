--方舟骑士-菲亚梅塔·炽炎无霾
function c29065544.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,29065543,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,true,true)
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)	   
	--atk 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e1:SetValue(c29065544.atlimit) 
	e1:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(99)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c29065544.spcon)
	e3:SetTarget(c29065544.sptg)
	e3:SetOperation(c29065544.spop)
	c:RegisterEffect(e3)
end
function c29065544.atlimit(e,c)
	return not e:GetHandler():GetColumnGroup():IsContains(c)
end
function c29065544.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 
end
function c29065544.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToExtra() end 
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
end
function c29065544.spfil(c,e,tp) 
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsCode(29065543)
end
function c29065544.spop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) then 
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
	if Duel.IsExistingMatchingCard(c29065544.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(29065544,1)) then 
	local sg=Duel.SelectMatchingCard(tp,c29065544.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp) 
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	end 
end











