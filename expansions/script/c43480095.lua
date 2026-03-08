--被遗忘的研究 十六月雨煌忍
function c43480095.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,function(c) return c:IsSetCard(0x3f13) end,function(c) return c:IsSetCard(0x3f13) and (c:IsType(TYPE_PENDULUM) or not c:IsType(TYPE_TUNER)) end,1)
	c:EnableReviveLimit()
	--synchro level
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetLabel(43480095)
	c:RegisterEffect(e1) 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_LEVEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetLabelObject(c)
	e1:SetValue(c43480095.slevel)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(function(e,c) 
	return c:IsType(TYPE_PENDULUM) and c:IsSetCard(0x3f13) end)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--des 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F) 
	e1:SetCode(EVENT_SUMMON_SUCCESS) 
	e1:SetTarget(c43480095.destg) 
	e1:SetOperation(c43480095.desop) 
	c:RegisterEffect(e1) 
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--negate
	local e2=Effect.CreateEffect(c) 
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_TODECK+CATEGORY_HANDES+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e2:SetCountLimit(1,43480095)
	e2:SetTarget(c43480095.distg)
	e2:SetOperation(c43480095.disop)
	c:RegisterEffect(e2)
	--pendulum
	local e3=Effect.CreateEffect(c) 
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,43480096)
	e3:SetCondition(c43480095.pencon)
	e3:SetTarget(c43480095.pentg)
	e3:SetOperation(c43480095.penop)
	c:RegisterEffect(e3)
	--SpecialSummon 
	local e1=Effect.CreateEffect(c) 
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O) 
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,4348087) 
	e1:SetTarget(c43480095.psptg)
	e1:SetOperation(c43480095.pspop)
	c:RegisterEffect(e1)  
	local e2=e1:Clone() 
	e2:SetCode(EVENT_SPSUMMON_SUCCESS) 
	c:RegisterEffect(e2) 
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT) 
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(1) 
	c:RegisterEffect(e2)
end
function c43480095.slevel(e,c)   
	local le={c:IsHasEffect(EFFECT_SYNCHRO_LEVEL)} 
	local chk=false 
	for _,te in pairs(le) do
		if te:GetLabel()==43480095 then chk=true end 
	end
	local lv=aux.GetCappedLevel(e:GetHandler())
	if chk then  
		return (4<<16)+lv 
	else 
		return lv
	end 
end
function c43480095.desfil(c) 
	return not (c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM))  
end 
function c43480095.destg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local dg=Duel.GetMatchingGroup(c43480095.desfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return true end 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
end
function c43480095.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()  
	local p=tp 
	if Duel.IsPlayerAffectedByEffect(tp,4348050) then p=1-tp end 
	local dg=Duel.GetMatchingGroup(c43480095.desfil,p,LOCATION_MZONE,0,nil)
	if dg:GetCount()>0 then 
		Duel.Destroy(dg,REASON_EFFECT)
	end 
end
function c43480095.disfilter(c)
	return aux.NegateAnyFilter(c)
end
function c43480095.distg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c43480095.disfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c43480095.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,c43480095.disfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0) 
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1) 
end
function c43480095.tefil(c) 
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsAbleToExtra()  
end 
function c43480095.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	local tc=Duel.GetFirstTarget() 
	local hg=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,nil,REASON_EFFECT)
	if Duel.SendtoGrave(hg,REASON_EFFECT+REASON_DISCARD) and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsCanBeDisabledByEffect(e,false) then 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_DISABLE) 
		e1:SetReset(RESET_EVENT+RESETS_STANDARD) 
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		Duel.AdjustInstantly()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET) 
		if Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c43480095.tefil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(43480095,0)) then 
			Duel.BreakEffect() 
			local rg=Duel.SelectMatchingCard(tp,c43480095.tefil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil) 
			Duel.SendtoExtraP(rg,tp,REASON_EFFECT) 
		end 
	end
end
function c43480095.pencon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetEquipTarget()~=nil 
end
function c43480095.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c43480095.setfil(c) 
	return c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSSetable()  
end 
function c43480095.penop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) and Duel.IsExistingMatchingCard(c43480095.setfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then 
		Duel.BreakEffect() 
		local tc=Duel.SelectMatchingCard(tp,c43480095.setfil,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil):GetFirst() 
		Duel.SSet(tp,tc)
	end
end 
function c43480095.rlfil(c) 
	return c:IsReleasableByEffect() and c:IsFaceup() and c:IsSetCard(0x3f13) and c:IsType(TYPE_PENDULUM) 
end 
function c43480095.rlgck(g,tp) 
	return Duel.GetMZoneCount(tp,g)>0   
end  
function c43480095.psptg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local g=Duel.GetMatchingGroup(c43480095.rlfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:CheckSubGroup(c43480095.rlgck,2,2,tp) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end 
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,nil,2,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c43480095.pspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c43480095.rlfil,tp,LOCATION_MZONE,0,nil)
	if g:CheckSubGroup(c43480095.rlgck,2,2,tp) then 
		local rg=g:SelectSubGroup(tp,c43480095.rlgck,false,2,2,tp) 
		if Duel.Release(rg,REASON_EFFECT)~=0 then 
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP) 
		end 
	end
end


