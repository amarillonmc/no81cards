--人理之诗 童子切安纲
function c22023480.initial_effect(c)
	aux.AddCodeList(c,22022320,22023410)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c22023480.target)
	e1:SetOperation(c22023480.operation)
	c:RegisterEffect(e1)
	--Equip limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EQUIP_LIMIT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetValue(c22023480.eqlimit)
	c:RegisterEffect(e2)
	--Atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetValue(1200)
	c:RegisterEffect(e3)
	--disable
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_BE_BATTLE_TARGET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetCondition(c22023480.discon1)
	e4:SetOperation(c22023480.disop1)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetTarget(c22023480.distg)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e6)
	--dice
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(22023480,0))
	e7:SetCategory(CATEGORY_DICE+CATEGORY_TOHAND)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetTarget(c22023480.dctg)
	e7:SetOperation(c22023480.dcop)
	c:RegisterEffect(e7)
end
c22023480.toss_dice=true
function c22023480.eqlimit(e,c)
	return c:IsCode(22022320,22023410)
end
function c22023480.filter(c)
	return c:IsFaceup() and c:IsCode(22022320,22023410)
end
function c22023480.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c22023480.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22023480.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c22023480.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c22023480.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c22023480.discon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetEquipTarget()
	return ec and (ec==Duel.GetAttacker() or ec==Duel.GetAttackTarget()) and ec:GetBattleTarget()
end
function c22023480.disop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetEquipTarget():GetBattleTarget()
	tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	Duel.AdjustInstantly(c)
end
function c22023480.distg(e,c)
	return c:GetFlagEffect(id)~=0
end
function c22023480.dctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,1)
end
function c22023480.dcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local dc=Duel.TossDice(tp,1)
	if dc==3 or dc==4 or dc==5 or dc==6 and c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end