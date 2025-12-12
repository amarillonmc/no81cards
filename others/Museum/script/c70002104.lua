--电子界最终神 第三方舟新奇点
local m=70002104
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:SetSPSummonOnce(m)
	c:SetUniqueOnField(1,0,m)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),5)
	c:EnableReviveLimit()
	--spsummon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--immnue
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.indtg)
	e2:SetValue(cm.efilter)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	Duel.RegisterEffect(e3,tp)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.sptg2)
	e4:SetOperation(cm.spop2)
	c:RegisterEffect(e4)
	--yinka
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e5:SetTarget(cm.acttg)
	e5:SetOperation(cm.actop)
	c:RegisterEffect(e5)
	--Destroy
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,3))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e6:SetTarget(cm.destg)
	e6:SetOperation(cm.desop)
	c:RegisterEffect(e6)
end
	function cm.spcfilter(c)
	return c:IsFaceup() and c:IsLink(6) and c:IsAbleToGraveAsCost() and c:IsRace(RACE_CYBERSE) and Duel.GetLocationCountFromEx(tp,tp,mg,c)>0 and not c:IsCode(code)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local sg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil)
	return sg:CheckSubGroup(aux.mzctcheck,2,2,tp)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local sg=Duel.GetMatchingGroup(cm.spcfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=sg:SelectSubGroup(tp,aux.mzctcheck,true,2,2,tp)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_COST)
	g:DeleteGroup()
end
	function cm.indtg(e,c)
	return c:IsCode(m)
end
	function cm.efilter(e,re)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer()
end
	function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_CYBERSE) and c:IsLocation(LOCATION_GRAVE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
	function cm.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
	function cm.actop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CODE)
	getmetatable(e:GetHandler()).announce_filter={RACE_CYBERSE,OPCODE_ISRACE,code,OPCODE_ISCODE,OPCODE_NOT,OPCODE_AND}
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	local tc=Duel.CreateToken(tp,ac) 
	Duel.SendtoHand(tc,nil,2,REASON_EFFECT)
	Debug.Message("Revive on BigBang")
	Duel.ConfirmCards(1-tp,tc)
	Debug.Message("Go to next singularity")
end
	function cm.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc~=c end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_RULE)>0
		and c:IsRelateToEffect(e) and c:IsFaceup() then
		local upval=tc:GetBaseAttack()
		if tc:GetBaseAttack()<tc:GetBaseDefense() then
			upval=tc:GetBaseDefense()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(upval/2)
		c:RegisterEffect(e1)
	end
end