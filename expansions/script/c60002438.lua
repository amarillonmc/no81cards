--散华
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60002438)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCountLimit(1,m)
	e2:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetCost(cm.poscost)
	e2:SetTarget(cm.postg)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)

	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)

	local e11=Effect.CreateEffect(c)
	e11:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_DRAW)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetProperty(EFFECT_FLAG_DELAY)
	e11:SetCode(EVENT_CHAINING)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(cm.cpcon)
	e11:SetTarget(cm.cptg)
	e11:SetOperation(cm.cpop)
	c:RegisterEffect(e11)
end
function cm.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if (not c:IsPublic() and c:IsLocation(LOCATION_HAND)) or (c:IsFacedown() and c:IsLocation(LOCATION_MZONE)) then
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.filter(c)
	return (not c:IsAttack(0)) and c:IsFaceup()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,0,LOCATION_MZONE)
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local tc=g:Select(tp,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(0)
	tc:RegisterEffect(e1)
end

function cm.thfilter(c)
	return aux.IsCodeListed(c,60002438) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	return (re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and aux.IsCodeListed(re:GetHandler(),60002438)
end
function cm.tdfil(c)
	return c:IsAttack(0) and c:IsFaceup()
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then b1=true end
	if Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) then b2=true end
	if chk==0 then return not e:GetHandler():IsPosition(POS_FACEDOWN_DEFENSE) and (b1 or b2) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,tp,POS_FACEDOWN_DEFENSE)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) then b1=true end
	if Duel.IsExistingMatchingCard(cm.tdfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) and Duel.IsPlayerCanDraw(tp,1) then b2=true end
	if c:IsPosition(POS_FACEDOWN_DEFENSE) or not (b1 or b2) then return end
	if Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)~=0 then
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,0)},{b2,aux.Stringid(m,2)})
		if op==1 then
			local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
		elseif op==2 then
			local g=Duel.GetMatchingGroup(cm.tdfil,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
			if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 then Duel.Draw(tp,1,REASON_EFFECT) end
		end
	end
end













