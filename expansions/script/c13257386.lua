--超时空停滞胶囊
local s,id,o=GetID()
local fieldId=13257335
if not tama then xpcall(function() dofile("expansions/script/tama.lua") end,function() dofile("script/tama.lua") end) end
function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(s.tdcost)
	e2:SetTarget(s.tdtg)
	e2:SetOperation(s.tdop)
	c:RegisterEffect(e2)
	
end
function s.pcfilter(c)
	return c:IsSetCard(0x351) and c:IsFaceup()
end
function s.cfilter(c)
	return not c:IsPublic() and c:IsSetCard(0x351) and c:IsType(TYPE_MONSTER)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return e:GetLabel()==1 and chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	local t1=Duel.IsExistingTarget(s.pcfilter,tp,LOCATION_MZONE,0,1,nil)
	local t2=Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND,0,1,nil)
	if chk==0 then return (t1 or t2) and ((tama.isTheme(tp,fieldId) or Duel.IsEnvironment(fieldId,tp)) or Duel.IsExistingMatchingCard(nil,tp,LOCATION_HAND,0,2,nil)) end
	local op=aux.SelectFromOptions(tp,
		{t1,aux.Stringid(id,2),1},
		{t2,aux.Stringid(id,3),2})
	e:SetLabel(op)
	if op==1 then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,s.pcfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local g=Duel.GetMatchingGroup(aux.NegateMonsterFilter,tp,0,LOCATION_MZONE,nil)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
	elseif op==2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local sc=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND,0,1,1,nil)
		Duel.ConfirmCards(1-tp,sc)
		Duel.ShuffleHand(tp)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	Duel.RegisterEffect(e2,tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetTargetRange(0,1)
	e4:SetValue(s.aclimit)
	e4:SetReset(RESET_PHASE+ph)
	Duel.RegisterEffect(e4,tp)
	if not (tama.getTheme(tp)==fieldId or Duel.IsEnvironment(fieldId,tp)) then
		Duel.DiscardHand(tp,aux.TRUE,2,2,REASON_EFFECT+REASON_DISCARD)
	end
end
function s.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
function s.tdfilter(c)
	return c:IsSetCard(0x352) and c:IsAbleToDeckOrExtraAsCost()
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_GRAVE,0,3,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_GRAVE,0,3,3,e:GetHandler())
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_COST)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end
