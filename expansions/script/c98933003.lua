--天外来客 食人魔花
function c98933003.initial_effect(c)
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
	e5:SetCondition(c98933003.spcon)
	e5:SetOperation(c98933003.spop)
	c:RegisterEffect(e5)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c98933003.recon)
	e2:SetOperation(c98933003.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c98933003.recon)
	e3:SetOperation(c98933003.reop)
	c:RegisterEffect(e3)
	local e6=e3:Clone()
	e6:SetCode(EVENT_CHAIN_NEGATED)
	c:RegisterEffect(e6)
	--disable special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98933003,0))
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_SPSUMMON)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c98933003.discon)
	e1:SetCost(c98933003.discost)
	e1:SetTarget(c98933003.distg)
	e1:SetOperation(c98933003.disop)
	c:RegisterEffect(e1)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98933003,0))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetOperation(c98933003.negop)
	c:RegisterEffect(e4)
end
function c98933003.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,98933003)==0
end
function c98933003.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetOperation(c98933003.sop)
	e3:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e3,tp)
end
function c98933003.sop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(98933003,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_CHAIN,0,1)
end
function c98933003.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c98933003.cfilter(c,syn)
	return syn:IsSynchroSummonable(c)
end
function c98933003.scfilter(c,mg)
	return mg:IsExists(c98933003.cfilter,1,nil,c)
end
function c98933003.recon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==1 and (e:GetHandler():GetFlagEffect(98933003)>0 or (e:GetCode()~=EVENT_CHAIN_NEGATED)) and Duel.GetFlagEffect(tp,98933001)==0
end
function c98933003.tg(e,tp,eg,ep,ev,re,r,rp,chk)	
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x11b)
	if chk==0 then return Duel.IsExistingMatchingCard(c98933003.filter,tp,LOCATION_HAND,0,1,nil,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98933003.reop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c98933003.SSfilter,tp,LOCATION_HAND,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(98933003,0)) then
	   Duel.RegisterFlagEffect(tp,98933001,RESET_CHAIN,0,1)
	   local c=e:GetHandler()
	   Duel.ConfirmCards(1-tp,c)
	   Duel.ShuffleHand(tp)
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g=Duel.SelectMatchingCard(tp,c98933003.SSfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	   if g:GetCount()>0 then
		  local tc=g:GetFirst()
		  Duel.SpecialSummonRule(tp,tc,0)
	   end
	end   
end
function c98933003.SSfilter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsRace(RACE_PLANT) and not c:IsSummonableCard() and c:IsSpecialSummonable(0)
end
function c98933003.discon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function c98933003.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c98933003.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g2=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local c1=g1:GetSum(Card.GetAttack)
	local c2=g2:GetSum(Card.GetAttack)
	if chk==0 then return c1>0 or c2>0 end
end
function c98933003.disop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local g2=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
	local c1=g1:GetSum(Card.GetAttack)
	local c2=g2:GetSum(Card.GetAttack)
	local lp1=Duel.GetLP(tp)
	local lp2=Duel.GetLP(1-tp)
	if c1>0 or c2>0 then
		Duel.SetLP(tp,lp1-math.floor(c2/2))
		Duel.SetLP(1-tp,lp2-math.floor(c1/2))
		if Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(98933003,1)) then
		   Duel.BreakEffect()
		   Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c98933003.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)>0 and Duel.IsPlayerCanDraw(tp,1) then
		Duel.ShuffleDeck(tp)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c98933003.rfilter(c)
	return c:IsReleasable(REASON_SPSUMMON)
end
function c98933003.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 and
		Duel.CheckLPCost(1-c:GetControler(),500)
end
function c98933003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(1-tp,500)
end