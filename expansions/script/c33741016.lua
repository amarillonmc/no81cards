--DEchoes Room #20 - Mirage Floor
local s,id,o=GetID()
Duel.LoadScript("c33741000.lua")
function s.initial_effect(c)
	c:SetUniqueOnField(1,0,id)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1:SetCountLimit(1)
	e1:SetCondition(s.drcon)
	e1:SetTarget(s.drtg)
	e1:SetOperation(s.drop)
	c:RegisterEffect(e1)
end
function s.rfilter(c)
	return c:IsAbleToExtra()
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,LOCATION_EXTRA,0)<=6
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rfilter),tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return (g:GetClassCount(Card.GetCode)>=3 and Duel.IsPlayerCanDraw(tp,1))
		or (g:GetClassCount(Card.GetCode)>=6 and Duel.IsPlayerCanDraw(tp,2)) end
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,3,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(s.rfilter),tp,LOCATION_GRAVE,0,nil)
	local maxc=0
	if g:GetClassCount(Card.GetCode)>=6 and Duel.IsPlayerCanDraw(tp,2) then maxc=6
	elseif g:GetClassCount(Card.GetCode)>=3 and Duel.IsPlayerCanDraw(tp,1) then maxc=3 end
	if maxc==0 then return end
	local ct=3
	if maxc==6 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then ct=6 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,ct,ct)
	if not sg then return end
	Duel.HintSelection(sg)
	local rc=Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	if rc>0 then Duel.Draw(tp,math.floor(rc/3),REASON_EFFECT) end
end
