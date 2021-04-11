local m=15000051
local cm=_G["c"..m]
cm.name="色带神·图尔兹查"
function cm.initial_effect(c)
	--pendulum summon  
	aux.EnablePendulumAttribute(c)
	--change Pscale
	local e1=Effect.CreateEffect(c) 
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_CHANGE_LSCALE)  
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE) 
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c15000051.cpcon)
	e1:SetValue(c15000051.p1val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()  
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	e2:SetValue(c15000051.p2val)
	c:RegisterEffect(e2)
	--when pzone
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_PZONE)  
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,15000051)
	e3:SetCondition(c15000051.spcon)
	e3:SetOperation(c15000051.spop)  
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetCode(EFFECT_SPSUMMON_PROC)  
	e4:SetProperty(EFFECT_FLAG_UNCOPYABLE)  
	e4:SetRange(LOCATION_HAND)  
	e4:SetCountLimit(1,15010051)  
	e4:SetCondition(c15000051.sd2con) 
	c:RegisterEffect(e4)
	--SpecialSummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e5:SetType(EFFECT_TYPE_IGNITION)  
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET) 
	e5:SetCode(EVENT_FREE_CHAIN)  
	e5:SetRange(LOCATION_MZONE)  
	e5:SetCountLimit(1,15020051) 
	e5:SetHintTiming(0,TIMING_MAIN_END)
	e5:SetTarget(c15000051.sp2tg)
	e5:SetOperation(c15000051.sp2op)  
	c:RegisterEffect(e5)
end
function c15000051.cpcon(e)  
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	return g:GetCount()~=0 and (g:GetFirst():GetLeftScale()~=e:GetHandler():GetLeftScale() or g:GetFirst():GetRightScale()~=e:GetHandler():GetRightScale())
end
function c15000051.p1val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x1f33) then return 4 end
	return tc:GetLeftScale()
end
function c15000051.p2val(e,tp)
	local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,e:GetHandler())
	if g:GetCount()==0 then return 4 end
	local tc=g:GetFirst()
	if not tc:GetType(TYPE_PENDULUM) then return 4 end
	if tc:IsSetCard(0x1f33) then return 4 end
	return tc:GetRightScale()
end
function c15000051.spfilter(c)
	return c:IsRace(RACE_FIEND) and c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end
function c15000051.spcon(e) 
	return Duel.IsExistingMatchingCard(c15000051.spfilter,e:GetHandlerPlayer(),LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil) and not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
function c15000051.spop(e,tp,eg,ep,ev,re,r,rp) 
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(15000051,0))
	local g=Duel.SelectMatchingCard(tp,c15000051.spfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()~=0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1)) then
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c15000051.sd2filter(c)
	return c:IsSetCard(0x1f33) and c:IsFaceup()
end
function c15000051.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c15000051.sd2con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c15000051.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return (lsc==l2sc or lsc==l2sc-1 or lsc==l2sc+1) and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 and not Duel.IsExistingMatchingCard(c15000051.sd2filter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c15000051.sp2filter(c,e,tp)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c15000051.sp2tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)  
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)  
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) end  
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c15000051.sp2filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)  
	local g=Duel.SelectTarget(tp,c15000051.sp2filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_PZONE)
end
function c15000051.sp2op(e,tp,eg,ep,ev,re,r,rp)  
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end 
	if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		if not tc:IsSetCard(0xf33) then
			local e1=Effect.CreateEffect(e:GetHandler())  
			e1:SetType(EFFECT_TYPE_SINGLE)  
			e1:SetCode(EFFECT_DISABLE)  
			e1:SetReset(RESET_EVENT+0x1fe0000)  
			tc:RegisterEffect(e1,true)  
			local e2=Effect.CreateEffect(e:GetHandler())  
			e2:SetType(EFFECT_TYPE_SINGLE)  
			e2:SetCode(EFFECT_DISABLE_EFFECT)  
			e2:SetReset(RESET_EVENT+0x1fe0000)  
			tc:RegisterEffect(e2,true)
			Duel.SpecialSummonComplete()
		else
			Duel.SpecialSummonComplete()
		end
	end
	local e3=Effect.CreateEffect(e:GetHandler())  
	e3:SetType(EFFECT_TYPE_FIELD)  
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetTargetRange(1,0)  
	e3:SetTarget(c15000051.splimit)  
	e3:SetReset(RESET_PHASE+PHASE_END)  
	Duel.RegisterEffect(e3,tp)  
end  
function c15000051.splimit(e,c)  
	return not c:IsRace(RACE_FIEND) 
end 