local m=82204246
local cm=_G["c"..m]
cm.name="妖狐一族的律动"
function cm.initial_effect(c)
	--Activate  
	local e1=aux.AddRitualProcEqual2(c,cm.filter,LOCATION_HAND+LOCATION_REMOVED,nil,nil,true)
	c:RegisterEffect(e1) 
	--atk
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,1))  
	e2:SetCategory(CATEGORY_ATKCHANGE)  
	e2:SetType(EFFECT_TYPE_IGNITION)  
	e2:SetRange(LOCATION_GRAVE)  
	e2:SetCondition(cm.atkcon)
	e2:SetCost(cm.atkcost)  
	e2:SetTarget(cm.atktg)  
	e2:SetOperation(cm.atkop)  
	c:RegisterEffect(e2)  
end
cm.SetCard_01_YaoHu=true 
function cm.filter(c)  
	return c.SetCard_01_YaoHu and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) 
end  
function cm.atkfilter(c)  
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c.SetCard_01_YaoHu  
end  
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_MZONE,0,1,nil)  
end  
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end  
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)  
end  
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
end  
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)  
	local tc=Duel.SelectMatchingCard(tp,aux.nzatk,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()  
	if tc then  
		local e1=Effect.CreateEffect(e:GetHandler())  
		e1:SetType(EFFECT_TYPE_SINGLE)  
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)  
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)  
		e1:SetValue(0)  
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)  
		tc:RegisterEffect(e1)  
	end  
end  