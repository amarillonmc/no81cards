--鏖灭的狂王 千劫
function c32131309.initial_effect(c)
	aux.AddCodeList(c,32131308) 
	--xyz summon
	aux.AddXyzProcedure(c,c32131309.mfilter,8,2)
	c:EnableReviveLimit() 
	--code 
	local e0=Effect.CreateEffect(c) 
	e0:SetType(EFFECT_TYPE_SINGLE) 
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(0xff)  
	e0:SetValue(32131308) 
	c:RegisterEffect(e0)
	--xyz 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SPSUMMON_SUCCESS) 
	e1:SetProperty(EFFECT_FLAG_DELAY) 
	e1:SetCountLimit(1,32131309) 
	e1:SetTarget(c32131309.xyztg) 
	e1:SetOperation(c32131309.xyzop) 
	c:RegisterEffect(e1) 
	c32131309.sp_effect=e1 
	--atk
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(32131309,1))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetCode(EVENT_FREE_CHAIN)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1) 
	e2:SetCost(c32131309.calcost)  
	e2:SetTarget(c32131309.xatktg) 
	e2:SetOperation(c32131309.xatkop) 
	c:RegisterEffect(e2)  
	--cal 
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(32131309,2))
	e3:SetType(EFFECT_TYPE_QUICK_O) 
	e3:SetCode(EVENT_FREE_CHAIN) 
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)   
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,32131309) 
	e3:SetCost(c32131309.calcost)  
	e3:SetTarget(c32131309.caltg) 
	e3:SetOperation(c32131309.calop) 
	c:RegisterEffect(e3)  
	--atk 
	--local e3=Effect.CreateEffect(c) 
	--e3:SetCategory(CATEGORY_DRAW)
	--e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	--e3:SetCode(EVENT_BATTLE_DESTROYING) 
	--e3:SetCountLimit(1,23131309) 
	--e3:SetCondition(aux.bdocon)
	--e3:SetTarget(c32131309.atktg)
	--e3:SetOperation(c32131309.atkop)
	--c:RegisterEffect(e3)
end
c32131309.SetCard_HR_flame13=true 
c32131309.HR_Flame_CodeList=32131308 
function c32131309.mfilter(c) 
	return c.SetCard_HR_flame13 
end 
function c32131309.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,1,nil) end 
end 
function c32131309.xyzop(e,tp,eg,ep,ev,re,r,rp)   
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsCanOverlay,tp,LOCATION_GRAVE,0,nil)
	if g:GetCount()>0 then 
	   local og=g:Select(tp,1,1,nil) 
	   if c:IsRelateToEffect(e) then 
	   Duel.Overlay(c,og) 
	   end 
	end 
end 
function c32131309.calcost(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end 
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)

end 
function c32131309.xatktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
end 
function c32131309.xatkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil) 
	local xg,atk=g:GetMaxGroup(Card.GetAttack) 
	if c:IsRelateToEffect(e) and atk>0 then 
		local e1=Effect.CreateEffect(c) 
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK) 
		e1:SetRange(LOCATION_MZONE) 
		e1:SetValue(atk) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END) 
		c:RegisterEffect(e1)  
	end 
end 
function c32131309.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131309.caltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return (e:GetHandler():IsAttackPos() or e:GetHandler():IsHasEffect(EFFECT_DEFENSE_ATTACK)) and Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil) and e:GetHandler():GetFlagEffect(32131309)==0 and Duel.IsExistingMatchingCard(c32131309.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler())  end 
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
end 
function c32131309.calop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if c:IsRelateToEffect(e) and c:IsFaceup() and tc:IsRelateToEffect(e) then 
	--damage val
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_NO_BATTLE_DAMAGE)
	e5:SetValue(1) 
	e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e5)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e8:SetValue(1) 
	e8:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_CHAIN)
	c:RegisterEffect(e8)
	Duel.CalculateDamage(c,tc) 
	end 
	if c:IsRelateToEffect(e) then
		c:RegisterFlagEffect(32131309,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,2)
	end
end 

function c32131309.atktg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end   
function c32131309.atkop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	if c:IsRelateToEffect(e) and c:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	c:RegisterEffect(e1) 
	end 
end 







