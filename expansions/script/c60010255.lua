--任务：追击
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60010252)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(aux.exccon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.fil1(c)
	return c:IsCode(60010252) and c:IsAbleToHand()
end
function cm.fil2(c)
	return c:IsCode(60010252) and c:IsFaceup()
end
function cm.fil3(c)
	return c:IsRace(RACE_ILLUSION) and c:IsAbleToHand()
end
function cm.fil4(c)
	return c:IsFaceup() and not (c:IsAttack(0) and c:IsDefense(0))
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=false
	local b2=false
	if Duel.IsExistingMatchingCard(cm.fil1,tp,LOCATION_DECK,0,1,nil) or (Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fil3,tp,LOCATION_DECK,0,1,nil)) then b1=true end
	if Duel.IsExistingMatchingCard(cm.fil4,tp,0,LOCATION_MZONE,1,nil) then b2=true end
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
				{b1,aux.Stringid(m,1)},
				{b2,aux.Stringid(m,2)})
	if op==1 then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==2 then Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,nil,1,tp,LOCATION_MZONE) end
	e:SetLabel(op)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.GetMatchingGroup(cm.fil1,tp,LOCATION_DECK,0,nil)
		if Duel.IsExistingMatchingCard(cm.fil2,tp,LOCATION_MZONE,0,1,nil) 
		then g=Duel.GetMatchingGroup(cm.fil3,tp,LOCATION_DECK,0,nil) end
		local sg=g:Select(tp,1,1,nil)
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		local tc=Duel.SelectMatchingCard(tp,cm.fil4,tp,0,LOCATION_MZONE,1,1,nil):GetFirst()
		if tc then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(0)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			tc:RegisterEffect(e2)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_LEAVE_FIELD_P)
			e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetReset(RESET_EVENT+RESETS_STANDARD)
			e5:SetOperation(cm.regop)
			tc:RegisterEffect(e5)
		end
	end
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	Duel.Draw(1-tp,2,REASON_EFFECT)
end

function cm.filter(c)
	return aux.IsCodeListed(c,60010252) and c:IsType(TYPE_SPELL) and c:IsType(TYPE_CONTINUOUS) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsExistingMatchingCard(cm.filx,tp,LOCATION_MZONE,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function cm.filx(c)
	return c:IsCode(60010252) and c:IsFaceup()
end