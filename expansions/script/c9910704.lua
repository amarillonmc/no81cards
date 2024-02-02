--远古造物 怪诞虫
dofile("expansions/script/c9910700.lua")
function c9910704.initial_effect(c)
	--special summon
	QutryYgzw.AddSpProcedure(c,1)
	c:EnableReviveLimit()
	--flag
	QutryYgzw.AddTgFlag(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9910704,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CUSTOM+9910704)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,9910704)
	e1:SetCondition(c9910704.drcon)
	e1:SetCost(c9910704.drcost)
	e1:SetTarget(c9910704.drtg)
	e1:SetOperation(c9910704.drop)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,9910705)
	e2:SetCondition(c9910704.setcon)
	e2:SetTarget(c9910704.settg)
	e2:SetOperation(c9910704.setop)
	c:RegisterEffect(e2)
	if not c9910704.global_check then
		c9910704.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c9910704.regcon)
		ge1:SetOperation(c9910704.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910704.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(Card.IsControler,1,nil,0) then v=v+1 end
	if eg:IsExists(Card.IsControler,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function c9910704.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+9910704,re,r,rp,ep,e:GetLabel())
end
function c9910704.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==1-tp or ev==PLAYER_ALL 
end
function c9910704.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c9910704.filter(c)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9910704.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c9910704.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c9910704.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9910704.filter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c9910704.setcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9910704.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return QutryYgzw.SetFilter(e:GetHandler(),e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function c9910704.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then QutryYgzw.Set(c,e,tp) end
end
