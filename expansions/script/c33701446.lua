--悠闲的河马吞噬了烦恼
local m=33701446
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e01=Effect.CreateEffect(c)
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
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_REVERSE_DAMAGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(cm.rev)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		cm[0]=0
		cm[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge3:SetOperation(cm.clear)
		Duel.RegisterEffect(ge3,0)
	end
end
--all
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==0 and (bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0 and rp~=0)) then
		cm[0]=cm[0]+ev
	elseif ep~=0 and (bit.band(r,REASON_BATTLE)~=0 or (bit.band(r,REASON_EFFECT)~=0 and rp==0)) then
		cm[1]=cm[1]+ev
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm[0]=0
	cm[1]=0
end
--Effect 1
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return  cm[e:GetHandlerPlayer()]>=4000
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
function cm.rev(e,re,r,rp,rc)
	local tp=e:GetHandlerPlayer()
	return bit.band(r,REASON_EFFECT)~=0 or bit.band(r,REASON_BATTLE)~=0
end

