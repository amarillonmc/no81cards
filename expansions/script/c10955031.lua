--土御门元春
local s,id,o=GetID()
s.MoJin=true
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcMix(c,true,true,s.ffilter1,s.ffilter2)
	--special summon to your field
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--special summon to opponent's field
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,2))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SPSUM_PARAM)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetTargetRange(POS_FACEUP,1)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e0:SetCondition(s.spcon2)
	e0:SetTarget(s.sptg2)
	e0:SetOperation(s.spop2)
	c:RegisterEffect(e0)
	--on summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(s.destg)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
	--negate effects
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(s.negop)
	c:RegisterEffect(e3)

	--damage and recover
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
end
function s.cfilter(c,tp)
	return c:IsFaceup() and c.MoJin and c:IsSetCard(0x23c)
		and c:IsReleasable() and Duel.GetMZoneCount(tp,c)>0
end
function s.cfilter2(c,tp)
	return c:IsFaceup() and c.MoJin and c:IsSetCard(0x23c)
		and c:IsReleasable() and Duel.GetMZoneCount(1-tp,c,tp)>0
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 
		and Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local g=nil
	local rg=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil,tp)
	if #rg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,1,1,nil)
	end
	if not g then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
end

function s.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil,tp)
end
function s.sptg2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=nil
	local rg=Duel.GetMatchingGroup(s.cfilter2,tp,LOCATION_MZONE,0,nil,tp)
	if #rg>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		g=rg:Select(tp,1,1,nil)
	end
	if not g then return false end
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.Release(g,REASON_COST)
	g:DeleteGroup()
	c:SetStatus(STATUS_SPSUMMON_TURN,true)
end

function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(0,1)
		e1:SetCode(EFFECT_SKIP_DP)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_DRAW)
		e1:SetCountLimit(1)
		e1:SetOperation(s.checkop)
		Duel.RegisterEffect(e1,tp)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp then return end
	local hg=eg:Filter(Card.IsLocation,nil,LOCATION_HAND)
	if #hg==0 then return end
	Duel.ConfirmCards(1-tp,hg)
	local tc=hg:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) and not tc.MoJin and not tc:IsSetCard(0x23c) then
			Duel.Destroy(tc,REASON_EFFECT)
			e:Reset()
			break
		end
		tc=hg:GetNext()
	end
	Duel.ShuffleHand(tp)
end
function s.distg(e,c)
	return c:GetColumnGroup():IsContains(e:GetHandler()) and not c:IsImmuneToEffect(e)
			and not e:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	if rp~=tp then return end
	local rc=re:GetHandler()
	if rc:IsSetCard(0x23c) then
		Duel.Recover(tp,200,REASON_EFFECT)
	else
		Duel.Damage(tp,400,REASON_EFFECT)
	end
end
function s.ffilter1(c,fc,sumtype,tp)
	return (c:IsSetCard(0x23c))and c:IsType(TYPE_MONSTER)
end
function s.ffilter2(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER) and c.MoJin
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rc:GetColumnGroup():IsContains(c) and not e:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
	 and not rc:IsImmuneToEffect(e) then
		Duel.NegateEffect(ev)
	end
end

--aux.Stringid(id,0)对应"本卡特殊召唤成功"
--aux.Stringid(id,1)对应"特殊召唤到自己场上"
--aux.Stringid(id,2)对应"特殊召唤到对方场上"
