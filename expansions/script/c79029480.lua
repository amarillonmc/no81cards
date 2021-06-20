--龙门·近卫干员-陈·赤霄·绝影
function c79029480.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,99,c79029480.lcheck)
	c:EnableReviveLimit() 
	--code
	aux.EnableChangeCode(c,79029025,LOCATION_MZONE+LOCATION_GRAVE)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.linklimit)
	c:RegisterEffect(e1)	
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,79029480)
	e2:SetCost(c79029480.discost)
	e2:SetTarget(c79029480.distg)
	e2:SetOperation(c79029480.disop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_REMOVE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,19029480)
	e3:SetCost(c79029480.spcost)
	e3:SetTarget(c79029480.sptg)
	e3:SetOperation(c79029480.spop)
	c:RegisterEffect(e3)
end
function c79029480.lcheck(g,lc)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0xa900)
end
function c79029480.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1500) end
	Duel.PayLPCost(tp,1500)
end
function c79029480.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.disfilter1,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c79029480.disop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("放下你的武器！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029480,0))   
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.disfilter1,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
function c79029480.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	if Duel.Remove(c,POS_FACEUP,REASON_COST+REASON_TEMPORARY)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetLabelObject(c)
		e1:SetCountLimit(1)
		e1:SetOperation(c79029480.retop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c79029480.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ReturnToField(e:GetLabelObject())
end
function c79029480.spfil(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsSetCard(0xa900) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c79029480.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c79029480.spfil,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=eg:Filter(c79029480.spfil,nil,e,tp):GetCount() and (eg:Filter(c79029480.spfil,nil,e,tp):GetCount()==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,eg:Filter(c79029480.spfil,nil,e,tp):GetCount(),tp,LOCATION_REMOVED)
end
function c79029480.spop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg:Filter(c79029480.spfil,nil,e,tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<sg:GetCount() or (sg:GetCount()>1 and Duel.IsPlayerAffectedByEffect(tp,59822133)) then return end
	if Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)~=0 then	
	if sg:IsExists(Card.IsCode,1,nil,79029359) then 
	Debug.Message("这里是阿米娅。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029480,2))   
	Debug.Message("这里是陈。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029480,3))	   
	else
	Debug.Message("准备好了吗？那么，一切按照计划进行。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029480,1))   
	end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end 
	end
end





















