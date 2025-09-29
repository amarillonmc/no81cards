--云璃-掷山破云-
Duel.LoadScript("c60010000.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	MTC.AvatarCreate(c,m+1,LOCATION_MZONE)
	--tohand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RELEASE+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.spcon1)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
	
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(cm.immcon)
	e3:SetTarget(cm.immdtg)
	e3:SetValue(cm.immval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ADJUST)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(cm.desop)
	c:RegisterEffect(e5)
end

function cm.immcon(e)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)~=0
end
function cm.immdtg(e,c)
	return c:IsFaceup() and c:GetCounter(0x62a)~=0
end
function cm.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer() and te:IsActivated()
end

function cm.immval(e,te_or_c)
	local res=aux.GetValueType(te_or_c)~="Effect" or (te_or_c:IsActivated() and te_or_c:GetOwner()~=e:GetHandler())
	if res then
		if aux.GetValueType(te_or_c)=="Effect" then Duel.Hint(HINT_CARD,0,m) end
		local c=e:GetHandler()
		Duel.RegisterFlagEffect(tp,m+40000000,0,0,1)
	end
	return res
end

function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,m+40000000)~=0 and Duel.GetFieldGroupCount(tp,LOCATION_SZONE,0)~=0 then
		Duel.ResetFlagEffect(tp,m+40000000)
		Duel.Hint(HINT_CARD,0,m) 
		local g=Duel.GetFieldGroup(tp,LOCATION_SZONE,0)
		Duel.Destroy(g,REASON_EFFECT)
	end
end

function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,m)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	if chk==0 then return rg:CheckSubGroup(aux.mzctcheckrel,3,3,tp,REASON_EFFECT) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetReleaseGroup(tp,false,REASON_SPSUMMON)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=rg:SelectSubGroup(tp,aux.mzctcheckrel,true,3,3,tp,REASON_EFFECT)
	local num=0
	for tc in aux.Next(sg) do
		if tc:GetCounter(0x62a)~=0 then num=num+tc:GetCounter(0x62a) end
	end
	if Duel.Release(sg,REASON_EFFECT) then
		Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		if sg:GetCount()==0 and Duel.Release(sg,REASON_EFFECT)~=0 then
			e:GetHandler():AddCounter(0x62a,num)
		end
	end
end








