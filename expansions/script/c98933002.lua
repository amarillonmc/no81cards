--天外来客 机械恶魔
function c98933002.initial_effect(c)
		c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_SPSUMMON_PROC)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_HAND)
	e5:SetCondition(c98933002.spcon)
	e5:SetTarget(c98933002.sptg)
	e5:SetOperation(c98933002.spop)
	c:RegisterEffect(e5)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c98933002.recon)
	e2:SetOperation(c98933002.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c98933002.recon)
	e3:SetOperation(c98933002.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
	--disable special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98933002,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98933002.discon)
	e1:SetCost(c98933002.discost)
	e1:SetTarget(c98933002.distg)
	e1:SetOperation(c98933002.disop)
	c:RegisterEffect(e1)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98933002,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c98933002.negop)
	c:RegisterEffect(e4)	
end
function c98933002.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98933002)==0
end
function c98933002.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98933002.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98933002.sop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98933002,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c98933002.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c98933002.scfilter(c,mg)
	return mg:IsExists(c98933002.cfilter,1,nil,c)
end
function c98933002.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98933002)>0 or (e:GetCode()~=EVENT_CHAIN_NEGATED)) and Duel.GetFlagEffect(tp,98933002)==0
end
function c98933002.tg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	if chk==0 then return Duel.IsExistingMatchingCard(c98933002.filter,tp,LOCATION_HAND,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98933002.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98933002.SSfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98933002,0)) then
	   Duel.RegisterFlagEffect(tp,98933002,RESET_CHAIN,0,1)
	   local c=e:GetHandler()
	   Duel.ConfirmCards(1-tp,c)
	   Duel.ShuffleHand(tp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c98933002.SSfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  local tc=g:GetFirst()
		  Duel.SpecialSummonRule(tp,tc,0)
	   end
	end   
end
function c98933002.SSfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_MACHINE) and not c:IsSummonableCard() and c:IsSpecialSummonable(0)
end
function c98933002.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c98933002.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98933002.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,LOCATION_REMOVED)
end
function c98933002.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if aux.NecroValleyNegateCheck(g) then return end
	if Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(98933002,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
   end
end
function c98933002.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c98933002.rfilter(c)
	return c:IsAbleToRemove()
end
function c98933002.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98933002.rfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil)
end
function c98933002.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c98933002.rfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tc=g:SelectUnselect(nil,tp,false,true,1,1)
	if tc then
		e:SetLabelObject(tc)
		return true
	else return false end
end
function c98933002.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoDeck(g,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
end