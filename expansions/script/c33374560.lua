--空无一人的街道
local m=33374560
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	--spsummon limit
	--local e2=Effect.CreateEffect(c)
	--e2:SetType(EFFECT_TYPE_FIELD)
	--e2:SetRange(LOCATION_SZONE)
	--e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	--e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	--e2:SetTargetRange(1,0)
	--e2:SetTarget(cm.sumlimit)
	--c:RegisterEffect(e2)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.sumlimit)
	Duel.RegisterEffect(e1,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_DECK)
end
function cm.filter(c,e,sp)
	return c:IsCode(33374561) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local cg=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,e,tp)
	if cg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		if Duel.SelectYesNo(tp, aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=cg:Select(tp,1,1,nil):GetFirst()
			if Duel.SpecialSummon(tc, 0, tp, tp, true, false, POS_FACEUP)>0 then
				tc:CompleteProcedure()
			end
		end
	end
end
---effect2
function cm.afilter(c,tp)
	return c:IsSetCard(0x558) and c:GetPreviousControler()==tp
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.afilter,1,nil,tp)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(33374565) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		sc=g:GetFirst()
		if Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)>0 then
		   local e4=Effect.CreateEffect(c)
		   e4:SetType(EFFECT_TYPE_SINGLE)
		   e4:SetCode(EFFECT_IMMUNE_EFFECT)
		   e4:SetValue(cm.efilter)
		   e4:SetOwnerPlayer(tp)
		   e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   sc:RegisterEffect(e4)
		   sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		   local e5=Effect.CreateEffect(c)
		   e5:SetType(EFFECT_TYPE_SINGLE)
		   e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		   e5:SetValue(1)
		   e5:SetOwnerPlayer(tp)
		   e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		   sc:RegisterEffect(e5)
		   sc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
		end
	end

end
function cm.efilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
---special limit
function cm.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA) and not c:IsCode(33374565)
end