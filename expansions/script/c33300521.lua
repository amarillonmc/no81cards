--诞地领主 史莱姆王
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddFusionProcCodeFun(c,33300520,s.mfilter,1,true,true)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,3))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(s.sptg2)
	e2:SetOperation(s.spop2)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetOperation(s.zcop1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetOperation(s.zcop2)
	c:RegisterEffect(e4)
end
function s.mfilter(c)
	return c:IsRace(RACE_WARRIOR) and c:IsFusionSetCard(0x569)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local flag=0
	for i=0,4 do
		if not Duel.IsExistingMatchingCard(s.ftfilter,tp,LOCATION_ONFIELD,0,1,c,i) then
			flag=flag|(1<<(i))
		end
	end
	if chk==0 then return flag&0x1f~=0 end
end
function s.ftfilter(c,i)
	return c:GetSequence()<5 and c:GetSequence()==i
end
function s.setfilter(c,tp)
	return c:IsControler(1-tp) and c:IsLocation(LOCATION_MZONE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local flag=0
	for i=0,4 do
		if not Duel.IsExistingMatchingCard(s.ftfilter,tp,LOCATION_ONFIELD,0,1,c,i) then
			flag=flag|(1<<(i))
		end
	end
	if flag&0x1f~=0 then
		if Duel.MoveToField(c,tp,c:GetOwner(),LOCATION_SZONE,POS_FACEUP,true,flag) then
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			c:RegisterEffect(e1)
			local zone=1<<c:GetSequence()
			if c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone) and 
				Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP,zone)~=0 then
				local g=c:GetColumnGroup():Filter(s.setfilter,nil,tp)
				if g:GetCount()>0 then
					local tc=nil
					if g:GetCount()>1 then
						tc=g:Select(tp,1,1,nil):GetFirst()
					else
						tc=g:GetFirst()
					end
					local zone=1<<tc:GetSequence()
					local oc=Duel.GetMatchingGroup(s.seqfilter,tp,0,LOCATION_SZONE,nil,tc:GetSequence()):GetFirst()
					if oc then
						Duel.Destroy(oc,REASON_RULE)
					end
					if Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true,zone) then
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetCode(EFFECT_CHANGE_TYPE)
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
						e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
						tc:RegisterEffect(e1)
					end
				end
			end
		end
	end
end
function s.seqfilter(c,seq)
	return c:GetSequence()==seq
end
function s.spfilter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x569) and c:IsRace(RACE_AQUA)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.zcop1(e,tp,eg,ep,ev,re,r,rp)
	if not re or re:GetHandler()~=e:GetHandler() then
		Duel.Hint(24,0,aux.Stringid(id,1))
	end
end
function s.zcop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(id,2))
end