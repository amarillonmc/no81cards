--天基兵器速射
local cm,m,o=GetID()
if not pcall(function() require("expansions/script/c33330048") end) then require("script/c33330048") end
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2 = Rule_SpaceWeapon.spell_grave(c)
end
--e1
function cm.tgf1(c,n)
	return c:IsAbleToRemove() and (n>1 or c:IsLocation(LOCATION_GRAVE))
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local n=Duel.GetFieldGroup(tp,32,0):Filter(Card.IsSetCard,nil,0x564):Filter(Card.IsFaceup,nil):Filter(Card.IsType,nil,1):GetClassCount(Card.GetCode)
	if chkc then return chkc:IsControler(1-tp) and cm.tgf1(chkc,n) and c:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) end
	if chk==0 then return n>0 and Duel.IsExistingTarget(cm.tgf1,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil,n) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,cm.tgf1,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,n,nil,n)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,#g,1-tp,LOCATION_ONFIELD+LOCATION_GRAVE)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 then
		Duel.Remove(tg,POS_FACEUP,REASON_EFFECT)
	end
end