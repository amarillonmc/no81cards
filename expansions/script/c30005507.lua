--混合体·奇美拉
local m=30005507
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,cm.ffilter,2,false)
	--material limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_MATERIAL_LIMIT)
	e0:SetValue(cm.matlimit)
	c:RegisterEffect(e0)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.nmcon)
	e1:SetTarget(cm.nmtg)
	e1:SetOperation(cm.nmop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON+CATEGORY_TODECK)
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1,m)
	e51:SetCondition(cm.cpcon)
	e51:SetCost(cm.cpcost)
	e51:SetTarget(cm.cptg)
	e51:SetOperation(cm.cpop)
	c:RegisterEffect(e51) 
end
--material limit
function cm.ffilter(c,fc,sub,mg,sg)
	if not sg then return true end
	return sg:IsExists(Card.IsFusionSetCard,1,nil,0x927)
end
function cm.matlimit(e,c,fc,st)
	if st~=SUMMON_TYPE_FUSION then return true end
	return c:GetOwner()==(fc:GetControler())
end
--Effect 1
function cm.nmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function cm.nf(c)
	if c:GetOriginalType()&TYPE_MONSTER==0 then return false end
	return Duel.IsExistingMatchingCard(cm.nf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function cm.nf1(c,ec)
	return c:IsFaceup() and not c:IsFusionCode(ec:GetFusionCode())
end
function cm.nmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.nf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function cm.nmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.nf,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil)
	local tc=g:GetFirst()
	local name=tc:GetCode()
	if tc then
		Duel.ConfirmCards(1-tp,tc)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
		local tcc=Duel.SelectMatchingCard(tp,cm.nf1,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc):GetFirst()
		if tcc==nil or tcc:IsFacedown() then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_ADD_FUSION_CODE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(name)
		tcc:RegisterEffect(e1)
		tcc:SetHint(CHINT_CARD,name)
	end
end
--Effect 2
function cm.cpcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if Duel.GetTurnPlayer()==e:GetHandlerPlayer() then
		return ph==PHASE_MAIN1 or ph==PHASE_MAIN2
	else
		return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
	end
end
function cm.cpfilter(c)
	return c:IsOriginalCodeRule(30005504) and c:CheckActivateEffect(true,true,false)~=nil
end
function cm.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return true end
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return  Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil)
	end
	e:SetLabel(0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ConfirmCards(1-tp,g:GetFirst())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if te then
		e:SetLabelObject(te:GetLabelObject())
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
