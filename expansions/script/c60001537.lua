--伟大的炽天使·勒碧丝
local cm,m,o=GetID()
function cm.initial_effect(c)
	c:EnableCounterPermit(0x624)
	c:EnableCounterPermit(0x625,LOCATION_ONFIELD)
	--eup
	local ee1=Effect.CreateEffect(c)
	ee1:SetType(EFFECT_TYPE_SINGLE)
	ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee1:SetRange(LOCATION_MZONE)
	ee1:SetCode(EFFECT_UPDATE_ATTACK)
	ee1:SetCondition(cm.incon)
	ee1:SetValue(800)
	c:RegisterEffect(ee1)
	local ee2=ee1:Clone()
	ee2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(ee1)
	local ee3=Effect.CreateEffect(c)
	ee3:SetType(EFFECT_TYPE_SINGLE)
	ee3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	ee3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	ee3:SetRange(LOCATION_MZONE)
	ee3:SetCondition(cm.incon)
	ee3:SetValue(1)
	c:RegisterEffect(ee3)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(cm.reptg)
	e1:SetValue(cm.repval)
	c:RegisterEffect(e1)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetCondition(cm.spcon2)
	e3:SetTarget(cm.sptg2)
	e3:SetOperation(cm.spop2)
	c:RegisterEffect(e3)
end
function cm.incon(e)
	return Card.GetCounter(e:GetHandler(),0x624)>=1
end
function cm.repfilter(c,tp,card)
	local ge=c:IsHasEffect(EFFECT_TO_GRAVE_REDIRECT)
	return not ge and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:GetDestination()&LOCATION_GRAVE>0 and c==card
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp,c) end
	if Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
		--c:ReleaseEffectRelation(e)
		c:CancelToGrave()
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
		c:RegisterEffect(e1)
		c:AddCounter(0x625,2)
		Duel.RegisterFlagEffect(tp,60002177,0,0,1) --结晶
		
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_COUNTER)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
		e1:SetCountLimit(1)
		e1:SetOperation(cm.Countdowncost)
		e1:SetRange(LOCATION_SZONE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_SZONE)
		e1:SetCode(EFFECT_SELF_DESTROY)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetCondition(cm.Countdowncon)
		c:RegisterEffect(e1)
	end
	return true
end
function cm.repval(e,c)
	return true
end
function cm.Countdowncost(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsCanRemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT) then
		Card.RemoveCounter(e:GetHandler(),tp,0x625,1,REASON_EFFECT)
	end
end
function cm.Countdowncon(e)
	return Card.GetCounter(e:GetHandler(),0x625)==0
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_SZONE)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
		end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
end