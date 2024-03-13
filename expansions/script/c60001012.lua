--岚术姬 零衣
local cm,m,o=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(cm.aclimit)
	c:RegisterEffect(e1)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabel(c:GetSequence())
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_PZONE)
	e1:SetLabel(c:GetSequence())
	e1:SetCondition(cm.spcon)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)

	--tohand
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con1)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	--tohand(2)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1,m+10000000)
	e2:SetTarget(cm.desreptg)
	e2:SetValue(cm.desrepval)
	e2:SetOperation(cm.desrepop)
	c:RegisterEffect(e2)

	Duel.AddCustomActivityCounter(m,ACTIVITY_CHAIN,cm.chainfilter)
end
if not cm.lsy_change_operation then
	cm.lsy_change_operation=true
-----------------------------------------------------------------------------------------
	cm._special_summon=Duel.SpecialSummon
	Duel.SpecialSummon=function (c,a,tp,x,d,e,f,...)
		local sol=0
		local tc=0
		local single=0
		if aux.GetValueType(c)=="Card" then
			tc=c
			single=1
		elseif aux.GetValueType(c)=="Group" then
			tc=c:GetFirst()
			if c:GetCount()==1 then
				single=1
			end
		end
		-----------------------------------------------------------------------------------------
		if tc:IsCode(60001012) and single==1 and Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,tc,0x624):GetFirst():IsAbleToHand() and Duel.SelectYesNo(tp,aux.Stringid(60001012,0)) then
			Duel.Hint(HINT_CARD,0,60001012)
			local ac=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,tc,0x624)
			Duel.SendtoHand(ac,nil,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_DECK) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		elseif tc:IsCode(60001013) and single==1 and Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_DECK,0,tc,0x624):GetFirst():IsAbleToGrave() and Duel.SelectYesNo(tp,aux.Stringid(60001013,0)) then
			Duel.Hint(HINT_CARD,0,60001013)
			local ac=Duel.SelectMatchingCard(tp,Card.IsSetCard,tp,LOCATION_DECK,0,1,1,tc,0x624)
			Duel.SendtoGrave(ac,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_DECK) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		elseif tc:IsCode(60001014) and single==1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60001014,0)) then
			Duel.Hint(HINT_CARD,0,60001014)
			local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_ONFIELD,nil)
			Duel.SendtoGrave(g1,REASON_EFFECT)
			local g2=Duel.GetMatchingGroup(Card.IsFacedown,tp,0,LOCATION_ONFIELD,nil)
			Duel.Remove(g2,POS_FACEDOWN,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_DECK) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		elseif tc:IsCode(60001016) and single==1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(60001016,0)) then
			Duel.Hint(HINT_CARD,0,60001016)
			local rc=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_HAND,nil):RandomSelect(tp,1)
			Duel.Remove(rc,POS_FACEDOWN,REASON_EFFECT)
			if not tc:IsLocation(LOCATION_DECK) then
				Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
			end
		else
			cm._special_summon(c,a,tp,x,d,e,f,...)
			if aux.GetValueType(c)=="Card" then
				sol=1
			elseif aux.GetValueType(c)=="Group" then
				sol=c:GetCount()
			end
		end
		-----------------------------------------------------------------------------------------
		return sol
	end
-----------------------------------------------------------------------------------------
end
function cm.aclimit(e,re,tp)
	return re:GetActivateLocation()==LOCATION_GRAVE and re:GetHandler():IsType(TYPE_SPELL)
end
function cm.cfilter(c,tp,seq,fid)
	return aux.GetColumn(c,tp)==seq and c:GetFieldID()~=fid
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local seq,fid=e:GetLabel()
	local tp=e:GetHandlerPlayer()
	return eg:IsExists(cm.cfilter,1,nil,tp,seq,fid)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function cm.chainfilter(re,tp)
	return not re:GetHandler():IsSetCard(0x624) and re:GetHandler():IsCode(m)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function cm.repfilter(c,tp)
	return c:IsControler(tp)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,c,96)
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,m)
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Draw(tp,1,REASON_EFFECT)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_DECKSHF)
		c:RegisterEffect(e1)
	end
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)==0
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCustomActivityCount(m,tp,ACTIVITY_CHAIN)>0 
end