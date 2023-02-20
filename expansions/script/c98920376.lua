--极星宝 兰蒂格瑞丝
function c98920376.initial_effect(c)
	--maintain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(c98920376.descon)
	e2:SetOperation(c98920376.desop)
	c:RegisterEffect(e2)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,98920376+EFFECT_COUNT_CODE_OATH)
	e1:SetHintTiming(0,TIMING_END_PHASE+TIMINGS_CHECK_MONSTER)
	e1:SetOperation(c98920376.activate)
	c:RegisterEffect(e1)
--cannot attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetTarget(c98920376.tg)
	e2:SetCondition(c98920376.con)
	c:RegisterEffect(e2)
 --activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(0,1)
	e1:SetCondition(c98920376.actcon)
	e1:SetValue(c98920376.aclimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,1)
	e2:SetCondition(c98920376.actcon)
	e2:SetTarget(c98920376.sumlimit)
	c:RegisterEffect(e2)
end
function c98920376.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function c98920376.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c98920376.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	if Duel.CheckReleaseGroup(tp,nil,1,c) and Duel.SelectYesNo(tp,aux.Stringid(98920376,0)) then
		local g=Duel.SelectReleaseGroup(tp,nil,1,1,c)
		Duel.Release(g,REASON_COST)
	else Duel.Destroy(c,REASON_COST) end
end
function c98920376.filter(c)
	return c:IsSetCard(0x42) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function c98920376.activate(e,tp,eg,ep,ev,re,r,rp)
   if Duel.SelectYesNo(tp,aux.Stringid(98920376,1)) then
	  local g=Duel.SelectMatchingCard(tp,c98920376.filter,tp,LOCATION_DECK,0,1,1,nil)
	  if g:GetCount()>0 then
		  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
		  local tc=g:GetFirst()
		  if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
			  Duel.SendtoHand(tc,nil,REASON_EFFECT)
			  Duel.ConfirmCards(1-tp,tc)
		  else
			  Duel.SendtoGrave(tc,REASON_EFFECT)
		  end
	   end
	end
end
function c98920376.afilter(c)
	return c:IsFaceup() and c:IsSetCard(0x42)
end
function c98920376.con(e)
	return Duel.IsExistingMatchingCard(c98920376.afilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,1,nil)
end
function c98920376.tg(e,c)
	return c:IsFaceup()
end
function c98920376.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil,0x4b)
end
function c98920376.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end