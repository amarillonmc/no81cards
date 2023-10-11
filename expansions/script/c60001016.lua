--岚术机 索伦
local cm,m,o=GetID()
function cm.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c,true)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.sptg2)
	e1:SetOperation(cm.spop2)
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
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
	
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m+10000000)
	e2:SetTarget(cm.reptg)
	e2:SetValue(cm.repval)
	e2:SetOperation(cm.repop)
	c:RegisterEffect(e2)
	
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
function cm.spfilter(c,e,tp)
	return c:IsSetCard(0x624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_DECK,0,1,nil,m-1) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_HAND,0))
	if not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_HAND,0,1,nil,m-1) then
		local ac=Duel.SelectMatchingCard(tp,Card.IsCode,tp,LOCATION_DECK,0,1,1,nil,m-1):GetFirst()
		if Duel.SendtoHand(ac,tp,REASON_EFFECT)~=0 then
			local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND+LOCATION_ONFIELD,0,2,2,nil)
			Duel.Destroy(dg,REASON_EFFECT)
		end
	end
end
function cm.repfilter(c,tp)
	return c:IsFaceup() 
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(cm.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function cm.repval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end