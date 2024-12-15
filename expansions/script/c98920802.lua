--魔界剧团-暖场嘉宾
local s,id,o=GetID()
function c98920802.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)	
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920802,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCost(c98920802.thcost)
	e2:SetTarget(c98920802.thtg)
	e2:SetOperation(c98920802.thop)
	c:RegisterEffect(e2)
	--change effect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCondition(c98920802.chcon)
	e4:SetOperation(c98920802.chop)
	c:RegisterEffect(e4)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(2000)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g:GetFirst(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function s.thfilter(c)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and not c:IsCode(id) and c:IsType(TYPE_MONSTER)
		and c:IsAbleToHand()
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
		and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)~=0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) and c:IsLocation(LOCATION_PZONE) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c98920802.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c98920802.thfilter1(c)
	return c:IsSetCard(0x20ec) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c98920802.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c98920802.thfilter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920802.thfilter1,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c98920802.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c98920802.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c98920802.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM)
end
function c98920802.chcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c98920802.filter2,tp,LOCATION_EXTRA,0,1,nil) and Duel.GetFlagEffect(tp,id)==0
end
function c98920802.chop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(id,3)) then
	   Duel.RegisterFlagEffect(e:GetHandlerPlayer(),id,RESET_PHASE+PHASE_END,0,1)
	   local g=Group.CreateGroup()
	   Duel.ChangeTargetCard(ev,g)
	   return Duel.ChangeChainOperation(ev,c98920802.repop)
	end
end
function c98920802.desfilter(c)
	return c:IsFacedown()
end
function c98920802.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,98920802)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c98920802.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end