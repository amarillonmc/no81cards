--泡 沫 之 神 -沫 那 美
local m=130006045
local cm=_G["c"..m]
function cm.initial_effect(c)
	--fusion summon
	aux.AddFusionProcFunRep(c,c130006045.ffilter,2,true)
	c:EnableReviveLimit()
	aux.AddCodeList(c,130006046)
	--act limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c130006045.limcon)
	e1:SetOperation(c130006045.limop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHAIN_END)
	e2:SetOperation(c130006045.limop2)
	c:RegisterEffect(e2)
	--bt
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c130006045.bttg)
	e3:SetOperation(c130006045.btop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c130006045.btcon)
	e4:SetTarget(c130006045.bttg)
	e4:SetOperation(c130006045.btop)
	c:RegisterEffect(e4)
	--spsummon from szone
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1)
	e5:SetHintTiming(0,TIMING_MAIN_END)
	e5:SetCondition(c130006045.spcon)
	e5:SetCost(c130006045.spcost)
	e5:SetTarget(c130006045.sptg)
	e5:SetOperation(c130006045.spop)
	c:RegisterEffect(e5)
	
end

function c130006045.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetType()==TYPE_TRAP+TYPE_CONTINUOUS
end
function c130006045.costfilter(c,tp)
	return aux.IsCodeListed(c,130006046) and Duel.GetMZoneCount(tp,c)>0
end
function c130006045.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c130006045.costfilter,1,nil,tp) end
	local sg=Duel.SelectReleaseGroup(tp,c130006045.costfilter,1,1,nil,tp)
	Duel.Release(sg,REASON_COST)
end
function c130006045.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c130006045.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end


function c130006045.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetSequence()<5
end
function c130006045.mmfilter(c)
	local seq=c:GetSequence()
	return seq<=4
end
function c130006045.btcon(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c130006045.bttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c130006045.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetMatchingGroup(c130006045.stfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SendtoHand(sg,nil,REASON_RULE)
	local tg=Duel.GetMatchingGroup(c130006045.mmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc and not tc:IsImmuneToEffect(e) do
	local zone=1<<tc:GetSequence()
	local ttp=tc:GetControler()
	if tc:IsImmuneToEffect(e) and Duel.MoveToField(tc,tp,ttp,LOCATION_SZONE,POS_FACEUP,true,zone) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
	tc=tg:GetNext()
	local tgg=Duel.GetMatchingGroup(c130006045.mmfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SendtoHand(tgg,nil,REASON_RULE)
	end
end
function c130006045.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionAttribute(ATTRIBUTE_WATER) and (not sg or not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c130006045.limfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsType(TYPE_FUSION)
end
function c130006045.limcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c130006045.limfilter,1,nil,tp)
end
function c130006045.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then
		Duel.SetChainLimitTillChainEnd(c130006045.chainlm)
	elseif Duel.GetCurrentChain()==1 then
		e:GetHandler():RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetOperation(c130006045.resetop)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BREAK_EFFECT)
		e2:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e2,tp)
	end
end
function c130006045.resetop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(id)
	e:Reset()
end
function c130006045.limop2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(id)~=0 then
		Duel.SetChainLimitTillChainEnd(c130006045.chainlm)
	end
	e:GetHandler():ResetFlagEffect(id)
end
function c130006045.chainlm(e,rp,tp)
	return tp==rp
end