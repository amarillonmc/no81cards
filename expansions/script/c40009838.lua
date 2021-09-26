--无命王 死之锚
local m=40009838
local cm=_G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--summon with s/t
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetValue(POS_FACEUP_ATTACK)
	c:RegisterEffect(e1)  
	--atk/def up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_PENDULUM))
	e2:SetValue(cm.val)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)  
	--to hand
	--local e4=Effect.CreateEffect(c)
	--e4:SetDescription(aux.Stringid(m,0))
   -- e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_TOEXTRA)
	--e4:SetType(EFFECT_TYPE_IGNITION)
	--e4:SetRange(LOCATION_PZONE)
	--e4:SetCountLimit(1,m+1)
   -- e4:SetTarget(cm.ptg)
   -- e4:SetOperation(cm.pop)
	--c:RegisterEffect(e4)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_HANDES+CATEGORY_TOEXTRA)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.thcon)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3) 
	--sp token
	--local e4=Effect.CreateEffect(c)
   -- e4:SetDescription(aux.Stringid(m,3))
   -- e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
   -- e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
   -- e4:SetCode(EVENT_PHASE+PHASE_END)
   -- e4:SetRange(LOCATION_MZONE)
   -- e4:SetCountLimit(1,m)
   -- e4:SetCondition(cm.sumcon)
   -- e4:SetTarget(cm.sumtg)
   -- e4:SetOperation(cm.sumop)
   -- c:RegisterEffect(e4) 
end
function cm.cfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(cm.cfilter,e:GetHandlerPlayer(),LOCATION_EXTRA,0,nil)*200
end
function cm.pthfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function cm.pfilter(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and Duel.IsExistingMatchingCard(cm.pthfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function cm.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.pfilter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.pop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectMatchingCard(tp,cm.pfilter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	if g:GetCount()==0 then return end
	local code=g:GetFirst():GetCode()
	local dg1=Duel.GetMatchingGroup(cm.pthfilter,tp,LOCATION_DECK,0,nil,code)
	if dg1:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg1=dg1:Select(tp,1,1,nil)
		Duel.SendtoHand(sg1,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg1)
		dg1:Sub(sg1)
	end
	Duel.SendtoExtraP(dg1,tp,REASON_EFFECT)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsFaceup() and c:GetTurnID()==Duel.GetTurnCount() 
end
function cm.tefilter(c)
	return c:IsType(TYPE_PENDULUM)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)>0
		and Duel.IsExistingMatchingCard(cm.tefilter,tp,LOCATION_GRAVE,0,1,nil) and e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,2))
	local g=Duel.SelectMatchingCard(tp,cm.tefilter,tp,LOCATION_GRAVE,0,1,2,nil)
	if g:GetCount()>0 and c:IsRelateToEffect(e) then
		Duel.SendtoExtraP(g,tp,REASON_EFFECT)
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function cm.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_EXTRA,0,8,nil)
end
function cm.sumfilter(c,ec)
	if not c:IsLevelAbove(5) then return false end
	local e1=Effect.CreateEffect(ec)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_SZONE,0)
	e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
	e1:SetRange(LOCATION_HAND)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
	local res=c:IsSummonable(true,nil,1)
	e1:Reset()
	return res
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_EXTRA+LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,c):GetFirst()
	if tc and Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
		e1:SetTargetRange(LOCATION_SZONE,0)
		e1:SetTarget(function(e,c) return e:GetHandler()~=c and c:IsLocation(LOCATION_PZONE) and c:IsType(TYPE_PENDULUM) end)
		e1:SetRange(LOCATION_HAND)
		e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		Duel.Summon(tp,tc,true,nil,1)
	end
end


