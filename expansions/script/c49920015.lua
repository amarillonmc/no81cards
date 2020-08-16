--薛定谔猫的恶作剧
function c49920015.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	 local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(49920015,0))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_HAND)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,49920015)
	e3:SetCondition(c49920015.ddcon)
	e3:SetTarget(c49920015.ddtg)
	e3:SetOperation(c49920015.ddop)
	c:RegisterEffect(e3)
   local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(49920015,0))
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_HAND)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1,49920016)
	e4:SetCondition(c49920015.ddcon1)
	e4:SetTarget(c49920015.ddtg1)
	e4:SetOperation(c49920015.ddop1)
	c:RegisterEffect(e4)
end
function c49920015.ddcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c49920015.ddfilter(c,tp)
	return c:IsControler(1-tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c49920015.ddtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c49920015.ddfilter,nil,tp)
	local gc=g:GetCount()
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(1-tp,gc) end
	 Duel.SetOperationInfo(0,CATEGORY_TODECK,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,1-tp,gc)
end
function c49920015.ddop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c49920015.ddfilter,nil,tp)
	if g:GetCount()>0  then  local oc=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if oc>0 then
			Duel.Draw(1-tp,oc,REASON_EFFECT)
end
	end
end
function c49920015.ddcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DRAW
end
function c49920015.ddfilter1(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function c49920015.ddtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=eg:Filter(c49920015.ddfilter1,nil,tp)
	local gc=g:GetCount()
	if chk==0 then return g:GetCount()>0 and Duel.IsPlayerCanDraw(tp,gc) end
	 Duel.SetOperationInfo(0,CATEGORY_TODECK,g,gc,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,gc)
end
function c49920015.ddop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c49920015.ddfilter1,nil,tp)
	if g:GetCount()>0  then  local oc=Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	if oc>0 then
			Duel.Draw(tp,oc,REASON_EFFECT)
end
	end
end