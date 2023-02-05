--归魂复仇死者·强袭者
function c98920047.initial_effect(c)
		--xyz summon
	aux.AddXyzProcedure(c,c98920047.mfilter,4,2,c98920047.ovfilter,aux.Stringid(98920047,0),3,c98920047.xyzop)
	c:EnableReviveLimit()	
	--
	aux.EnableChangeCode(c,4388680)	
--pos change
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetDescription(aux.Stringid(98920047,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(c98920047.cost)
	e1:SetTarget(c98920047.target)
	e1:SetOperation(c98920047.operation)
	c:RegisterEffect(e1) 
   --search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920047,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,98920047)
	e2:SetCondition(c98920047.stcon)
	e2:SetTarget(c98920047.sttg)
	e2:SetOperation(c98920047.stop)
	c:RegisterEffect(e2)
end
function c98920047.mfilter(c)
	return c:IsRace(RACE_ZOMBIE)
end
function c98920047.ovfilter(c)
	return c:IsFaceup() and c:IsCode(4388680) and not c:IsType(TYPE_XYZ)
end
function c98920047.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,98920047)==0 end
	Duel.RegisterFlagEffect(tp,98920047,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c98920047.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c98920047.filter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c98920047.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920047.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c98920047.operation(e,tp,eg,ep,ev,re,r,rp)	
	local c=e:GetHandler()	
	local g=Duel.GetMatchingGroup(c98920047.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
	   if Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0 then			
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(0)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)		
		end
		tc=g:GetNext() 
	end  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)	
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCode,4388680))	
	e1:SetReset(RESET_PHASE+PHASE_END) 
	Duel.RegisterEffect(e1,tp) 
end
function c98920047.efftg(e,c)
	return c:IsCode(4388680)
end
function c98920047.stcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_XYZ)
end
function c98920047.stfilter(c)  
	return c:IsSetCard(0x106) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function c98920047.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tp=e:GetHandler():GetControler() 
	if chk==0 then return Duel.IsExistingMatchingCard(c98920047.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end  
end  
function c98920047.stop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,c98920047.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	local tc=g:GetFirst()
	if g:GetCount()~=0 and Duel.SSet(tp,g)>0 then   
		  if tc:IsType(TYPE_QUICKPLAY) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		  end
		  if tc:IsType(TYPE_TRAP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		 end
	end
end