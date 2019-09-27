--夜刀神天香 毁灭
function c33400312.initial_effect(c)
	 c:EnableReviveLimit()
	--activate limit
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,33400312)
	e1:SetCondition(aux.bdcon)
	e1:SetOperation(c33400312.alsop)
	c:RegisterEffect(e1)
	 -- Double damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,33400312+10000)
	e2:SetTarget(c33400312.dbtg)
	e2:SetOperation(c33400312.dbop)
	c:RegisterEffect(e2)
end
function c33400312.thfilter1(c)
	return  (c:IsAbleToHand() or not c:IsForbidden()) and c:IsCode(33400355)
end
function c33400312.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE
end
function c33400312.alsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c33400312.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp) 
	if Duel.IsExistingMatchingCard(c33400312.thfilter1,tp,LOCATION_GRAVE,0,1,nil) then 
	   if Duel.SelectYesNo(tp,aux.Stringid(33400312,0)) then 
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(33400312,1))
				local g=Duel.SelectMatchingCard(tp,c33400312.thfilter1,tp,LOCATION_GRAVE,0,1,1,nil,tp)
				local tc=g:GetFirst()
				if tc then
					local b1=tc:IsAbleToHand()
					local b2=Duel.GetLocationCount(tp,LOCATION_SZONE)
					if b1 and (b2==0 or Duel.SelectOption(tp,aux.Stringid(33400312,2),aux.Stringid(33400312,3))==0) then
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
function c33400312.dbfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function c33400312.dbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c33400312.dbfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c33400312.dbfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c33400312.dbfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c33400312.dbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e1:SetCondition(c33400312.damcon)
		e1:SetOperation(c33400312.damop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c33400312.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and e:GetHandler():GetBattleTarget()~=nil
end
function c33400312.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev*2)
end