local m=31400110
local cm=_G["c"..m]
cm.name="真龙星-神数望天吼"
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.pentg)
	e1:SetOperation(cm.penop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(cm.reptg)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(cm.thtg)
	e3:SetOperation(cm.thop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(cm.sptg)
	e4:SetOperation(cm.spop)
	c:RegisterEffect(e4)
end
function cm.recon(e)
	return e:GetHandler():IsFaceup()
end
function cm.penfilter(c)
	return c:IsRace(RACE_WYRM) and not c:IsForbidden()
end
function cm.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable() and Duel.IsExistingMatchingCard(cm.penfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function cm.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.Destroy(c,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local g=Duel.SelectMatchingCard(tp,cm.penfilter,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			if not tc:IsType(TYPE_PENDULUM) then
				local eP=Effect.CreateEffect(c)
				eP:SetType(EFFECT_TYPE_SINGLE)
				eP:SetCode(EFFECT_ADD_TYPE)
				eP:SetValue(TYPE_PENDULUM)
				eP:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(eP)
				local ePS=Effect.CreateEffect(c)
				ePS:SetDescription(1163)
				ePS:SetType(EFFECT_TYPE_FIELD)
				ePS:SetCode(EFFECT_SPSUMMON_PROC_G)
				ePS:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				ePS:SetRange(LOCATION_PZONE)
				ePS:SetCondition(aux.PendCondition())
				ePS:SetOperation(aux.PendOperation())
				ePS:SetValue(SUMMON_TYPE_PENDULUM)
				ePS:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(ePS)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_LSCALE)
				e1:SetValue(tc:GetLevel())
				e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
				tc:RegisterEffect(e1)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_CHANGE_RSCALE)
				e2:SetValue(tc:GetLevel())
				tc:RegisterEffect(e2)
				local op=0
				if Duel.CheckLocation(tp,LOCATION_PZONE,1) and (not Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.SelectOption(tp,aux.Stringid(m,3),aux.Stringid(m,4))==1) then
					op=4
				end
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
				Duel.MoveSequence(tc,op)
			else
				Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
			end
		end
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function cm.thfilter(c)
	return c:IsSetCard(0xc4) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_WYRM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.desfilter(c,tc)
	return (c:IsLocation(LOCATION_HAND) or c:IsPosition(POS_FACEUP)) and c:IsAttribute(tc:GetAttribute())
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
	if not tc then return end
	local c=e:GetHandler()
	Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
	Duel.BreakEffect()
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,tc)
	g:AddCard(c)
	Duel.Destroy(g,REASON_EFFECT)
end