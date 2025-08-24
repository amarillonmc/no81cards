--璇心救世军-“红玉”
local cm,m=GetID()
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,1,1)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_CUSTOM+m+1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.smcon)
	e1:SetCost(cm.smcost)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CUSTOM+m)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCondition(cm.sscon)
	e2:SetCost(cm.sscost)
	c:RegisterEffect(e2)
	--cannot be link material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge0=Effect.CreateEffect(c)
		ge0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge0:SetCode(EVENT_TO_HAND)
		ge0:SetCondition(cm.regcon)
		ge0:SetOperation(cm.regop)
		Duel.RegisterEffect(ge0,0)
		local ge1=ge0:Clone()
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetCondition(aux.TRUE)
		ge1:SetOperation(cm.regop2)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.filter0,1,nil)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local b1,b2=0,0
	for c in aux.Next(eg:Filter(cm.filter0,nil)) do
		if c:IsType(TYPE_MONSTER) then
			b1=b1|c:GetRace()
		else
			b2=b2|(c:GetType()&0x6)
		end
	end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m,re,r,rp,b2,b1)
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local b1,b2=0,0
	for c in aux.Next(eg) do
		if c:IsType(TYPE_MONSTER) then
			b1=b1|c:GetRace()
		else
			b2=b2|(c:GetType()&0x6)
		end
	end
	Duel.RaiseEvent(eg,EVENT_CUSTOM+m+1,re,r,rp,b2,b1)
end
function cm.smcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.cfilter(c,ep,ev)
	if c:IsType(TYPE_MONSTER) then
		return c:IsRace(ev) and c:IsFaceup() and c:IsAbleToGraveAsCost()
	else
		return c:IsType(ep) and (c:IsFaceup() or c:GetEquipTarget() or c:IsLocation(LOCATION_FZONE)) and c:IsAbleToGraveAsCost()
	end
end
function cm.cfilter2(c,ep,ev)
	if c:IsType(TYPE_MONSTER) then
		return c:IsRace(ev) and c:IsFaceup() and c:IsAbleToHandAsCost()
	else
		return c:IsType(ep) and c:IsFaceup() and c:IsAbleToHandAsCost()
	end
end
function cm.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil,ep,ev) end
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0,LOCATION_MZONE,1,1,nil,ep,ev)
	Duel.SendtoGrave(tg,REASON_COST)
end
function cm.filter0(c)
	return c:IsPublic() or (not c:IsStatus(STATUS_TO_HAND_WITHOUT_CONFIRM) and (c:IsPreviousLocation(LOCATION_DECK) or c:IsPreviousPosition(POS_FACEUP)))
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and aux.dscon(e,tp,eg,ep,ev,re,r,rp) and eg:IsExists(cm.filter0,1,nil)
end
function cm.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_GRAVE,0,1,nil,ep,ev) end
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,ep,ev)
	Duel.SendtoHand(tg,nil,REASON_COST)
	Duel.ConfirmCards(1-tp,tg)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(2000)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end