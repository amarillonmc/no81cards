--混沌的终幕·辛恩
function c60002282.initial_effect(c)
	c:EnableCounterPermit(0x624)
	--to e1
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_COUNTER) 
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c60002282.con)
	e1:SetTarget(c60002282.ddtg)
	e1:SetOperation(c60002282.ddop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--to e3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetCondition(c60002282.incon)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE) 
	c:RegisterEffect(e4)
	--to e5
	local e5=Effect.CreateEffect(c) 
	e5:SetDescription(aux.Stringid(60002282,0))
	e5:SetCategory(CATEGORY_DAMAGE) 
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c60002282.excon)
	e5:SetTarget(c60002282.damtg)
	e5:SetOperation(c60002282.damop)
	c:RegisterEffect(e5) 
end
--exto e1
function c60002282.con(e,tp)
   return Duel.GetFlagEffect(tp,60002148)>=5
end  
function c60002282.ddtg(e,tp,eg,ep,ev,re,r,rp,chk) 
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x624)
end  
function c60002282.ddop(e,tp,eg,ep,ev,re,r,rp) 
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x624,1)
		Duel.RegisterFlagEffect(tp,60002148,RESET_PHASE+PHASE_END,0,1000) 
	end
end 
--exto e3
function c60002282.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
--exto e5
function c60002282.excon(e,tp)
   return Duel.GetFlagEffect(tp,60002148)>=10 and Card.GetCounter(e:GetHandler(),0x624)>=1 and Duel.GetTurnPlayer()==tp
end 
function c60002282.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return  Duel.IsPlayerCanDraw(tp,3) end 
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,1-tp,4000) 
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,4000)
end
function c60002282.damop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	   if Duel.Damage(1-tp,4000,REASON_EFFECT)~=0 then
		   if Duel.Recover(tp,4000,REASON_EFFECT)~=0 then
			  if  Duel.Draw(tp,3,REASON_EFFECT)~=0 then
				 if g:GetCount()>=3 then
					Duel.DiscardHand(1-tp,nil,3,3,REASON_EFFECT+REASON_DISCARD)
				elseif g:GetCount()<3 then
					Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
				 end
			  end
		  end
	  end
end