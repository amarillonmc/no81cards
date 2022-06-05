--灭杀狱罪魔凰
local cm,m,o=GetID()
cm.pendulum_level=11
function cm.initial_effect(c)
	aux.AddCodeList(c,20000523)
	Auxiliary.AddXyzProcedureLevelFree(c,cm.xyzf,cm.xyzgf,3,3)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.val1)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetCode(EFFECT_DISABLE)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(cm.con3)
	e3:SetTarget(cm.tg3)
	e3:SetOperation(cm.op3)
	c:RegisterEffect(e3)
	--Great Sin of Sin Moonless Night
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_GRAVE+LOCATION_EXTRA)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.con4)
	e4:SetOperation(cm.op4)
	c:RegisterEffect(e4)
	--pendulum set
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_PZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(cm.tg5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
end
--xyz
function cm.xyzf(c,xyzc)
	return c:IsSetCard(0xfd6)
end
function cm.xyzgf(g)
	return g:IsExists(Card.IsType,1,nil,TYPE_XYZ)
end
--e1
function cm.val1(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ or bit.band(st,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM or se:GetHandler():IsSetCard(0xfd6)
end
--e2
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,20000523) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.tg2(e,c)
	if c:IsSetCard(0xfd6) then return end
	return not Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,1,nil,c:GetCode())
end
--e3
function cm.con3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsFaceup()
end
function cm.tgf3(c,tp)
	return c:IsAbleToHand() and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) 
		or aux.SZoneSequence(c:GetSequence())==4 or aux.SZoneSequence(c:GetSequence())==0)
end
function cm.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf3,tp,LOCATION_SZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_SZONE)
end
function cm.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.tgf3,tp,LOCATION_SZONE,0,1,1,nil,tp)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
--e4
function cm.con4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.opf4,tp,LOCATION_REMOVED,0,nil)
	return (c:IsLocation(LOCATION_GRAVE) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0) or (c:IsFaceup() and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0)
		and #g>5 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.opf4(c)
	return c:IsSetCard(0x3fd5,0xfd6)
end
function cm.op4(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.opf4,tp,LOCATION_REMOVED,0,nil)
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		g = g:Select(tp,6,6,e:GetHandler())
		if Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
			Duel.Overlay(e:GetHandler(),g)
			Duel.SpecialSummonComplete()
		end
	end
end
--e5
function cm.tgf5(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup())
end
function cm.tg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(cm.tgf5,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,nil) end
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,cm.tgf5,tp,LOCATION_MZONE+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end