--无限的蛇主 梅比乌斯
function c32131313.initial_effect(c)
	aux.AddCodeList(c,32131312)
	aux.AddMaterialCodeList(c,32131312)
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(32131312) 
	c:RegisterEffect(e0)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,32131312,c32131313.mfilter,1,true,true) 
	aux.AddContactFusionProcedure(c,Card.IsReleasable,LOCATION_MZONE,0,Duel.Release,REASON_COST+REASON_MATERIAL)
	--search
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,32131313)
	e1:SetTarget(c32131313.thtg)
	e1:SetOperation(c32131313.thop)
	c:RegisterEffect(e1) 
	c32131313.sp_effect=e1 
	--token 
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_IGNITION) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1) 
	e2:SetTarget(c32131313.tktg) 
	e2:SetOperation(c32131313.tkop) 
	c:RegisterEffect(e2) 
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,23321313)
	e3:SetCondition(c32131313.spcon)
	e3:SetTarget(c32131313.sptg)
	e3:SetOperation(c32131313.spop)
	c:RegisterEffect(e3)
end
c32131313.SetCard_HR_flame13=true 
c32131313.HR_Flame_CodeList=32131312 
function c32131313.mfilter(c) 
	return c.SetCard_HR_flame13 
end 
function c32131313.thfilter(c)
	return c.SetCard_HR_flame13 and c:IsAbleToHand() and c:IsType(TYPE_SPELL)
end
function c32131313.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32131313.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c32131313.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c32131313.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end 
end
function c32131313.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil) 
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0) 
end 
function c32131313.tkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then  
	local token=Duel.CreateToken(tp,32131213) 
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CHANGE_RACE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(tc:GetRace()) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1,true) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_CHANGE_ATTRIBUTE) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(tc:GetAttribute()) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1,true) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_ATTACK_FINAL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(tc:GetAttack()) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1,true) 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_SET_DEFENSE_FINAL) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(tc:GetDefense()) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	token:RegisterEffect(e1,true) 
	Duel.SpecialSummonComplete()
	end 
end 
function c32131313.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)  
end
function c32131313.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c32131313.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then 
	end
	Duel.SpecialSummonComplete()
end



