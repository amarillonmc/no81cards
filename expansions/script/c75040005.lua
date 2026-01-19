--金鳞楼兰
function c75040005.initial_effect(c)
	aux.AddCodeList(c,75040001)
	c:SetUniqueOnField(1,0,75040005)
	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(75040005,2))
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(c75040005.handcon)
	c:RegisterEffect(e0)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--battle damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(2000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetTargetRange(0,1)
	e2:SetValue(1500)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c75040005.eqcon)
	e3:SetTarget(c75040005.eqtg)
	e3:SetOperation(c75040005.eqop)
	c:RegisterEffect(e3)
end
function c75040005.hcfilter(c)
	return c:IsCode(75040001) and c:IsFaceup()
end
function c75040005.handcon(e)
	return Duel.IsExistingMatchingCard(c75040005.hcfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c75040005.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsRace(RACE_WYRM)
end
function c75040005.tcfilter(tc,ec)
	return tc:IsFaceup() and ec:CheckEquipTarget(tc)
end
function c75040005.ecfilter(c)
	return c:IsType(TYPE_EQUIP) and Duel.IsExistingTarget(c75040005.tcfilter,0,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function c75040005.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chck:IsControler(tp) and c75040005.ecfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c75040005.ecfilter,tp,LOCATION_GRAVE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c75040005.ecfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,ec,1,0,0)
end
function c75040005.eqop(e,tp,eg,ep,ev,re,r,rp)
	local ec=Duel.GetFirstTarget()
	if not ec:IsRelateToChain() or not aux.NecroValleyFilter()(ec) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectTarget(tp,c75040005.tcfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,ec):GetFirst()
	if not tc then return end
	Duel.HintSelection(Group.FromCards(tc))
	Duel.Equip(tp,ec,tc)
end
