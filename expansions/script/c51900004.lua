--《不详·征兆》祸圣女
function c51900004.initial_effect(c)
	aux.AddCodeList(c,51900003) 
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,51900004+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c51900004.spcon)
	e1:SetOperation(c51900004.spop)
	c:RegisterEffect(e1) 
	--search
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE) 
	e2:SetCountLimit(1,11900004) 
	e2:SetCondition(c51900004.thcon)
	e2:SetCost(c51900004.thcost)
	e2:SetTarget(c51900004.thtg)
	e2:SetOperation(c51900004.thop)
	c:RegisterEffect(e2)
	--effect gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e2:SetCondition(c51900004.efcon)
	e2:SetOperation(c51900004.efop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(51900004,ACTIVITY_SPSUMMON,c51900004.counterfilter)
end
function c51900004.counterfilter(c)
	return not c:IsSummonLocation(LOCATION_EXTRA) or c:IsType(TYPE_FUSION)
end
function c51900004.cfilter(c,tp) 
	local b1=c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_DRAGON)
	local b2=c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_FAIRY) 
	return c:IsLevelBelow(8) and (b1 or b2)  
		and Duel.GetMZoneCount(tp,c)>0
end
function c51900004.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.CheckReleaseGroupEx(tp,c51900004.cfilter,1,REASON_SPSUMMON,false,nil,tp)
end
function c51900004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroupEx(tp,c51900004.cfilter,1,1,REASON_SPSUMMON,false,nil,tp)
	Duel.Release(g,REASON_SPSUMMON)
end
function c51900004.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(51900004,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c51900004.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c51900004.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsType(TYPE_FUSION)
end
function c51900004.thcon(e,tp,eg,ep,ev,re,r,rp) 
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end 
function c51900004.thfilter(c)
	return (c:IsCode(51900003) or aux.IsCodeListed(c,51900003)) and c:IsAbleToHand()
end
function c51900004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c51900004.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c51900004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c51900004.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c51900004.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_FUSION 
end
function c51900004.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(51900004,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(aux.tgoval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
	rc:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	rc:RegisterEffect(e2,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
