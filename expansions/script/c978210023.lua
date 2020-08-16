--闪刀姬·天启
function c978210023.initial_effect(c)
	c:SetSPSummonOnce(978210023)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c978210023.matfilter,1,1)
--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c978210023.sumop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(978210023,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c978210023.dacon)
	e2:SetOperation(c978210023.daop)
	c:RegisterEffect(e2)
--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(978210023,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c978210023.thtg)
	e3:SetOperation(c978210023.thop)
	c:RegisterEffect(e3)
  --spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c978210023.sumsuc)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e9)
-----
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(978210023,2))
	e10:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e10:SetType(EFFECT_TYPE_QUICK_O)
	e10:SetCode(EVENT_FREE_CHAIN)
	e10:SetHintTiming(0,TIMING_END_PHASE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCost(c978210023.spcost1)
	e10:SetTarget(c978210023.sptg1)
	e10:SetOperation(c978210023.spop1)
	c:RegisterEffect(e10)
end
function c978210023.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(978210023,0))
end
function c978210023.sumop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(978210023,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
end
function c978210023.dacon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE_STEP and Duel.GetCurrentChain()==0
		and e:GetHandler():GetFlagEffect(978210023)~=0
end
function c978210023.daop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetBaseAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_BATTLE)
	c:RegisterEffect(e1)
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(978210023,2))
end
function c978210023.matfilter(c)
	return c:IsLinkSetCard(0x2115) and not c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end
function c978210023.thfilter(c,tp)
	return c:IsSetCard(0x2115) and c:IsAbleToHand()
end
function c978210023.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
   if chk==0 then return Duel.IsExistingMatchingCard(c978210023.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=5 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DRAW)
	end
end
function c978210023.thop(e,tp,eg,ep,ev,re,r,rp)
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c978210023.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if Duel.IsPlayerCanDraw(tp,2)
			and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_SPELL)>=5
			and Duel.SelectYesNo(tp,aux.Stringid(978210023,1)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,2,REASON_EFFECT)
		end
	end
  Duel.Hint(HINT_MUSIC,0,aux.Stringid(978210023,2))
end
---------
function c978210023.spcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c978210023.spfilter1(c,e,tp,ec)
	return c:IsSetCard(0x2115) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,ec,c,0x60)>0
end
function c978210023.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c978210023.spfilter1,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c978210023.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c978210023.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP,0x60)
	end
end