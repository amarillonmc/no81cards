--传说之魂的抉择
local m=33350012
local cm=_G["c"..m]
function c33350012.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.actcost)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LEAVE_GRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(cm.con2(cm.f2))
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2(cm.f2))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(cm.con2(cm.f3))
	e3:SetOperation(cm.op2(cm.f3))
	c:RegisterEffect(e3)
end
cm.setname="TaleSouls"
function cm.acfilter(c)
	return  c.setname=="TaleSouls" and c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.acfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.acfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--e2
function cm.f2(c,tp)
	return c:IsPreviousControler(tp) and c.setname=="TaleSouls" and c:IsLocation(LOCATION_GRAVE)
end
function cm.con2(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(f,1,nil,tp)
	end
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return eg:Filter(Card.IsAbleToHand,nil,e):GetCount()>0 and Duel.GetFlagEffect(tp,m)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,eg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.RegisterFlagEffect(tp,m,RESET_CHAIN,0,1)
end
function cm.op2(f)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local g=eg:Filter(f,nil,tp)
		local b1=g:IsExists(Card.IsAbleToHand,1,nil) and Duel.IsPlayerCanDraw(1-tp,1)
		local b2=g:IsExists(Card.IsAbleToRemove,1,nil) and Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFaceup,nil):IsExists(Card.IsLevelAbove,1,nil,0)
		local op
		if b1 and b2 then op=Duel.SelectOption(1-tp,aux.Stringid(m,0),aux.Stringid(m,1))
		elseif b1 then op=Duel.SelectOption(1-tp,aux.Stringid(m,0))
		elseif b2 then op=Duel.SelectOption(1-tp,aux.Stringid(m,1))+1
		else return end
		if op==0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
			Duel.ConfirmCards(1-tp,Duel.GetOperatedGroup())
			Duel.Draw(1-tp,1,REASON_EFFECT)
		elseif op==1 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)>0 then
			g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE):Filter(Card.IsFaceup,nil):Filter(Card.IsLevelAbove,nil,0)
			for tc in aux.Next(g) do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_LEVEL)
				e1:SetValue(1)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1)
			end
		end
	end
end
--e3
function cm.f3(c,tp)
	return c:IsPreviousControler(tp) and c:IsReason(REASON_EFFECT) and c.setname=="TaleSouls"
end