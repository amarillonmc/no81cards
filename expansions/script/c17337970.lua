--·世界的重责·
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,17337920)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_DECK+LOCATION_GRAVE)
	e6:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e6:SetCondition(s.con2)
	e6:SetCountLimit(1,id)
	e6:SetTarget(s.settg)
	e6:SetOperation(s.setop)
	c:RegisterEffect(e6)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(s.con)
	c:RegisterEffect(e5)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1190)
	e0:SetCategory(CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_SZONE)
	e0:SetCondition(s.con)
	e0:SetCountLimit(1,id+o)
	e0:SetTarget(s.acttg)
	e0:SetOperation(s.actop)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetCondition(s.con2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_MUST_ATTACK_MONSTER)
	e2:SetValue(s.atklimit)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(s.con)
	e3:SetTarget(s.cfilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and not c:IsForbidden() and c:CheckUniqueOnField(tp) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) end
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0
end
function s.thfilter(c)
	return (c:IsCode(17337920) or aux.IsCodeListed(c,17337920)) and c:IsAbleToHand() and not c:IsCode(id)
end
function s.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function s.actop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_DECK+LOCATION_GRAVE,0,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function s.reinfilter(c) 
	return c:IsFaceup() and c:IsCode(17337920)
end
function s.con2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)==0 and Duel.IsExistingMatchingCard(s.reinfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.atklimit(e,c)
	return c:IsFaceup() and c:IsCode(17337920)
end
function s.cfilter(c)
	return c:IsCode(17337920)
end