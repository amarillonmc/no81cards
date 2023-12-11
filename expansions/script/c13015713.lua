--深海姬的蚌壳舞台
function c13015713.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,13015713)
	e1:SetOperation(c13015713.activate)
	c:RegisterEffect(e1)
	--change effect type
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(13015713)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--TTT 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetCode(EVENT_MOVE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetOperation(c13015713.adop)
	c:RegisterEffect(e4)
	--
end
function c13015713.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe01) and c:IsAbleToHand()
end
function c13015713.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c13015713.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(13015713,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end 
if not aux.sh_qh_qechk then
	aux.sh_qh_qechk=true
	_rge=Card.RegisterEffect 
	function Card.RegisterEffect(c,ie,ob) --ReplaceEffect
		local b=ob or false
		if not (c:IsOriginalSetCard(0xe01) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_LINK+TYPE_SYNCHRO+TYPE_XYZ+TYPE_FUSION)) 
			or not (ie:IsHasType(EFFECT_TYPE_IGNITION) and ie==c.tdr_effect) then
			return _rge(c,ie,b)
		end  
		local n1=_rge(c,ie,b) 
		local qe=ie:Clone()
		qe:SetType(EFFECT_TYPE_QUICK_O)
		qe:SetCode(EVENT_FREE_CHAIN)
		qe:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
		if ie:GetCondition() then
			local con=ie:GetCondition()
			qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(tp,13015713)
					and con(e,tp,eg,ep,ev,re,r,rp) 
				end)
		else qe:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():IsLocation(LOCATION_HAND) and Duel.IsPlayerAffectedByEffect(tp,13015713) end)
		end
		if ie:GetCondition() then
			local con=ie:GetCondition()
			ie:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
				return e:GetHandler():IsLocation(LOCATION_HAND) and not Duel.IsPlayerAffectedByEffect(tp,13015713)
					and con(e,tp,eg,ep,ev,re,r,rp) 
				end)
		else ie:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
			return e:GetHandler():IsLocation(LOCATION_HAND) and not Duel.IsPlayerAffectedByEffect(tp,13015713) end)
		end
		local n2=_rge(c,qe,b)
		return n1,n2
	end
end
function c13015713.filsn(c)
	return c:IsOriginalSetCard(0xe01) and c:IsType(TYPE_MONSTER) and not c:GetFlagEffectLabel(id)
end
function c13015713.adop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ng=Duel.GetMatchingGroup(c13015713.filsn,tp,LOCATION_HAND,0,c)
	local nc=ng:GetFirst()
	while nc do
		nc:RegisterFlagEffect(id,0,0,1)
		nc:ReplaceEffect(nc:GetCode(),0)
		nc=ng:GetNext()
	end
end
