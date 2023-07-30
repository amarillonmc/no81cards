--特制药·金疮药
local m=11631011
local cm=_G["c"..m]
--strings
cm.tezhiyao=true 
function cm.isYaojishi(card)  
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.yaojishi
end
function cm.isZhiyaoshu(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.zhiyaoshu
end
function cm.isTezhiyao(card)
	local code=card:GetCode()
	local ccode=_G["c"..code]
	return ccode.tezhiyao
end



function cm.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	--register
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetCode(EFFECT_ACTIVATE_COST)  
	e2:SetRange(LOCATION_HAND)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)  
	e2:SetTargetRange(1,0)  
	e2:SetTarget(cm.actarget)  
	e2:SetCost(aux.TRUE)  
	e2:SetOperation(cm.costop)  
	c:RegisterEffect(e2)  
end 

--activate
function cm.cfilter(c)
	return cm.isYaojishi(c) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local loc=0
	local p=tp
	if c:IsLocation(LOCATION_HAND) and c:IsPublic() and e:IsHasType(EFFECT_TYPE_ACTIVATE) then loc=LOCATION_GRAVE end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,loc,1,nil,e,tp) end
	if e:IsHasType(EFFECT_TYPE_ACTIVATE) and c:GetFlagEffect(m)>0 then
		e:SetLabel(114514)
		p=PLAYER_ALL 
		c:ResetFlagEffect(m)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,p,LOCATION_GRAVE+LOCATION_HAND) 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)<=0 then return end
	local loc=0
	if e:GetLabel()==114514 then loc=LOCATION_GRAVE end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_HAND+LOCATION_GRAVE,loc,1,1,nil,e,tp)
	if g:GetCount()<0 then return end
	local tc=g:GetFirst()
	if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
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
	end
end

--register
function cm.actarget(e,te,tp)  
	local tc=te:GetHandler()
	return tc==e:GetHandler() and tc:IsLocation(LOCATION_HAND) and tc:IsPublic()
end  
function cm.costop(e,tp,eg,ep,ev,re,r,rp) 
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,0,1) 
end  
