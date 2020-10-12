function c82221054.initial_effect(c)
	aux.EnablePendulumAttribute(c)   
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetCode(EFFECT_SPSUMMON_PROC)  
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,82221054)  
	e1:SetCondition(c82221054.spcon)  
	c:RegisterEffect(e1) 
	--place
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(82221054,0))  
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e2:SetCountLimit(1,82231054)  
	e2:SetTarget(c82221054.pentg)  
	e2:SetOperation(c82221054.penop)  
	c:RegisterEffect(e2) 
	--pierce  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(82221054,1))  
	e3:SetType(EFFECT_TYPE_IGNITION)   
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)  
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCountLimit(1)  
	e3:SetTarget(c82221054.ptg)  
	e3:SetOperation(c82221054.pop)  
	c:RegisterEffect(e3)  
end  
 
function c82221054.spcon(e,c)  
	if c==nil then return true end  
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0  
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0  
end  
function c82221054.penfilter(c)  
	return c:IsSetCard(0x99) and c:IsType(TYPE_PENDULUM) and not c:IsCode(82221054) and not c:IsForbidden()  
end  
function c82221054.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(c82221054.penfilter,tp,LOCATION_DECK,0,1,nil) and Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_PZONE,0,nil)~=2 end 
end  
function c82221054.penop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)  
	local g=Duel.SelectMatchingCard(tp,c82221054.penfilter,tp,LOCATION_DECK,0,1,1,nil)  
	local tc=g:GetFirst()  
	if tc then  
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)   
	end  
end  
function c82221054.pfilter(c)  
	return c:IsFaceup() and not c:IsHasEffect(EFFECT_PIERCE) 
end  
function c82221054.ptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end  
	if chk==0 then return Duel.IsExistingTarget(c82221054.pfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.IsAbleToEnterBP() end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	Duel.SelectTarget(tp,c82221054.pfilter,tp,LOCATION_MZONE,0,1,1,nil)  
end  
function c82221054.pop(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()  
	if tc:IsRelateToEffect(e) then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_PIERCE)  
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end  