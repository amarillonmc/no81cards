--丰收神兽 梅丽尔
function c65130206.initial_effect(c)
	aux.AddCodeList(c,65130201)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c65130206.spcon)
	e1:SetTarget(c65130206.sptg)
	e1:SetOperation(c65130206.spop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65130206,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetCountLimit(1,65130206)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c65130206.eqtg)
	e2:SetOperation(c65130206.eqop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,65130207)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c65130206.decon)
	e3:SetTarget(c65130206.detg)
	e3:SetOperation(c65130206.deop)
	c:RegisterEffect(e3)
	--destroy sub
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e4:SetValue(c65130206.repval)
	c:RegisterEffect(e4)
	--change
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(c65130206.chop)
	c:RegisterEffect(e5)
end
local KOISHI_CHECK=false
if Card.SetCardData then KOISHI_CHECK=true end
function c65130206.spfilter(c)
	return c:IsCode(65130201) and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c65130206.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c65130206.spfilter,1,nil)
end
function c65130206.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c65130206.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then 
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c65130206.filter(c)
	return c:IsFaceup() and c:IsCode(65130201)
end
function c65130206.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65130206.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c65130206.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c65130206.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c65130206.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if c:IsLocation(LOCATION_MZONE) and c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:CheckUniqueOnField(tp) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	c65130206.equip_monster(c,tp,tc)
end
function c65130206.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,c,tc) then return end
	if KOISHI_CHECK then c:SetEntityCode(65130207,true) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c65130206.eqlimit)
	e1:SetLabelObject(tc)
	c:RegisterEffect(e1)
	--Gains ATK
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(1800)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e2)
end
function c65130206.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c65130206.repval(e,re,r,rp)
	return bit.band(r,REASON_EFFECT+EFFECT_BATTLE)~=0
end
function c65130206.decon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetEquipTarget()
end
function c65130206.detg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c65130206.deop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c65130206.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if KOISHI_CHECK then c:SetEntityCode(65130206,true) end
end