--夜刀神天香 蔑视
function c33400311.initial_effect(c)
	 c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,33400311)
	e1:SetCondition(aux.bdcon)
	e1:SetOperation(c33400311.desop)
	c:RegisterEffect(e1)
	 -- IMMUNE
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33400311+10000)
	e2:SetTarget(c33400311.imtg)
	e2:SetOperation(c33400311.imop)
	c:RegisterEffect(e2)
end
function c33400311.desop(e,tp,eg,ep,ev,re,r,rp)
	--cannot set
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TRUE)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,1-tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SSET)
	Duel.RegisterEffect(e2,1-tp)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_TURN_SET)
	Duel.RegisterEffect(e3,1-tp)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetTarget(c33400311.sumlimit)
	Duel.RegisterEffect(e4,1-tp)
	--cannot trigger
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(c33400311.distg)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,1-tp)
	if Duel.IsExistingMatchingCard(c33400311.thfilter1,tp,LOCATION_GRAVE,0,1,nil,tp) then 
	   if Duel.SelectYesNo(tp,aux.Stringid(33400311,0)) then 
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400311,1))
				local g=Duel.SelectMatchingCard(tp,c33400311.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
				local tc=g:GetFirst()
				if tc then
					local b1=tc:IsAbleToHand()
					local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)
					if  b1 and (b2==0 or Duel.SelectOption(tp,aux.Stringid(33400311,2),aux.Stringid(33400311,3))==0) then
						Duel.SendtoHand(tc,nil,REASON_EFFECT)
						Duel.ConfirmCards(1-tp,tc)
					else						
						Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
						local te=tc:GetActivateEffect()
						local tep=tc:GetControler()
						local cost=te:GetCost()
						if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end					 
					end
				end
		end
	end
end
function c33400311.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function c33400311.distg(e,c)
	return c:IsFacedown()
end
function c33400311.thfilter1(c)
	return  (c:IsAbleToHand() or not c:IsForbidden()) and c:IsCode(33400350)
end
function c33400311.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function c33400311.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400311.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400311.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400311.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33400311.imop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	  local e4=Effect.CreateEffect(e:GetHandler())
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetCode(EFFECT_IMMUNE_EFFECT)
			e4:SetValue(c33400311.efilter)
			e4:SetOwnerPlayer(tp)
			e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e4)
	end
end
function c33400311.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end

