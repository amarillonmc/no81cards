--落日时起舞
local cm,m,o=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DEFCHANGE+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCondition(cm.hcon)
	e2:SetTarget(cm.htg)
	e2:SetOperation(cm.hop)
	c:RegisterEffect(e2)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(m-1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCondition(cm.acon)
	e2:SetTarget(cm.atg)
	e2:SetOperation(cm.aop)
	c:RegisterEffect(e2)
end
function cm.fil(c)
	return c:IsCanHaveCounter(0x62a) and Duel.IsCanAddCounter(tp,0x62a,1,c) and c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetCounter(0x62a)<14
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_HAND)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local num=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return num>0 and Duel.IsPlayerCanDraw(tp,num) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,nil)
	if num>2 then
		Duel.Draw(tp,2,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_MZONE,0,e:GetHandler())
		for tc in aux.Next(g) do
			tc:AddCounter(0x62a,num-2)
		end
	elseif num>0 then
		Duel.Draw(tp,num,REASON_EFFECT)
	end
end
function cm.filter(c)
	return (c:IsLevelAbove(6) or not c:IsLevelAbove(1)) and c:IsFaceup() 
end

function cm.hcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_HAND)
end
function cm.htg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.hfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.hfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.hfil(c)
	return c:IsCode(m-1) and c:IsAbleToHand()
end
function cm.afil(c)
	return c:IsCanHaveCounter(0x62a) and Duel.IsCanAddCounter(tp,0x62a,1,c) and c:IsFaceup()
end
function cm.acon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousLocation(LOCATION_SZONE)
end
function cm.atg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.afil,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.aop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.fil,tp,LOCATION_MZONE,0,nil)
	for tc in aux.Next(g) do
		tc:AddCounter(0x62a,6)
	end
end