--狩猎游戏-幽鸦
function c12877050.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	aux.EnableReviveLimitPendulumSummonable(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.FALSE)
	c:RegisterEffect(e0)
	--moster effect
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(SUMMON_VALUE_SELF)
	e1:SetCountLimit(1,12877050+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c12877050.pspcon)
	e1:SetTarget(c12877050.psptg)
	e1:SetOperation(c12877050.pspop)
	c:RegisterEffect(e1)
	--effect by special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCondition(c12877050.condition)
	e2:SetOperation(c12877050.operation)
	c:RegisterEffect(e2)
	--pzone move
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12877050,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_RELEASE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,12877050)
	e3:SetTarget(c12877050.settg)
	e3:SetOperation(c12877050.setop)
	c:RegisterEffect(e3)
	--pendulum effect
	--return to hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12877050,2))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,12877051)
	e4:SetCost(c12877050.thcost)
	e4:SetTarget(c12877050.thtg)
	e4:SetOperation(c12877050.thop)
	c:RegisterEffect(e4)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c12877050.drcon)
	e5:SetOperation(c12877050.drop)
	c:RegisterEffect(e5)
end
--material(release)
function c12877050.rlfilter(c,tp)
	local re=Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)
	local val=nil
	if re then val=re:GetValue() end
	return c:IsReleasable(REASON_SPSUMMON) or (c:IsType(TYPE_SPELL+TYPE_TRAP) and (val==nil or val(re,c)~=true))
end
function c12877050.rlcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (#mg==1 and mg:IsExists(Card.IsLevel,1,nil,10) and mg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or #mg==2)
end
--material(replace)
function c12877050.rpfilter(c,tp)
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(12877025,tp)
end
--proc
function c12877050.pspcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c12877050.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	local rg=Duel.GetMatchingGroup(c12877050.rpfilter,tp,LOCATION_GRAVE,0,nil,tp)
	return (#mg>0 and mg:CheckSubGroup(c12877050.rlcheck,1,2,tp)) or (#rg>0 and Duel.GetMZoneCount(tp)>0)
end
function c12877050.selectcheck(mg,tp)
	return Duel.GetMZoneCount(tp,mg)>0 and (
		(mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)~=0
		and mg:IsExists(c12877050.rpfilter,1,nil,tp) and #mg==1)
	or 
		(mg:FilterCount(Card.IsLocation,nil,LOCATION_GRAVE)==0
		and (#mg==1 and mg:IsExists(Card.IsLevel,1,nil,10) and mg:IsExists(Card.IsType,1,nil,TYPE_MONSTER) or #mg==2)))
end
function c12877050.psptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local mg=Duel.GetMatchingGroup(c12877050.rlfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,c,tp)
	local rg=Duel.GetMatchingGroup(c12877050.rpfilter,tp,LOCATION_GRAVE,0,nil,tp)
	mg:Merge(rg)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE) 
	local sg=mg:SelectSubGroup(tp,c12877050.selectcheck,true,1,2,tp)	
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c12877050.pspop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND+LOCATION_ONFIELD) then
		Duel.Release(g,REASON_SPSUMMON)
	else
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		Duel.Hint(HINT_CARD,0,12877025)
	end
	g:DeleteGroup()
end
--effect by special summon rule
function c12877050.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function c12877050.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12877050,0))
	e1:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	if c:GetFlagEffect(12877040)==0 then
		e1:SetType(EFFECT_TYPE_IGNITION)
	else
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetHintTiming(0,TIMING_END_PHASE)
	end
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c12877050.cost)
	e1:SetTarget(c12877050.setg)
	e1:SetOperation(c12877050.seop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end
function c12877050.costfilter(c)
	return c:IsReleasable() and c:IsSetCard(0x9a7b) and c:GetOriginalType()&TYPE_PENDULUM>0
end
function c12877050.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877050.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c12877050.costfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_RELEASE)
end
function c12877050.thfilter(c)
	return c:IsSetCard(0x9a7b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c12877050.setg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12877050.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c12877050.seop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tc=Duel.SelectMatchingCard(tp,c12877050.thfilter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
function c12877050.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c12877050.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c12877050.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c12877050.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c12877050.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
end
function c12877050.drfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x9a7b) and c:IsControler(tp)
end
function c12877050.drcon(e,tp,eg,ep,ev,re,r,rp)
	local tp=e:GetHandlerPlayer()
	return eg:IsExists(c12877050.drfilter,1,nil,tp) and Duel.GetFlagEffect(tp,id)<2
end
function c12877050.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,12877050)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
	end
end