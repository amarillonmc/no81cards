--方舟骑士·年
c29002020.named_with_Arknight=1
function c29002020.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(29002020,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c29002020.sprcon)
	e1:SetOperation(c29002020.sprop)
	c:RegisterEffect(e1)
	--spsummon condition
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetValue(c29002020.splimit)
	c:RegisterEffect(e2) 
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29002020,1))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1)
	e3:SetTarget(c29002020.itarget)
	e3:SetOperation(c29002020.ioperation)
	c:RegisterEffect(e3)  
end 
function c29002020.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA)
end
function c29002020.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local x=Duel.GetActivityCount(tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(tp,ACTIVITY_SPSUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SUMMON)+Duel.GetActivityCount(1-tp,ACTIVITY_SPSUMMON)
	return x>=12 and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and (Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x10ae,3,REASON_COST) or (Duel.GetFlagEffect(tp,29096814)==1 and Duel.IsCanRemoveCounter(c:GetControler(),1,0,0x10ae,2,REASON_COST)))
end
function c29002020.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	if Duel.GetFlagEffect(tp,29096814)==1 then
	Duel.ResetFlagEffect(tp,29096814)
	Duel.RemoveCounter(tp,1,0,0x10ae,2,REASON_RULE)
	else
	Duel.RemoveCounter(tp,1,0,0x10ae,3,REASON_RULE)
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0) 
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c29002020.itarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
end
function c29002020.ioperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c) 
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c29002020.efilter)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetReset(RESET_PHASE+PHASE_END) 
	e2:SetOwnerPlayer(tp) 
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(29002020,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(29002020)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
end
function c29002020.efilter(e,te)
	if te:GetOwnerPlayer()==e:GetHandlerPlayer() then return false end
	if not te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return true end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	return not g or not g:IsContains(e:GetHandler())
end