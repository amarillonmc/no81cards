--陨星石·冲击晶
local s,id,o=GetID()
function s.initial_effect(c)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCountLimit(1,12845006)
	e4:SetCondition(s.sumcon)
	e4:SetTarget(s.sumtg)
	e4:SetOperation(s.sumop)
	c:RegisterEffect(e4)
end
function s.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and c:IsLevelAbove(5) and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function s.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function s.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		--summon with no tribute
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(123709,0))
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SUMMON_PROC)
		e1:SetCondition(s.ntcon)
		c:RegisterEffect(e1)
		local res=c:IsSummonable(true,nil)
		if e1 then e1:Reset() end
	return res end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function s.setfilter(c)
	return c:IsSetCard(0xa79) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function s.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if not c:IsRelateToEffect(e) then return end
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetCondition(s.ntcon)
	c:RegisterEffect(e1)
	local sg=Duel.GetMatchingGroup(s.setfilter,tp,LOCATION_DECK,0,nil)
	if Duel.Summon(tp,c,true,nil)~=0 and #sg>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		tc:RegisterFlagEffect(12845006,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		c:RegisterFlagEffect(12845006,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		if Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)~=0 then
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(12845006,RESET_EVENT+RESETS_STANDARD,0,1)
			local ct=1
			if Duel.GetTurnPlayer()==1-tp then
				ct=2
			end
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetLabel(Duel.GetTurnCount()+ct)
			e3:SetLabelObject(tc)
			e3:SetCondition(s.descon)
			e3:SetOperation(s.desop)
			Duel.RegisterEffect(e3,tp)
		end
	end
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(12845006)~=0 then
		return Duel.GetTurnCount()==e:GetLabel()
	else
		e:Reset()
		return false
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
