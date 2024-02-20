local m=82207012
local cm=_G["c"..m]
cm.name="白悠悠"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,cm.matfilter1,nil,nil,aux.NonTuner(nil),1,99)
	--indes  
	local e3=Effect.CreateEffect(c)  
	e3:SetType(EFFECT_TYPE_SINGLE)  
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e3:SetValue(1)  
	c:RegisterEffect(e3)  
	local e4=e3:Clone()  
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetValue(aux.indoval)
	c:RegisterEffect(e4)  
	local e5=e3:Clone()   
	e5:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)  
	c:RegisterEffect(e5)
	--negate  
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_QUICK_O)  
	e1:SetCode(EVENT_CHAINING)  
	e1:SetCountLimit(1)  
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCondition(cm.discon)  
	e1:SetTarget(cm.distg)  
	e1:SetOperation(cm.disop)  
	c:RegisterEffect(e1)  
end
function cm.matfilter1(c)
	return c:IsSynchroType(TYPE_TUNER) or c:IsCode(27288416)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)  
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)  
end  
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)  
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then  
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)  
	end  
end  
function cm.disop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)>0 then
		Duel.BreakEffect()
		local dg=Duel.GetFieldGroup(tp,LOCATION_ONFIELD,0)
		local sg=dg:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end  
end  
