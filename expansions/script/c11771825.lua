--凌霄戍卫 威龙
local s,id=GetID()
function s.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_UNSUMMONABLE_CARD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(s.splimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCountLimit(1,id+1)
	e3:SetTarget(s.postg)
	e3:SetOperation(s.posop)
	c:RegisterEffect(e3)
	--add counter
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_COUNTER)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(2,id+2)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
function s.splimit(e,se,sp,st)
	return se and se:IsActiveType(TYPE_MONSTER) and se:GetHandler():IsRace(RACE_WARRIOR)
end
function s.cfilter(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.cfilter2(c,tp)
	return c:IsReason(REASON_EFFECT) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsReasonPlayer(1-tp) 
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.cfilter2,1,nil,tp)
end

function s.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return sg and #sg>0 end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,sg,#sg,0,0)
end
function s.posop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if #sg>0 then
		Duel.ChangePosition(sg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x16c1,1) end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x16c1,1):GetFirst()
	if tc and tc:AddCounter(0x16c1,1) then
		local c=e:GetHandler()
		--
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,3))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(id)
		e1:SetLabelObject(tc)
		tc:RegisterEffect(e1) 
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_LEAVE_FIELD)
		e2:SetLabelObject(e1)
		e2:SetOperation(s.reset)
		Duel.RegisterEffect(e2,tp)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BE_PRE_MATERIAL)
		e3:SetLabelObject(e2)
		e3:SetCondition(s.effcon)
		e3:SetOperation(s.effop)
		tc:RegisterEffect(e3)
		local fid=c:GetFieldID()
		tc:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e4:SetCode(EVENT_PHASE+PHASE_END)
		e4:SetCountLimit(1)
		e4:SetLabel(fid)
		e4:SetLabelObject(e3)
		e4:SetCondition(s.descon2)
		e4:SetOperation(s.desop2)
		Duel.RegisterEffect(e4,tp)
	end
end

function s.cfilter2(c,tc)
	return tc:IsHasEffect(id) and tc==c and not tc:IsReason(REASON_MATERIAL)
end
function s.reset(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	local tc=e1:GetLabelObject()
	if e1 and tc and eg:IsExists(s.cfilter2,1,nil,tc) then
		e1:Reset()
		e:Reset()
	end
end


function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e2=e:GetLabelObject()
	local e1=e2:GetLabelObject()
	return (r&(REASON_FUSION|REASON_SYNCHRO|REASON_XYZ|REASON_LINK|REASON_RITUAL))>0
		and c:IsPreviousLocation(LOCATION_ONFIELD) and e1
end
function s.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e2=e:GetLabelObject()
	local e1=e2:GetLabelObject()
	--
	local e3=Effect.CreateEffect(rc)
	e3:SetDescription(aux.Stringid(id,3))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	rc:RegisterEffect(e3)
	if not rc:IsType(TYPE_EFFECT) then
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_ADD_TYPE)
		e4:SetValue(TYPE_EFFECT)
		e4:SetReset(RESET_EVENT|RESETS_STANDARD)
		rc:RegisterEffect(e4,true)
	end
	e:Reset()
	if e2 then e2:Reset() end
	if e1 then e1:Reset() end
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end

function s.descon2(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	if not e3 then  
		e:Reset()
		return false
	end
	local e2=e3:GetLabelObject()
	if not e2 then  
		e3:Reset()
		e:Reset()
		return false
	end
	local e1=e2:GetLabelObject()
	if not e1 then  
		e3:Reset()
		e2:Reset()
		e:Reset()
		return false
	end
	local tc=e1:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(id)==e:GetLabel() then
		return true
	else
		e3:Reset()
		e2:Reset()
		e1:Reset()
		e:Reset()
		return false
	end
end
function s.desop2(e,tp,eg,ep,ev,re,r,rp)
	local e3=e:GetLabelObject()
	local e2=e3:GetLabelObject()
	local e1=e2:GetLabelObject()
	local tc=e1:GetLabelObject()
	Duel.Destroy(tc,REASON_EFFECT)
	e3:Reset()
	e2:Reset()
	e1:Reset()
	e:Reset()
end
