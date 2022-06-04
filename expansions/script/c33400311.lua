--夜刀神天香 蔑视
local m=33400311
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableReviveLimit()
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,5))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCountLimit(1,m)
	e1:SetCondition(aux.bdcon)
	e1:SetOperation(cm.desop)
	c:RegisterEffect(e1)
	 -- IMMUNE
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.imtg)
	e2:SetOperation(cm.imop)
	c:RegisterEffect(e2)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
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
	e4:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e4,1-tp)
	--cannot trigger
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_TRIGGER)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetTargetRange(LOCATION_SZONE,0)
	e5:SetTarget(cm.distg)
	e5:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e5,1-tp)
	if Duel.IsExistingMatchingCard(cm.refilter1,tp,0,LOCATION_ONFIELD,1,nil)  then
	   if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then 
		 local tc1=Duel.SelectMatchingCard(tp,cm.refilter1,tp,0,LOCATION_ONFIELD,1,1,nil)
		 Duel.Remove(tc1,POS_FACEDOWN,REASON_EFFECT)
	   end 
	end
	local k1=Duel.GetMatchingGroup(cm.thfilter1,tp,LOCATION_GRAVE,0,nil)
	local k2=Duel.GetMatchingGroup(cm.thfilter2,tp,LOCATION_GRAVE,0,nil)
	if Duel.GetTurnPlayer()~=tp and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and  (k1 or k2) then 
	   if Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
				local g=Duel.SelectMatchingCard(tp,cm.thfilter3,tp,LOCATION_GRAVE,0,1,1,nil,tp)
				local tc=g:GetFirst()
				if tc then  
			   local b1=tc:IsSSetable()
			   local b2=tc:IsForbidden()
					if  b1 and (b2 or Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))==0) then
						Duel.SSet(tp,tc)
						Duel.ConfirmCards(1-tp,tc)
					else						
						Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)	  
					end
				end
		end
	end
end
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return bit.band(sumpos,POS_FACEDOWN)~=0
end
function cm.distg(e,c)
	return c:IsFacedown()
end
function cm.refilter1(c)
	return  c:IsAbleToRemove()  and c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.thfilter1(c)
	return  c:IsSetCard(0x5341) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()
end
function cm.thfilter2(c)
	return  c:IsSetCard(0x5341)  and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsForbidden()
end
function cm.thfilter3(c)
	return  c:IsSetCard(0x5341) and c:IsType(TYPE_SPELL+TYPE_TRAP) and (c:IsSSetable() or not c:IsForbidden())
end

function cm.imfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341)
end
function cm.imtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and cm.imfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.imfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,cm.imfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function cm.imop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
	 local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end