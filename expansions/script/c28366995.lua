--闪耀的六出花 繁花幸福论
function c28366995.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,c28366995.matfilter,nil,nil,aux.FilterBoolFunction(Card.IsRace,RACE_FAIRY),1,1)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,28366995)
	e1:SetCondition(c28366995.recon)
	e1:SetTarget(c28366995.retg)
	e1:SetOperation(c28366995.reop)
	c:RegisterEffect(e1)
	c28366995.recover_effect=e1
	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,28366995)
	e2:SetCondition(c28366995.thcon)
	e2:SetTarget(c28366995.thtg)
	e2:SetOperation(c28366995.thop)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetOperation(c28366995.indop)
	c:RegisterEffect(e3)
end
function c28366995.matfilter(c,syncard)
	return c:IsTuner(syncard) or Duel.GetLP(c:GetControler())>8000
end
function c28366995.recon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c28366995.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,1000)
end
function c28366995.cfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsAbleToHand()
end
function c28366995.reop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Recover(tp,1000,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(c28366995.cfilter,tp,LOCATION_GRAVE,0,1,nil)
	if Duel.GetLP(tp)>=10000 and #g>0 and Duel.SelectYesNo(tp,aux.Stringid(28366995,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c28366995.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>8000
end
function c28366995.thfilter(c)
	return c:IsSetCard(0x286,0x289) and c:IsAbleToHand()
end
function c28366995.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c28366995.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c28366995.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c28366995.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if Duel.SendtoHand(tg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,tg)
		local lp=Duel.GetLP(tp)
		Duel.SetLP(tp,lp-2000)
	end
end
function c28366995.indop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(1)
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	rc:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c28366995.fuslimit)
	rc:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	rc:RegisterEffect(e4,true)
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	rc:RegisterEffect(e5,true)
	local e6=e1:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	rc:RegisterEffect(e6,true)
	rc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(28366995,1))
end
function c28366995.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end
