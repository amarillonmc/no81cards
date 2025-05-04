--蕾宗忍者·対蕾忍 阿莎姬
function c22347151.initial_effect(c)
	c:SetSPSummonOnce(22347151)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5705),1,1)
	--①：这张卡特殊召唤的场合，以自己的场上·墓地1张「蕾宗忍」卡为对象才能发动。那张卡加入手卡。
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22347151,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c22347151.thtg)
	e1:SetOperation(c22347151.thop)
	c:RegisterEffect(e1)
	--[[
②：以自己墓地的1只「忍者」怪兽为对象才能发动。那只怪兽当作装备魔法卡使用给这张卡装备（只有1只可以装备）。
③：这张卡的攻击力上升这张卡的效果装备的怪兽的原本攻击力的数值。
	]]
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22347151,0))
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22347151)
	e2:SetCondition(c22347151.eqcon)
	e2:SetTarget(c22347151.eqtg)
	e2:SetOperation(c22347151.eqop)
	c:RegisterEffect(e2)
end
function c22347151.thfilter(c)
	return c:IsSetCard(0x705) and c:IsFaceupEx() and c:IsAbleToHand()
end
function c22347151.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) and chkc:IsControler(tp) and c22347151.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c22347151.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectTarget(tp,c22347151.thfilter,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,1,0,0)
end
function c22347151.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c22347151.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return c22347151.can_equip_monster(e:GetHandler())
end
function c22347151.eqfilter(c)
	return c:GetFlagEffect(22347151)~=0
end
function c22347151.can_equip_monster(c)
	local g=c:GetEquipGroup():Filter(c22347151.eqfilter,nil)
	return g:GetCount()==0
end
function c22347151.eqfilter(c)
	return (c:IsSetCard(0x705) and c:IsSetCard(0x2b)) and c:IsFaceup() and not c:IsForbidden()
end
function c22347151.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22347151.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c22347151.eqfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c22347151.eqfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c22347151.eqlimit(e,c)
	return e:GetOwner()==c
end
function c22347151.equip_monster(c,tp,tc)
	if not Duel.Equip(tp,tc,c,false) then return end
	--Add Equip limit
	tc:RegisterFlagEffect(22347151,RESET_EVENT+RESETS_STANDARD,0,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_OWNER_RELATE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(c22347151.eqlimit)
	tc:RegisterEffect(e1)
	local atk=tc:GetTextAttack()
	if atk<0 then atk=0 end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_OWNER_RELATE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(atk)
	tc:RegisterEffect(e2)
end
function c22347151.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		c22347151.equip_monster(c,tp,tc)
	end
end
