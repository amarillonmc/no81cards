--械魂灵
function c33741114.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33741114,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetCondition(c33741114.regcon)
	e1:SetCost(c33741114.regcost)
	e1:SetOperation(c33741114.regop)
	c:RegisterEffect(e1)
	--check
	if not c33741114.global_check then
		c33741114.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c33741114.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c33741114.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(0,33741114,RESET_PHASE+PHASE_END,0,1)
	end
end
function c33741114.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp) and c:GetReasonPlayer()==1-tp
end
function c33741114.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c33741114.cfilter,1,nil,tp)
end
function c33741114.regcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c33741114.regop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(0,33741114)
	if Duel.IsChainDisablable(0) and Duel.IsPlayerCanDraw(tp,ct) and Duel.SelectYesNo(1-tp,aux.Stringid(33741114,0)) then
		Duel.Draw(tp,ct,REASON_EFFECT)
		Duel.NegateEffect(0)
		return
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c33741114.drop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c33741114.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,33741114)
	if Duel.Draw(1-tp,Duel.GetFlagEffect(0,33741114),REASON_EFFECT)==0 then return end
	Duel.DiscardDeck(1-tp,Duel.GetFieldGroupCount(tp,0,LOCATION_HAND),REASON_EFFECT)
end
