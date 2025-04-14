if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,53797140)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(s.mtop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_DRAW_PHASE+TIMING_STANDBY_PHASE+TIMINGS_CHECK_MONSTER+TIMING_MSET+TIMING_SSET+TIMING_MAIN_END+TIMING_END_PHASE)
	e2:SetTarget(s.tg)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
function s.mtfilter(c,e)
	return c:IsCanOverlay() and not c:IsImmuneToEffect(e)
end
function s.mtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,id)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.mtfilter),tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c,e)
	if g:GetCount()>0 then Duel.Overlay(c,g) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
	e1:SetValue(LOCATION_DECK)
	c:RegisterEffect(e1)
end
function s.xyzfilter(c,fid)
	local res=false
	for _,flag in ipairs({c:GetFlagEffectLabel(id)}) do if flag==fid then res=true end end
	return not res
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and s.xyzfilter(chkc,fid) end
	local ct=Duel.GetMatchingGroupCount(aux.IsCodeListed,tp,LOCATION_MZONE,0,nil,53797140)
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,0,LOCATION_ONFIELD,1,nil,fid) and ct>0 and Duel.IsExistingMatchingCard(nil,tp,0,0xff,ct,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=Duel.SelectTarget(tp,s.xyzfilter,tp,0,LOCATION_ONFIELD,1,1,nil,fid)
	tg:GetFirst():RegisterFlagEffect(id,RESET_EVENT+0x1fc0000+RESET_PHASE+SNNM.GetCurrentPhase(),0,1,fid)
end
function s.cfilter(c,g)
	return g:IsExists(Card.IsCode,1,nil,table.unpack({c:GetCode()}))
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,0xff,nil)
	local ct=Duel.GetMatchingGroupCount(aux.IsCodeListed,tp,LOCATION_MZONE,0,nil,53797140)
	if #g<ct then return end
	local sg=g:RandomSelect(tp,ct)
	Duel.ConfirmCards(tp,sg)
	Duel.ConfirmCards(1-tp,sg)
	local tc=Duel.GetFirstTarget()
	local fg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_EXTRA,0,nil)
	if tc and sg:IsExists(s.cfilter,1,nil,fg) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_TO_DECK_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
		Duel.SendtoDeck(tc,tp,1,REASON_EFFECT)
		e1:Reset()
	end
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then Duel.ShuffleHand(1-tp) end
	if sg:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(1-tp) end
end
