--Gradation Air
function c9950564.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c9950564.eqtg)
	e1:SetOperation(c9950564.eqop)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c9950564.effcon)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(400)
	c:RegisterEffect(e3)
	--battle indestructable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
 --activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c9950564.actcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9950564,1))
	e3:SetCategory(CATEGORY_DESTROY)
	 e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,9950564)
	e3:SetCost(c9950564.descost)
	e3:SetTarget(c9950564.destg)
	e3:SetOperation(c9950564.desop)
	c:RegisterEffect(e3)
end
function c9950564.effcon(e,c)
	return c:IsSetCard(0x6ba6)
end
function c9950564.eqfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x6ba6)
end
function c9950564.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c9950564.eqfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9950564.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c9950564.eqfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c9950564.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
	end
end
function c9950564.actcon(e)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==e:GetHandler():GetControler() and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
function c9950564.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	local tc=e:GetHandler():GetEquipTarget()
	Duel.SetTargetCard(tc)
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9950564.desfilter(c,g)
	return g:IsContains(c)
end
function c9950564.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=c:GetEquipTarget()
	if chk==0 then
		if not ec then return false end
		local tg=ec:GetColumnGroup()
		tg:AddCard(ec)
		return Duel.IsExistingMatchingCard(c9950564.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tg)
	end
	local tc=Duel.GetFirstTarget()
	local tg=tc:GetColumnGroup()
	tg:AddCard(tc)
	local g=Duel.GetMatchingGroup(c9950564.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tg)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c9950564.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local tg=tc:GetColumnGroup()
	tg:AddCard(tc)
	local g=Duel.GetMatchingGroup(c9950564.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
 Duel.Hint(HINT_MUSIC,0,aux.Stringid(9950566,0))
end