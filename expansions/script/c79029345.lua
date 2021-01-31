--雷姆必拓·狙击干员-四月
function c79029345.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c79029345.ffilter,2,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCountLimit(1,79029345+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c79029345.spcon)
	e1:SetValue(c79029345.spval)
	e1:SetOperation(c79029345.sprop)
	c:RegisterEffect(e1) 
	--attack cost
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_ATTACK_COST)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetCost(c79029345.atcost)
	e2:SetOperation(c79029345.atop)
	c:RegisterEffect(e2)
	--accumulate
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(0x10000000+79029345)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(0,1)
	c:RegisterEffect(e3) 
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,09029345)
	e2:SetCondition(c79029345.tocon)
	e2:SetTarget(c79029345.totg)
	e2:SetOperation(c79029345.toop)
	c:RegisterEffect(e2)   
	--skip
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c79029345.skcon)
	e2:SetCost(c79029345.skcost)
	e2:SetOperation(c79029345.skop)
	c:RegisterEffect(e2)
end
function c79029345.ffilter(c)
	return c:IsFusionSetCard(0xa906)
end
function c79029345.atcost(e,c,tp)
	local ct=Duel.GetFlagEffect(tp,79029345)
	return Duel.CheckLPCost(tp,ct*1000)
end
function c79029345.atop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("诶诶？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029345,3))
	Duel.Hint(HINT_CARD,0,79029345)
	Duel.PayLPCost(tp,1000)
end
function c79029345.chkfil(c)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_LINK)
end
function c79029345.rlfil(c,tp,zone)
	return c:IsReleasable() and not c:IsType(TYPE_LINK) and Duel.GetMZoneCount(tp,c,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c79029345.checkzone(tp)
	local zone=0
	local g=Duel.GetMatchingGroup(c79029345.chkfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	for tc in aux.Next(g) do
		zone=bit.bor(zone,tc:GetLinkedZone(tp))
	end
	return bit.band(zone,0x1f)
end
function c79029345.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=c79029345.checkzone(tp)
	return Duel.IsExistingMatchingCard(c79029345.rlfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tp,zone)
end
function c79029345.spval(e,c)
	local tp=c:GetControler()
	local zone=c79029345.checkzone(tp)
	return 1,zone
end
function c79029345.sprop(e,tp,eg,ep,ev,re,r,rp)
	local zone=c79029345.checkzone(tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,c79029345.rlfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tp,zone)
	e:GetHandler():SetMaterial(rg)
	Duel.Release(rg,REASON_COST+REASON_MATERIAL)
	Debug.Message("视野不错~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029345,0))
end
function c79029345.tocon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) or e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
end
function c79029345.filter(c,tp)
	return c:IsSetCard(0xa900) and c:CheckUniqueOnField(tp) and not c:IsForbidden()
end
function c79029345.totg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c79029345.filter,tp,LOCATION_EXTRA,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_EXTRA)
end
function c79029345.toop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectMatchingCard(tp,c79029345.filter,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c) then return end
	Debug.Message("戴上耳机，开始行动吧~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029345,1))
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(c79029345.eqlimit)
		tc:RegisterEffect(e1)
		local atk=tc:GetTextAttack()
		if atk>0 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_EQUIP)
			e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(atk)
			tc:RegisterEffect(e2)
		end
	end
end
function c79029345.eqlimit(e,c)
	return e:GetOwner()==c
end
function c79029345.skcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c79029345.skcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c79029345.skop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("我已经锁定你们了~")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029345,2))
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetCode(EFFECT_SKIP_DP)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end














