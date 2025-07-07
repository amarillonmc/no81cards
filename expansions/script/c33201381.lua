--墨染山河 敦煌飞天壁画
VHisc_MRSH=VHisc_MRSH or {}

-------------------Register Release effect------------------

--------------------------set token--------------------------
function VHisc_MRSH.ptoken(ec,cid,tid)
	local e0=Effect.CreateEffect(ec)
	e0:SetCategory(CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,cid)
	e0:SetLabel(cid,tid)
	e0:SetCondition(VHisc_MRSH.con)
	e0:SetOperation(VHisc_MRSH.gop)
	ec:RegisterEffect(e0)   
end
function VHisc_MRSH.mtoken(ec,cid,tid)
	local e0=Effect.CreateEffect(ec)
	e0:SetCategory(CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_QUICK_O)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetRange(LOCATION_MZONE)
	e0:SetHintTiming(0,TIMING_END_PHASE)
	e0:SetCountLimit(1,cid)
	e0:SetLabel(cid,tid)
	e0:SetTarget(VHisc_MRSH.tg)
	e0:SetOperation(VHisc_MRSH.gop)
	ec:RegisterEffect(e0)   
end
function VHisc_MRSH.sptoken(ec,cid,tid)
	local e0=Effect.CreateEffect(ec)
	e0:SetCategory(CATEGORY_TOKEN)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e0:SetCode(EVENT_SUMMON_SUCCESS)
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e0:SetCountLimit(1,cid)
	e0:SetLabel(cid,tid)
	e0:SetTarget(VHisc_MRSH.tg)
	e0:SetOperation(VHisc_MRSH.gop)
	ec:RegisterEffect(e0)   
	local e10=e0:Clone()
	e10:SetCode(EVENT_SPSUMMON_SUCCESS)
	ec:RegisterEffect(e10)
end

function VHisc_MRSH.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
end
function VHisc_MRSH.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 
end 
function VHisc_MRSH.gop(e,tp,eg,ep,ev,re,r,rp)
	local cid,tid=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local c=e:GetHandler()
	local token=Duel.CreateToken(tp,tid)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e1:SetValue(TYPE_CONTINUOUS+TYPE_SPELL)
	token:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetLabel(cid,tid)
	e2:SetOperation(VHisc_MRSH.desop)
	token:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_MOVE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(VHisc_MRSH.checkcon)
	e3:SetOperation(VHisc_MRSH.checkop)
	e3:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	token:RegisterEffect(e3)
	Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
end
function VHisc_MRSH.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_DESTROY) then
		local cid,tid=e:GetLabel()
		local cs=_G["c"..cid]
		Duel.Hint(HINT_CARD,tp,tid)
		cs.top(c,e)
	end
	e:Reset()
end

--move check
function VHisc_MRSH.ckfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsLocation(LOCATION_SZONE) and c:IsSetCard(0x9327) 
end
function VHisc_MRSH.checkcon(e,tp,eg,ep,ev,re,r,rp)
	if c==nil then return true end
	return not eg:IsContains(e:GetHandler()) and eg:Filter(VHisc_MRSH.ckfilter,nil):GetCount()>0
end
function VHisc_MRSH.checkop(e,tp,eg,ep,ev,re,r,rp,c)
	local fg=eg:Filter(VHisc_MRSH.ckfilter,e:GetHandler())
	if fg:GetCount()>0 then
		fg:AddCard(e:GetHandler())
		Duel.Destroy(fg,REASON_EFFECT)
	end
end

-----------------------destory special summon---------------------
function VHisc_MRSH.dsp(ec,cid)
	local e1=Effect.CreateEffect(ec)
	e1:SetDescription(aux.Stringid(cid,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CUSTOM+33201381)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,cid+10000)
	e1:SetCondition(VHisc_MRSH.spcon)
	e1:SetTarget(VHisc_MRSH.sptg)
	e1:SetOperation(VHisc_MRSH.spop)
	ec:RegisterEffect(e1)
	if not VHisc_MRSH.global_check then
		VHisc_MRSH.global_check=true
		local ge1=Effect.CreateEffect(ec)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetCondition(VHisc_MRSH.regcon)
		ge1:SetOperation(VHisc_MRSH.regop)
		Duel.RegisterEffect(ge1,0)
	end
end

function VHisc_MRSH.spcfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function VHisc_MRSH.regcon(e,tp,eg,ep,ev,re,r,rp)
	local v=0
	if eg:IsExists(VHisc_MRSH.spcfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(VHisc_MRSH.spcfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function VHisc_MRSH.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+33201381,re,r,rp,ep,e:GetLabel())
end
function VHisc_MRSH.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ev==tp or ev==PLAYER_ALL
end
function VHisc_MRSH.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function VHisc_MRSH.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

-------------------------card effect------------------------------
local m=33201381
local cm=_G["c"..m]
if not cm then return end
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	VHisc_MRSH.ptoken(c,m,33201341)   
	VHisc_MRSH.dsp(c,m)   
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,m+20000)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.operation)
	c:RegisterEffect(e2)
end
cm.VHisc_MRSH=true
cm.VHisc_CNTreasure=true

function cm.filter(c,e,tp)
	return c.VHisc_MRSH and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and cm.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.filter,tp,LOCATION_PZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_PZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function cm.top(c)
	Duel.Hint(HINT_CARD,c:GetPreviousControler(),m-40)
	Duel.Draw(c:GetPreviousControler(),1,REASON_EFFECT)
end
