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
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.smcon)
	e1:SetCost(cm.smcost)
	e1:SetOperation(cm.atkop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
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
end
function cm.smcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) and Duel.GetTurnPlayer()==tp and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.cfilter(c,g)
	return g:IsExists(Card.IsRace,1,nil,c:GetRace()) and c:IsFaceup() and c:IsAbleToGraveAsCost()
end
function cm.smcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil,eg) end
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter,tp,0,LOCATION_MZONE,1,1,nil,eg)
	Duel.SendtoGrave(tg,REASON_COST)
end
function cm.sscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_SPELL+TYPE_TRAP) and Duel.GetTurnPlayer()~=tp and aux.dscon(e,tp,eg,ep,ev,re,r,rp)
end
function cm.cfilter2(c,g)
	return g:IsExists(Card.IsType,1,nil,c:GetType()&0x6) and (c:IsFaceup() or c:GetEquipTarget() or c:IsLocation(LOCATION_FZONE)) and c:IsAbleToGraveAsCost()
end
function cm.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,0,LOCATION_SZONE,1,nil,eg) end
	local tg=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,0,LOCATION_SZONE,1,1,nil,eg)
	Duel.SendtoGrave(tg,REASON_COST)
end
function cm.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end