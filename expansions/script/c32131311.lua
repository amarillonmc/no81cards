--戒律的苦修 阿波尼亚
function c32131311.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_BRAINWASHING_CHECK)
	aux.AddCodeList(c,32131310) 
	--xyz summon
	aux.AddXyzProcedure(c,c32131311.mfilter,8,2)
	c:EnableReviveLimit() 
	--code 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff)  
	e0:SetValue(32131310) 
	c:RegisterEffect(e0)
	--xyz 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,32131311) 
	e1:SetTarget(c32131311.xyztg) 
	e1:SetOperation(c32131311.xyzop) 
	c:RegisterEffect(e1) 
	c32131311.sp_effect=e1 
	--cal 
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN) 
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,23131311) 
	e2:SetCost(c32131311.calcost)  
	e2:SetTarget(c32131311.caltg) 
	e2:SetOperation(c32131311.calop) 
	c:RegisterEffect(e2)  
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_REMOVE_BRAINWASHING)
	e3:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	c:RegisterEffect(e3)
end
c32131311.SetCard_HR_flame13=true 
c32131311.HR_Flame_CodeList=32131310 
function c32131311.mfilter(c) 
	return c.SetCard_HR_flame13 
end 
function c32131311.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_DECK,1,nil) end 
end 
function c32131311.xyzop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetDecktopGroup(1-tp,5)
	if g:GetCount()>=5 then 
	   Duel.ConfirmCards(tp,g)
	   local og=g:Select(tp,1,1,nil) 
	   if c:IsRelateToEffect(e) then 
	   Duel.Overlay(c,og) 
	   end 
	end 
end 
function c32131311.calcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST) 
end 
function c32131311.cckfil(c) 
	return (c:IsAttackPos() or c:IsHasEffect(EFFECT_DEFENSE_ATTACK)) and c:IsFaceup() and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) 
end 
function c32131311.caltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c32131311.cckfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end 
	Duel.SelectTarget(tp,c32131311.cckfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
end 
function c32131311.calop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,tc) then  
	local bc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,tc):GetFirst() 
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetValue(1) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	tc:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e8:SetValue(1) 
	e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	tc:RegisterEffect(e8)
	Duel.CalculateDamage(tc,bc) 
	end 
end 
function c32131311.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131311.ctlcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c32131311.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
