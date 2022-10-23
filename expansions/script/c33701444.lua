--昂扬的大象承载着希望
local m=33701444
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e01=Effect.CreateEffect(c)
	e01:SetDescription(aux.Stringid(m,0))
	e01:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e01:SetType(EFFECT_TYPE_QUICK_O)
	e01:SetCode(EVENT_FREE_CHAIN)
	e01:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e01:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e01:SetCondition(cm.spcon)
	e01:SetTarget(cm.sptg)
	e01:SetOperation(cm.spop)
	c:RegisterEffect(e01)
	--Effect 2 
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	c:RegisterEffect(e1)
	--Effect 3 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.chainop)
	c:RegisterEffect(e3)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAIN_NEGATED)
		ge1:SetOperation(cm.regop)
		ge1:SetLabelObject(ge3)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_CHAIN_DISABLED)
		ge2:SetLabelObject(ge3)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetOperation(cm.adjustop)
		Duel.RegisterEffect(ge3,0)
	end
end
--all
function cm.f(c)
	return c:IsFaceup() and c:IsDisabled() 
		and c:GetFlagEffect(m+m)==0
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local de,sp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if de:GetHandlerPlayer()==sp then 
		Duel.RegisterFlagEffect(sp,m,RESET_PHASE+PHASE_END,0,1)
	end
end
function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.f,e:GetHandlerPlayer(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if #g>0 then
		local tc=g:GetFirst()
		while tc do
			if  tc:GetFlagEffect(m+m)==0 then
				local p=tc:GetControler()
				Duel.RegisterFlagEffect(p,m+m,RESET_PHASE+PHASE_END,0,1)
				tc:RegisterFlagEffect(m+m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
			end
			tc=g:GetNext()
		end  
	end
end
--Effect 1
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetFlagEffect(e:GetHandlerPlayer(),m)
	local ct2=Duel.GetFlagEffect(e:GetHandlerPlayer(),m+m)
	return ct1>=3 or (ct1+ct2)>=4 or ct2>=3
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(m+m)==0
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	c:RegisterFlagEffect(m+m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=c:IsRelateToEffect(e)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if not b1 or b2==0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
--Effect 2
function cm.splimit(e,c,tp,sumtp,sumpos)
	return c:IsLocation(LOCATION_EXTRA)
end
--Effect 3 
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re and rc:IsControler(e:GetHandlerPlayer()) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end


