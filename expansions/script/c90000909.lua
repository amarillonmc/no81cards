--升上天堂的恶魔
function c90000909.initial_effect(c)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c90000909.sptg)
	e1:SetOperation(c90000909.spop)
	c:RegisterEffect(e1)
	--spsummon-self
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetCondition(c90000909.spscon)
	e2:SetTarget(c90000909.spstg)
	e2:SetOperation(c90000909.spsop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c90000909.efilter)
	c:RegisterEffect(e3)
	if not c90000909.global_check then
		c90000909.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DESTROYED)
		ge1:SetOperation(c90000909.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c90000909.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(0,90000909,RESET_PHASE+PHASE_END,0,1)
	end
end
function c90000909.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(c:GetOwner())>0
end
function c90000909.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c90000909.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c90000909.gcheck(sg)
	return sg:FilterCount(Card.IsControler,nil,0)<=Duel.GetMZoneCount(0)
		and sg:FilterCount(Card.IsControler,nil,1)<=Duel.GetMZoneCount(1)
end
function c90000909.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c90000909.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil,e,tp)
	if g:GetCount()==0 then return end
	local max=math.min(Duel.GetMZoneCount(0)+Duel.GetMZoneCount(1),6)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) and max>1 then max=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=g:SelectSubGroup(tp,c90000909.gcheck,false,1,max)
	if sg:GetCount()==0 then return end
	local fid=e:GetHandler():GetFieldID()
	for tc in aux.Next(sg) do
		Duel.SpecialSummonStep(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)
		tc:RegisterFlagEffect(90000909,RESET_EVENT+RESETS_STANDARD,0,1,fid)
	end
	Duel.SpecialSummonComplete()
	sg:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCountLimit(1)
	e1:SetLabel(fid)
	e1:SetLabelObject(sg)
	e1:SetCondition(c90000909.tgcon)
	e1:SetOperation(c90000909.tgop)
	Duel.RegisterEffect(e1,tp)
end
function c90000909.tgfilter(c,fid)
	return c:GetFlagEffectLabel(90000909)==fid
end
function c90000909.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c90000909.tgfilter,1,nil,e:GetLabel()) then
		g:DeleteGroup()
		e:Reset()
		return false
	else return true end
end
function c90000909.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local tg=g:Filter(c90000909.tgfilter,nil,e:GetLabel())
	if Duel.SendtoGrave(tg,REASON_EFFECT)==6 then
		for p in aux.TurnPlayers() do
			local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
			if 6-ct>0 then Duel.Draw(p,6-ct,REASON_EFFECT) end
		end
	end
end
function c90000909.spscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(0,90000909)>=6
end
function c90000909.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c90000909.spsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummonStep(c,0,tp,tp,true,true,POS_FACEUP) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(LOCATION_DECKBOT)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		c:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
function c90000909.efilter(e,te)
	return e:GetHandlerPlayer()~=te:GetOwnerPlayer() and te:IsActivated()
end
