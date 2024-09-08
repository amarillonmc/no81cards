--渊洋海兽 观察者
local m = 11636050
local cm = _G["c"..m]
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)  
	--to hand or summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--synchro material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)   
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetTarget(cm.reptg)
	c:RegisterEffect(e3)
	--debuff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_PUBLIC)
	e4:SetRange(LOCATION_EXTRA)
	e4:SetTargetRange(LOCATION_HAND,0)
	e4:SetCondition(cm.decon)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_EXTRA)
	e5:SetCountLimit(1)
	e5:SetCondition(cm.tgcon)
	e5:SetOperation(cm.tgop)
	c:RegisterEffect(e5)
end

--
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local p=tc:GetSummonPlayer()
	cm[p]=cm[p]+1
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
--
function cm.filter(c)
	return c:IsSetCard(0x9223)  and c:IsType(TYPE_MONSTER)
end
function cm.filter2(c,lv)
	return c:IsSetCard(0x9223)  and c:IsType(TYPE_MONSTER) and not c:IsLevel(lv)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 and ft>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)  end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<5 then return end
	local g=Duel.GetDecktopGroup(tp,5)
	Duel.ConfirmCards(tp,g)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not c:IsRelateToEffect(e) or not c:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	if ft>0 and g:IsExists(cm.filter,1,nil)  then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
	end
end
--
function cm.repfilter(c)
	return  c:GetLeaveFieldDest()==0 and bit.band(c:GetReason(),REASON_MATERIAL+REASON_SYNCHRO)==REASON_MATERIAL+REASON_SYNCHRO  and  c:GetReasonCard():IsSetCard(0x223)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return cm.repfilter(c)
	end
	if cm.repfilter(c) then
		Duel.SendtoExtraP(c,1-c:GetControler(),REASON_EFFECT+REASON_REDIRECT)
		return true
	end
	return false
end
--

function cm.decon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=e:GetHandler():GetOwner()
	return p~=e:GetHandler():GetControler()
end
---
--
function cm.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local p=e:GetHandler():GetOwner()
	local tp=e:GetHandlerPlayer()
	return Duel.GetTurnPlayer()==tp and p~=e:GetHandler():GetControler()
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetHandler(),REASON_EFFECT)
end