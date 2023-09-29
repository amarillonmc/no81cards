local m=53760016
local cm=_G["c"..m]
cm.name="取而代之的蝴蝶"
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	aux.AddCodeList(c,53760000)
	aux.AddSetNameMonsterList(c,0x9538)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.tkfilter(c,tp)
	return c:IsFaceup() and Duel.IsPlayerCanSpecialSummonMonster(tp,53760000,0x9538,TYPES_TOKEN_MONSTER,0,3000,1,RACE_FIEND,c:GetAttribute(),POS_FACEUP_DEFENSE,1-tp) and (not (c:IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN)) or c:IsAbleToRemove())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and cm.tkfilter(chkc,tp) end
	if chk==0 then return SNNM.DressamLocCheck(1-tp,tp,0xff) and Duel.IsExistingTarget(cm.tkfilter,tp,0,LOCATION_MZONE,1,nil,tp) end
	local g=Duel.SelectTarget(tp,cm.tkfilter,tp,0,LOCATION_MZONE,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	if g:GetFirst():IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) then Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not SNNM.DressamLocCheck(1-tp,tp,0xff) or not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local attr=tc:GetAttribute()
	if Duel.IsPlayerCanSpecialSummonMonster(tp,53760000,0x9538,TYPES_TOKEN_MONSTER,0,3000,1,RACE_FIEND,attr,POS_FACEUP_DEFENSE,1-tp) then
		local token=Duel.CreateToken(tp,53760000)
		SNNM.DressamSPStep(token,tp,1-tp,POS_FACEUP_DEFENSE,0xff)
		local e0=Effect.CreateEffect(e:GetHandler())
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e0:SetValue(attr)
		token:RegisterEffect(e0,true)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetOwnerPlayer(1-tp)
		e1:SetAbsoluteRange(tp,0xff,0xff)
		e1:SetTarget(cm.tg)
		e1:SetValue(cm.fuslimit)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e2:SetValue(cm.sumlimit)
		token:RegisterEffect(e2,true)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		token:RegisterEffect(e3,true)
		local e4=e2:Clone()
		e4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		token:RegisterEffect(e4,true)
		local e5=e2:Clone()
		e5:SetCode(EFFECT_UNRELEASABLE_SUM)
		token:RegisterEffect(e5,true)
		local e6=e2:Clone()
		e6:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		token:RegisterEffect(e6,true)
		Duel.SpecialSummonComplete()
		if tc:IsType(TYPE_EFFECT) and Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_MZONE,0,1,nil,TYPE_TOKEN) then
			Duel.BreakEffect()
			Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function cm.tg(e,c)
	return c:IsType(TYPE_NORMAL) and c~=e:GetHandler()
end
function cm.fuslimit(e,c,sumtype)
	if not c then return false end
	return c:IsControler(e:GetOwnerPlayer()) and sumtype==SUMMON_TYPE_FUSION
end
function cm.sumlimit(e,c)
	if not c then return false end
	return c:IsControler(e:GetOwnerPlayer())
end
function cm.thfilter(c)
	return aux.IsSetNameMonsterListed(c,0x9538) and c:IsFaceup() and c:GetType()&0x20002==0x20002 and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,cm.thfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.tffilter(c,tp)
	return c:GetType()&0x20002==0x20002 and c:GetActivateEffect():IsActivatable(tp,true)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 and tc:IsLocation(LOCATION_HAND) then
		local g=Duel.GetMatchingGroup(cm.tffilter,tp,LOCATION_HAND,0,nil,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
			local sc=g:Select(tp,1,1,nil):GetFirst()
			Duel.MoveToField(sc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local te=sc:GetActivateEffect()
			local tep=sc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
			Duel.RaiseEvent(sc,73734821,te,0,tp,tp,Duel.GetCurrentChain())
		end
	end
end
