--祸难之变貌
local m=40010950
local cm=_G["c"..m]
cm.named_with_CaLaMity=1
function cm.DragonTree(c)
	local m=_G["c"..c:GetCode()]
	return (m and m.named_with_DragonTree) or c:IsCode(40010936)
end
function cm.CaLaMity(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_CaLaMity
end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1) 
end
--Effect 1
function cm.f1(c)
	if c:IsCode(m) then return false end
	return cm.CaLaMity(c) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function cm.cf(c)
	local chk=c:IsFaceup() or c:IsLocation(LOCATION_HAND)
	return chk and cm.DragonTree(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.f1(c)
	if c:IsCode(m) then return false end
	return cm.CaLaMity(c) and c:IsAbleToHand()
end
function cm.f2(c)
	return cm.DragonTree(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local chk1=Duel.IsExistingMatchingCard(cm.f1,tp,LOCATION_DECK,0,1,nil) 
	local chk2=Duel.IsPlayerCanDraw(tp,2)
	local costchk=Duel.IsExistingMatchingCard(cm.cf,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil)
	local ct1=Duel.GetFlagEffect(tp,m)
	local ct2=Duel.GetFlagEffect(tp,m+100)
	local b1=chk1 and ct1==0
	local b2=(e:GetLabel()~=1 or costchk) and chk2 and ct2==0
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(m,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	end
	if op==0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetOperation(cm.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	else
		if e:GetLabel()==1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
			local cg=Duel.SelectMatchingCard(tp,cm.cf,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
			Duel.SendtoGrave(cg,REASON_COST)
		end 
		e:SetLabel(0)
		Duel.RegisterFlagEffect(tp,m+100,RESET_PHASE+PHASE_END,0,1)
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(2)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		e:SetOperation(cm.drop)
	end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	cm.splimitop(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.f1,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoHand(g,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	cm.splimitop(e,tp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function cm.splimitop(e,tp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not cm.DragonTree(c)
end   