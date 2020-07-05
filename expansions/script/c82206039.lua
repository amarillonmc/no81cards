local m=82206039
local cm=_G["c"..m]
cm.name="植占师19-机枪"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c) 
	--splimit  
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetRange(LOCATION_PZONE)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	c:RegisterEffect(e1)
	--spsummon  
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))  
	e2:SetCategory(CATEGORY_TOHAND)  
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_RECOVER)  
	e2:SetProperty(EFFECT_FLAG_DELAY)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetCountLimit(1,m)
	e2:SetCost(cm.spcost)
	e2:SetCondition(cm.spcon)  
	e2:SetTarget(cm.sptg)  
	e2:SetOperation(cm.spop)  
	c:RegisterEffect(e2)
	--destroy  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_IGNITION)  
	e1:SetRange(LOCATION_MZONE)  
	e1:SetCountLimit(1,82216039)  
	e1:SetTarget(cm.destg)  
	e1:SetOperation(cm.desop)  
	c:RegisterEffect(e1) 
	--pendulum  
	local e5=Effect.CreateEffect(c)  
	e5:SetDescription(aux.Stringid(m,2))  
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e5:SetProperty(EFFECT_FLAG_DELAY)  
	e5:SetCode(EVENT_DESTROYED)  
	e5:SetCondition(cm.pencon)  
	e5:SetTarget(cm.pentg)  
	e5:SetOperation(cm.penop)  
	c:RegisterEffect(e5)   
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp)  
	if c:IsRace(RACE_PLANT) then return false end  
	return bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM  
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)  
	return ep==tp  
end
function cm.rfilter(c,ft,tp)  
	return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())  
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,cm.rfilter,1,nil,ft,tp) end  
	local sg=Duel.SelectReleaseGroup(tp,cm.rfilter,1,1,nil,ft,tp)  
	Duel.Release(sg,REASON_COST)  
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	if not c:IsRelateToEffect(e) then return end  
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)  
end 
function cm.ctfilter(c)  
	return c:IsFaceup() and c:IsSetCard(0x129d)  
end  
function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfilter,tp,LOCATION_MZONE,0,1,nil)  
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,1,nil) end  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)  
end  
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)  
	if ct>0 and g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
		local dg=g:Select(tp,1,ct,nil)  
		Duel.HintSelection(dg)  
		local ct=Duel.Destroy(dg,REASON_EFFECT)
		if ct>0 then  
			local e1=Effect.CreateEffect(c)  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_UPDATE_ATTACK)  
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)  
			e1:SetValue(ct*500)  
			c:RegisterEffect(e1)  
		end 
	end  
end
function cm.pencon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler()  
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()  
end  
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end  
end  
function cm.penop(e,tp,eg,ep,ev,re,r,rp)  
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end  
	local c=e:GetHandler()  
	if c:IsRelateToEffect(e) then  
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)  
	end  
end  