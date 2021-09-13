--言叶无限欺 联合
local m=33403528
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	 XY.magane(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)

end
function cm.cfilter(c)
	return c:IsSetCard(0x6349) and c:IsAbleToGraveAsCost()
end
function cm.costfilter1(c)
	return  c:IsSetCard(0x6349) or c:IsCode(33403520) 
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil) and Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,e:GetHandler()) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g1=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	local tc=g1:GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
 Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.filter(c)
	return c:IsCode(33403520) and c:IsFaceup()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)  end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,0,nil)
	if g:GetCount()>0  then
		local g2=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local atk=g2:GetSum(Card.GetAttack)
		local def=g2:GetSum(Card.GetDefense)	   
		local tc=g:GetFirst()
		while tc do
			if atk>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(atk)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)	  
			end
			if def>0 then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_DEFENSE)
				e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(def)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)	  
			end
			local ss=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil):GetCount()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(ss)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.atktg(e,c)
	return not c:IsCode(33403520)
end