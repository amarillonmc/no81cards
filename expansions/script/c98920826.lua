--迷宫城的陷阱姬
function c98920826.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920826,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,98920826)
	e1:SetCondition(c98920826.spcon)
	e1:SetTarget(c98920826.sptg)
	e1:SetOperation(c98920826.spop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)	
	e4:SetCondition(c98920826.spcon1)
	c:RegisterEffect(e4)
	--cannot be target/effect indestructable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920826.dcon)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetValue(aux.indoval)
	c:RegisterEffect(e3)
	--remove
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e14:SetCode(EVENT_ATTACK_ANNOUNCE)
	e14:SetRange(LOCATION_MZONE)
	e14:SetTarget(c98920826.cptarget)
	e14:SetOperation(c98920826.cpoperation)
	c:RegisterEffect(e14)
	local e15=e14:Clone()
	e15:SetType(EFFECT_TYPE_QUICK_O)
	e15:SetCode(EVENT_CHAINING)	
	e15:SetCondition(c98920826.descon)
	c:RegisterEffect(e15)
end
function c98920826.cfilter(c,tp)
	return c:GetType()==TYPE_TRAP and c:IsControler(tp)
end
function c98920826.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920826.cfilter,1,nil,tp)
end
function c98920826.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c98920826.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_INACTIVATE)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetReset(RESET_PHASE+PHASE_END)
		e2:SetValue(c98920826.efilter)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_DISEFFECT)
		Duel.RegisterEffect(e3,tp)
		Duel.BreakEffect()
end
function c98920826.dcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
function c98920826.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetCurrentChain()
	if ct<2 then return false end
	local te,p=Duel.GetChainInfo(ct-1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	if not te then return false end
	local b1=te:GetHandler():IsSetCard(0x17e) and not te:GetHandler():IsCode(id)
	return b1 and p==tp and rp==1-tp
end
function c98920826.efilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp,loc=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER,CHAININFO_TRIGGERING_LOCATION)
	return p==tp and te:GetHandler():IsSetCard(0x17e)
end
function c98920826.cpfilter(c)
	return c:GetType()==TYPE_TRAP and c:IsSetCard(0x17e) and c:CheckActivateEffect(false,true,false)~=nil
end
function c98920826.cptarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	local loc1,loc2=LOCATION_GRAVE,0
	if chk==0 then return Duel.IsExistingTarget(c98920826.cpfilter,tp,loc1,loc2,1,nil) end
	e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c98920826.cpfilter,tp,loc1,loc2,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	e:SetProperty(te:GetProperty())
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function c98920826.cpoperation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local tc=te:GetHandler()
	if not (tc:IsRelateToEffect(e) and tc:GetType()==TYPE_TRAP) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function c98920826.descon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end