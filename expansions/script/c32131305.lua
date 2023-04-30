--天慧的觉者 苏
function c32131305.initial_effect(c)
	aux.AddCodeList(c,32131304)
	aux.AddMaterialCodeList(c,32131304) 
	--code
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_ADD_CODE) 
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE) 
	e0:SetRange(0xff) 
	e0:SetValue(13131304) 
	c:RegisterEffect(e0)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsCode,32131304),aux.NonTuner(nil),1)
	c:EnableReviveLimit()   
	--public  
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY) 
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_FREE_CHAIN) 
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,32131305) 
	e1:SetCondition(c32131305.pbcon)
	e1:SetTarget(c32131305.pbtg) 
	e1:SetOperation(c32131305.pbop)  
	c:RegisterEffect(e1) 
	--atk up 
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O) 
	e2:SetCode(EVENT_TO_GRAVE) 
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET) 
	e2:SetCountLimit(1,23131305) 
	e2:SetTarget(c32131305.atktg) 
	e2:SetOperation(c32131305.atkop) 
	c:RegisterEffect(e2) 
end
c32131305.SetCard_HR_flame13=true 
c32131305.HR_Flame_CodeList=32131304 
function c32131305.ckfil(c) 
	return c:IsFaceup() and c.SetCard_HR_flame13   
end 
function c32131305.pbcon(e,tp,eg,ep,ev,re,r,rp) 
	return Duel.IsExistingMatchingCard(c32131305.ckfil,tp,LOCATION_MZONE,0,1,e:GetHandler()) 
end 
function c32131305.pbtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end 
end  
function c32131305.pbop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PUBLIC) 
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end 
function c32131305.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc) 
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end 
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil) 
end  
function c32131305.atkop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then 
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE) 
	e1:SetCode(EFFECT_UPDATE_ATTACK) 
	e1:SetRange(LOCATION_MZONE) 
	e1:SetValue(2500) 
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	tc:RegisterEffect(e1) 
	end 
end 






