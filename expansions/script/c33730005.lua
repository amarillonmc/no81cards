--键★等 －过准备 | K.E.Y Etc. Sovrappreparazione
--Scripted by: XGlitchy30
local s,id=GetID()

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.lpcost)
	e2:SetTarget(s.lptg)
	e2:SetOperation(s.lpop)
	c:RegisterEffect(e2)
end
function s.filter(c,p)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand(p)
end
function s.thfilter(c)
	return c:IsSetCard(0x460) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,0,LOCATION_GRAVE,1,nil) and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,PLAYER_ALL,LOCATION_GRAVE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(1-tp,aux.NecroValleyFilter(s.filter),tp,0,LOCATION_GRAVE,1,3,nil,1-tp)
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 and g:Filter(Card.IsLocation,nil,LOCATION_HAND):FilterCount(Card.IsControler,nil,1-tp)>0 then
		local og=Duel.GetOperatedGroup():Filter(Card.IsLocation,nil,LOCATION_HAND):Filter(Card.IsControler,nil,1-tp)
		Duel.ConfirmCards(tp,og)
		local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.thfilter),tp,LOCATION_GRAVE,0,nil,1-tp)
		if #sg<=0 then return end
		local max=math.min(#sg,#og)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=sg:Select(tp,max,max,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end	
	end
end

function s.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKBOTTOM,REASON_COST)
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,PLAYER_ALL,2000)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,2000,REASON_EFFECT,true)
	Duel.Recover(1-tp,2000,REASON_EFFECT,true)
	Duel.RDComplete()
end