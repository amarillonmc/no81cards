--重塑时光之忆
function c60010132.initial_effect(c)
	aux.AddCodeList(c,60010030)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c60010132.condition)
	e0:SetOperation(c60010132.activate)
	c:RegisterEffect(e0)
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(60010132)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,60010132)
	e2:SetCondition(c60010132.incon)
	e2:SetTarget(c60010132.intg)
	e2:SetOperation(c60010132.inop)
	c:RegisterEffect(e2)
	--space check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_NO_TURN_RESET)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetRange(0xff)
	e3:SetCountLimit(1,60010129+EFFECT_COUNT_CODE_DUEL)
	e3:SetOperation(c60010132.checkop)
	c:RegisterEffect(e3)
end
function c60010132.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not SpaceCheck then
		SpaceCheck={}
		for i=0,1 do
			local g=Duel.GetMatchingGroup(nil,i,LOCATION_HAND+LOCATION_DECK,0,nil)
			if #g==g:GetClassCount(Card.GetCode) then
				SpaceCheck[i]=true
			end
		end
	end
end
function c60010132.condition(e,tp,eg,ep,ev,re,r,rp)
	return SpaceCheck[tp]
end
function c60010132.thfilter(c)
	return c:IsCode(60010030) and c:IsAbleToHand()
end
function c60010132.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c60010132.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(60010132,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c60010132.ownerfilter(c,tp)
	return c:IsCode(60010030) and c:IsFaceup() and c:IsSummonPlayer(tp)
end
function c60010132.incon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c60010132.ownerfilter,1,nil,tp)
end
function c60010132.intg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,60010132)==0 and Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2 end
end
function c60010132.inop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(c60010132.efilter)
	if Duel.GetCurrentPhase()==PHASE_MAIN1 then
		e1:SetReset(RESET_PHASE+PHASE_MAIN1)
		Duel.RegisterFlagEffect(tp,60010132,RESET_PHASE+PHASE_MAIN1,0,1)
	else
		e1:SetReset(RESET_PHASE+PHASE_MAIN2)
		Duel.RegisterFlagEffect(tp,60010132,RESET_PHASE+PHASE_MAIN2,0,1)
	end
	Duel.RegisterEffect(e1,tp)
end
function c60010132.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer() and re:IsActivated()
end
