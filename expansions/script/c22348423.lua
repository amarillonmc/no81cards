--恐 龙 摔 跤 手 ·军 体 拳 甲 龙 
local m=22348423
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c22348423.matfilter,1,1)
	--sset
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c22348423.sttg)
	e1:SetOperation(c22348423.stop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetTarget(c22348423.sttg1)
	e2:SetOperation(c22348423.stop1)
	c:RegisterEffect(e2)
	--sps
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCondition(c22348423.spcon)
	e3:SetTarget(c22348423.sptg)
	e3:SetOperation(c22348423.spop)
	c:RegisterEffect(e3)
	--chain attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22348423,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22348423.cacon)
	e4:SetOperation(c22348423.caop)
	c:RegisterEffect(e4)
	
end
function c22348423.matfilter(c)
	return c:IsLevelAbove(1) and c:IsSetCard(0x11a)
end
function c22348423.stfilter1(c)
	return c:IsFaceup(1) and c:IsAttackAbove(1)
end
function c22348423.sttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348423.stfilter,tp,LOCATION_DECK,0,1,nil,tp) and not Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,90173539) end
end
function c22348423.sttg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348423.stfilter,tp,LOCATION_DECK,0,1,nil,tp) and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_ONFIELD,0,1,nil,90173539) and Duel.IsExistingMatchingCard(c22348423.stfilter1,tp,0,LOCATION_MZONE,1,nil) end
end
function c22348423.stfilter(c,tp)
	return c:IsCode(90173539) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c22348423.stop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22348423.stfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c22348423.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
		end
	end
end
function c22348423.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11a)
end
function c22348423.stop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c22348423.stfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c22348423.stfilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if fc then
				Duel.SendtoGrave(fc,REASON_RULE)
				Duel.BreakEffect()
			end
			local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
			if Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)~=0 and tg:GetCount()>0 then
					Duel.BreakEffect()
				local ttg=tg:GetMaxGroup(Card.GetAttack)
				local tttg=Duel.GetMatchingGroup(c22348423.atkfilter,tp,LOCATION_MZONE,0,nil)
				local ttc=tttg:GetFirst()
				while ttc do
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					e1:SetValue(math.floor(ttg:GetFirst():GetAttack()/2))
					ttc:RegisterEffect(e1)
					ttc=tttg:GetNext()
				end
			end
		end
	end
end
function c22348423.spcfilter(c,tp,rp)
	return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp) and bit.band(c:GetPreviousTypeOnField(),TYPE_MONSTER)~=0
		and c:IsPreviousSetCard(0x11a) and (c:IsReason(REASON_BATTLE) or (rp==1-tp and c:IsReason(REASON_EFFECT)))
end
function c22348423.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c22348423.spcfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
function c22348423.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetFlagEffect(tp,22348423)==0 end
	Duel.RegisterFlagEffect(tp,22348423,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348423.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c22348423.cacon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if a:IsStatus(STATUS_OPPO_BATTLE) and d:IsControler(tp) then a,d=d,a end
	if a:IsSetCard(0x11a)
		and not a:IsStatus(STATUS_BATTLE_DESTROYED) and d:IsStatus(STATUS_BATTLE_DESTROYED) then
		e:SetLabelObject(a)
		return true
	else return false end
end
function c22348423.caop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToBattle() then
			Duel.ChainAttack()
	end
end
