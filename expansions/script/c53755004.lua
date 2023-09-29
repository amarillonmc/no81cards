local m=53755004
local cm=_G["c"..m]
cm.name="SRT兔子小队 美游"
cm.Rabbit_Team_Number_4=true
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	SNNM.RabbitTeam(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_CHAIN)
	e1:SetCondition(cm.atkcon)
	e1:SetCost(cm.accost)
	e1:SetOperation(cm.acop)
	c:RegisterEffect(e1)
end
function cm.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:GetHandler():IsOnField() and re:GetHandler():IsFaceup() and re:GetHandler():IsRelateToEffect(re) and re:IsActiveType(TYPE_MONSTER)
end
function cm.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ec=math.floor(re:GetHandler():GetBaseAttack()/800)
	if chk==0 then return ec>0 and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>3 end
	Duel.ConfirmDecktop(tp,ec)
	local g=Duel.GetDecktopGroup(tp,ec)
	local ct=g:FilterCount(Card.IsSetCard,nil,0x5536)
	Duel.SetTargetParam(ct)
	for tc in aux.Next(g) do Duel.MoveSequence(tc,1) end
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5536)
end
function cm.acop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsFacedown() or not re:GetHandler():IsRelateToEffect(re) then return end
	local ct=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	ct=ct+Duel.GetMatchingGroupCount(cm.atkfilter,tp,LOCATION_ONFIELD,0,nil)
	if ct>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN)
		e1:SetValue(-ct*400)
		re:GetHandler():RegisterEffect(e1)
	end
end
