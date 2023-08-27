--魔界剧团-高明投资人
local m=82209176
local cm=c82209176
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,nil,7,3,cm.ovfilter,aux.Stringid(m,4),3,cm.xyzop)
	c:EnableReviveLimit()
	--special summon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)  
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE) 
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1)  
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1)  
	--cannot be target  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)  
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)  
	e2:SetRange(LOCATION_PZONE)  
	e2:SetTargetRange(LOCATION_MZONE,0)  
	e2:SetTarget(cm.tgtg)  
	e2:SetValue(cm.tgval)  
	c:RegisterEffect(e2)  
	--pendulum  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,3))  
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e3:SetCode(EVENT_DESTROYED)  
	e3:SetProperty(EFFECT_FLAG_DELAY)  
	e3:SetCondition(cm.pencon)  
	e3:SetTarget(cm.pentg)  
	e3:SetOperation(cm.penop)  
	c:RegisterEffect(e3)  
end
cm.pendulum_level=7

--material
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec) and c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(TYPE_XYZ)
end
function cm.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,m)==0 end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end

--special summon
function cm.desfilter(c,param)
	return c:IsSetCard(0x10ec) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and ((not param) or c:GetSequence()<5)
end
function cm.spfilter(c,e,tp)  
	return c:IsSetCard(0x10ec) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return 
		Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp)
		and (cm.chk1(e,tp,eg,ep,ev,re,r,rp) or cm.chk2(e,tp,eg,ep,ev,re,r,rp)) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)  
end  
function cm.chk1(e,tp,eg,ep,ev,re,r,rp,param)
	local c=e:GetHandler()
	if param and (not c:IsRelateToEffect(e)) then return false end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
end
function cm.chk2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--splimit
	local e1=Effect.CreateEffect(e:GetHandler())  
	e1:SetType(EFFECT_TYPE_FIELD)  
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)  
	e1:SetTargetRange(1,0)  
	e1:SetTarget(cm.splimit)  
	e1:SetReset(RESET_PHASE+PHASE_END) 
	--check filter
	if not (cm.chk1(e,tp,eg,ep,ev,re,r,rp,1) or cm.chk2(e,tp,eg,ep,ev,re,r,rp)) then 
		Duel.RegisterEffect(e1,tp) 
		return 
	end
	--select effect
	local ct=0
	local suc=false
	if cm.chk1(e,tp,eg,ep,ev,re,r,rp,1) and cm.chk2(e,tp,eg,ep,ev,re,r,rp) then
		ct=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	else
		if (not cm.chk1(e,tp,eg,ep,ev,re,r,rp,1)) and cm.chk2(e,tp,eg,ep,ev,re,r,rp) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,2))
			ct=1
		else
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
		end
	end
	--handle effect
	if ct==0 then
		if c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)>0 then
			suc=true
		end
	end
	if ct==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local loc=LOCATION_ONFIELD 
		local param=nil
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then
			loc=LOCATION_MZONE
			param=1
		end
		local dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,loc,0,1,1,nil,param)
		if dg:GetCount()>0 then
			Duel.HintSelection(dg)
			if Duel.Destroy(dg,REASON_EFFECT)>0 then
				suc=true
			end
		end
	end
	if suc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)  
		if g:GetCount()>0 then  
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
		end  
	end
	Duel.RegisterEffect(e1,tp)
end  
function cm.splimit(e,c)  
	return not c:IsSetCard(0x10ec)
end

--cannot be target
function cm.tgtg(e,c)  
	return c:IsSetCard(0x10ec) 
end  
function cm.tgval(e,re,rp)  
	return rp==1-e:GetHandlerPlayer() and re:IsActiveType(TYPE_MONSTER)  
end  

--pendulum
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