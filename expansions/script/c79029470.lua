--深海猎人·行动-久违猎场
function c79029470.initial_effect(c)
	--code
	aux.EnableChangeCode(c,22702055,LOCATION_MZONE+LOCATION_GRAVE)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c79029470.bgmop)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	e3:SetCondition(c79029470.actcon)
	c:RegisterEffect(e3)  
	--Destroy 
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE) 
	e4:SetCountLimit(1,79029470)
	e4:SetTarget(c79029470.detg)
	e4:SetOperation(c79029470.deop)
	c:RegisterEffect(e4)
end
function c79029470.bgmop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(79029470,0)) 
end
function c79029470.actcon(e)
	return Duel.GetAttacker():IsSetCard(0x1908) or Duel.GetAttackTarget():IsSetCard(0x1908) 
end
function c79029470.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_MZONE,0,1,nil,0x1908) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
	Duel.SetChainLimit(c79029470.chlimit)
end
function c79029470.chlimit(e,ep,tp)
	return tp==ep
end
function c79029470.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
	local x=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x1908)
	if g:GetCount()<=0 or x<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:Select(tp,1,x,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end







