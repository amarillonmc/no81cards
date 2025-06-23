--深渊的呼唤VIII 不息载械
local cm, m = GetID()
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.con1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+100)
	e4:SetCondition(cm.con4)
	e4:SetTarget(cm.tg4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
end
--e1
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.tg2(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsRace(RACE_MACHINE)
end
--e3
function cm.e3f2(c,e,tp,code)
	return c:IsSetCard(0x899) and c:IsLevel(4) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.e3f1(c,e,tp)
	return c:IsCanBeEffectTarget(e) and not c:IsType(TYPE_TUNER) and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(cm.e3f2,tp,LOCATION_DECK,0,1,nil,e,tp,c:GetCode())
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local g = Duel.GetMatchingGroup(cm.e3f1,tp,LOCATION_MZONE,0,nil,e,tp)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetTargetCard(g:Select(tp,1,1,nil))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local tc = Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g = Duel.SelectMatchingCard(tp,cm.e3f2,tp,LOCATION_DECK,0,1,1,nil,e,tp,tc:GetCode())
	if #g == 0 then return end
	Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
end
--e4
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase() == PHASE_END
end
function cm.e4f1(c,e)
	return c:IsCanBeEffectTarget(e) and c:IsRace(RACE_MACHINE) and c:IsAbleToDeck()
end
function cm.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	local g = Duel.GetMatchingGroup(cm.e4f1,tp,LOCATION_GRAVE,0,nil,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and #g>2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	Duel.SetTargetCard(g:Select(tp,3,3,nil))
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local tg = Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e) ~= 3 then return end
	Duel.SendtoDeck(tg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	tg = Duel.GetOperatedGroup()
	if tg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct = tg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct ~= 3 then return end
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end