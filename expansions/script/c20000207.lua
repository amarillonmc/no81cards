--红莲团奥义 月夜见
local cm,m,o=GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local sc=Duel.GetAttackTarget()
	return sc and sc:IsControler(tp)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(Duel.GetAttackTarget())
end
function cm.tg1f1(c,tp)
	return Duel.IsExistingMatchingCard(cm.tg1f2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,tp,c)
end
function cm.tg1f2(c,tp,tc)
	return c:IsSetCard(0x5fd2) and c:IsType(TYPE_EQUIP) and c:CheckEquipTarget(tc) 
		and c:CheckUniqueOnField(tp) and not c:IsForbidden()and aux.IsCodeListed(tc,c:GetCode())
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateAttack() then return end
	local sc=Duel.GetFirstTarget()
	if not sc:IsRelateToEffect(e) then return end
	local atk=Duel.GetAttacker():GetAttack()
	if sc:GetEquipCount()==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local tc=Duel.SelectMatchingCard(tp,cm.tg1f1,tp,LOCATION_EXTRA,0,1,1,nil,tp):GetFirst()
		if not tc then return end
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tg1f2),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,tp,tc):GetFirst()
		if tc then Duel.Equip(tp,tc,sc) end
	else
		Duel.Draw(tp,atk//1000,REASON_EFFECT)
	end
end