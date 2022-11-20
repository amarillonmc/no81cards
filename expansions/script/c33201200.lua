--蚀刻圣骑重启
local s,id,o=GetID()
VHisc_Paladin=VHisc_Paladin or {}
function s.initial_effect(c)
	VHisc_Paladin.dthef(c,id)
	VHisc_Paladin.addcheck(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCountLimit(1,id+10000)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--act in hand
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e4:SetCondition(s.handcon)
	c:RegisterEffect(e4) 
end
s.VHisc_RustyPaladin=true

function s.ft(c)
	return c:IsPublic() and c.VHisc_RustyPaladin 
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.ft,tp,LOCATION_HAND,0,1,nil,e,tp) end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.ft,tp,LOCATION_HAND,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,s.ft,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		local code=tc:GetCode()
		local ccode=_G["c"..code]
		Duel.ShuffleHand(tp)
		Duel.BreakEffect()
		ccode.efspop(e,tc,tp)
	end
end

function s.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_SZONE,0)==0
end
---------------Functions and Filters--------------------


-----------this is a global destory check------------------
function VHisc_Paladin.addcheck(c)
	if not VHisc_Paladin.global_check then
		VHisc_Paladin.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(VHisc_Paladin.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetCondition(VHisc_Paladin.regcon)
		ge2:SetOperation(VHisc_Paladin.regop)
		Duel.RegisterEffect(ge2,0)
	end
end
----------------------functions------------------------------

function VHisc_Paladin.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_GRAVE+LOCATION_REMOVED) then
			tc:RegisterFlagEffect(33201200,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
		elseif tc:IsLocation(LOCATION_EXTRA) then
			tc:RegisterFlagEffect(33201200,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function VHisc_Paladin.spcfilter(c,tp)
	return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c.VHisc_RustyPaladin
		and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function VHisc_Paladin.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(VHisc_Paladin.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(VHisc_Paladin.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function VHisc_Paladin.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+33201200,re,r,rp,ep,e:GetLabel())
end

--Register destory_to_hand effect
function VHisc_Paladin.dthef(ce,cid)
	local e2=Effect.CreateEffect(ce)
	e2:SetDescription(aux.Stringid(33201200,1))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_CUSTOM+33201200)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,cid+10000)
	e2:SetCondition(VHisc_Paladin.dthcon)
	e2:SetTarget(VHisc_Paladin.dthtg)
	e2:SetOperation(VHisc_Paladin.dthop)
	ce:RegisterEffect(e2)
end
function VHisc_Paladin.dthcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL and not eg:IsContains(e:GetHandler())
end
function VHisc_Paladin.dthtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() and not eg:IsContains(e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function VHisc_Paladin.dthop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end

-----------------------global check end---------------------------------

--Register delay effect
function VHisc_Paladin.delayef(ce,cid,time,efcate)
	local e1=Effect.CreateEffect(ce)
	e1:SetDescription(aux.Stringid(33201200,0))
	e1:SetCategory(0x200+efcate)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetLabel(cid,time)
	e1:SetCountLimit(1,cid)
	e1:SetCondition(VHisc_Paladin.dycon)
	e1:SetTarget(VHisc_Paladin.dytg)
	e1:SetOperation(VHisc_Paladin.dyop)
	ce:RegisterEffect(e1)
end
function VHisc_Paladin.dycon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp and not e:GetHandler():IsPublic()
end
function VHisc_Paladin.dytg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function VHisc_Paladin.dyop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid,time=e:GetLabel()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EVENT_CHAINING)
	e2:SetLabel(cid,time)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e2:SetOperation(VHisc_Paladin.efckop)
	c:RegisterEffect(e2)
end
function VHisc_Paladin.efckop(e,tp,eg,ep,ev,re,r,rp)
	local cid,time=e:GetLabel()
	local c=e:GetHandler()
	local cs=_G["c"..cid]
	if c:IsPublic() then c:RegisterFlagEffect(cid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,fid,66) end
	if c:GetFlagEffect(cid)>=time then
		Duel.Hint(HINT_CARD,tp,cid)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
			Duel.BreakEffect()
			cs.efspop(e,c,tp) 
		end
		e:Reset()
	end
end

--Register atk down effect
function VHisc_Paladin.atkdef(ce)
	local e2=Effect.CreateEffect(ce)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(VHisc_Paladin.atkdcon)
	e2:SetTarget(VHisc_Paladin.atkdtg)
	e2:SetOperation(VHisc_Paladin.atkdop)
	ce:RegisterEffect(e2)
end
function VHisc_Paladin.atkdcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(function(c,tp) return c:IsControler(1-tp) end,1,nil,tp)
end
function VHisc_Paladin.atkdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsFaceup() and not e:GetHandler():IsAttack(0) end
end
function VHisc_Paladin.atkdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsFaceup() and c:IsRelateToEffect(e) and not c:IsAttack(0) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-500)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetValue(-500)
	c:RegisterEffect(e2)
	if c:IsAttack(0) then Duel.Destroy(c,REASON_EFFECT) end
end