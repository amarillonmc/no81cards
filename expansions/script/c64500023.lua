--同盟合击
local m=64500023
local cm=c64500023
function c64500023.initial_effect(c)
		aux.AddCodeList(c,11321183)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.destg) 
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetLabel(0)
	e3:SetCost(cm.atkcost)
	e3:SetTarget(cm.atktg)
	e3:SetOperation(cm.atkop)
	c:RegisterEffect(e3)
end
c64500023.has_text_type=TYPE_UNION
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.filter(c,e,tp)
	return  Duel.IsExistingMatchingCard(cm.eqfilter,tp,LOCATION_SZONE,0,1,nil,e,tp,c)
end
function cm.eqfilter(c,e,tp,ec)
	local op=c:GetOwner()
	return c:IsHasEffect(EFFECT_UNION_STATUS) and c:GetEquipTarget()==ec
end
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,e:GetHandler())end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function cm.thfilter2(c)
	return  c:IsType(TYPE_UNION) and c:IsType(TYPE_MONSTER)and not c:IsForbidden() and Duel.IsExistingMatchingCard(cm.fite,tp,LOCATION_MZONE,0,1,nil,c)
end
function cm.fite(c,ec)
	return c:IsFaceup() and ec:CheckUnionTarget(c) and aux.CheckUnionEquip(ec,c)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	if #g2>0 then
	Duel.HintSelection(g2)
	if Duel.Destroy(g2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter2),tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local sc=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil):GetFirst()
		local tc=Duel.SelectMatchingCard(tp,cm.fite,tp,LOCATION_MZONE,0,1,1,nil,sc):GetFirst()
		Duel.Equip(tp,sc,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(cm.eqlimit)
		e1:SetLabelObject(tc)
		sc:RegisterEffect(e1)
		end
	  end	 
   end
end
function cm.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function cm.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end	
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function cm.cfilter(c)
	return c:IsCode(11321183) and (c:GetBaseAttack()>0 or c:GetBaseDefense()>0) and c:IsAbleToGraveAsCost()
end
function cm.filteratk(c)
	return c:IsFaceup() and c:IsLevelAbove(5)and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_DECK,0,1,nil)
			and Duel.IsExistingTarget(cm.filteratk,tp,LOCATION_MZONE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,cm.filteratk,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local sc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and sc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(sc:GetAttack())
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(sc:GetDefense())
		tc:RegisterEffect(e2)
	end
end