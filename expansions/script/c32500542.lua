--BB 苍之拉格纳
function c32500542.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0xae1),3)
	c:EnableReviveLimit()
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,c32500542)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(c32500542.target1)
	e1:SetOperation(c32500542.activate1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,32500542)
	e2:SetTarget(c32500542.target2)
	e2:SetOperation(c32500542.activate2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,32500542)
	e3:SetTarget(c32500542.target3)
	e3:SetOperation(c32500542.activate3)
	c:RegisterEffect(e3)
end
function c32500542.filter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c32500542.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_GRAVE) and c32500542.filte1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32500542.filter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c32500542.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c32500542.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetDescription(aux.Stringid(32500542,2))
		e1:SetTargetRange(0,1)
		e1:SetValue(c32500542.aclimit1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function c32500542.aclimit1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end
function c32500542.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function c32500542.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_GRAVE) and c32500542.filte2(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32500542.filter2,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c32500542.filter2,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c32500542.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetDescription(aux.Stringid(32500542,3))
		e1:SetTargetRange(0,1)
		e1:SetValue(c32500542.aclimit2)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function c32500542.aclimit2(e,re,tp)
	return re:IsActiveType(TYPE_SPELL)
end
function c32500542.filter3(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function c32500542.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return  chkc:IsLocation(LOCATION_GRAVE) and c32500542.filte3(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c32500542.filter3,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c32500542.filter3,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,1-tp,LOCATION_GRAVE)
end
function c32500542.activate3(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.Remove(c,POS_FACEUP,REASON_EFFECT)~=0 and c:IsLocation(LOCATION_REMOVED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetDescription(aux.Stringid(32500542,4))
		e1:SetTargetRange(0,1)
		e1:SetValue(c32500542.aclimit3)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function c32500542.aclimit3(e,re,tp)
	return re:IsActiveType(TYPE_TRAP)
end