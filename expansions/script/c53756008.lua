if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53756008
local cm=_G["c"..m]
cm.name="永远的黄昏之时"
function cm.initial_effect(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x80002,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_IMMUNE_EFFECT)
	e5:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetValue(cm.immval)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_FZONE)
	e6:SetOperation(cm.chainop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
	e7:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e7:SetTarget(cm.thtarget)
	e7:SetValue(LOCATION_HAND)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(m,1))
	e8:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCountLimit(1)
	e8:SetCode(EVENT_PHASE+PHASE_END)
	e8:SetTarget(cm.sptg)
	e8:SetOperation(cm.spop)
	c:RegisterEffect(e8)
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.immval(e,te)
	local c=e:GetHandler()
	if not c:IsLocation(LOCATION_FZONE) then return false end
	local tp=c:GetControler()
	local eset={c:IsHasEffect(m+50)}
	local res=te:GetOwner()~=e:GetOwner() and Duel.CheckReleaseGroup(REASON_EFFECT,tp,nil,1,nil)
	local ctns=false
	if not te:IsHasType(EFFECT_TYPE_ACTIONS) then
		for _,se in pairs(eset) do
			if se:GetLabelObject()==te then ctns=true end
		end
	end
	if res and not ctns then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(m+50)
		e1:SetLabelObject(te)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SET_AVAILABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_ADJUST)
		e2:SetOperation(cm.imcop)
		Duel.RegisterEffect(e2,tp)
	end
	return res
end
function cm.imcop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.SelectReleaseGroup(REASON_EFFECT,tp,nil,1,1,nil)
	Duel.Release(g,REASON_EFFECT)
	e:Reset()
end 
function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0xa530) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) then Duel.SetChainLimit(aux.FALSE) end
end
function cm.thtarget(e,c)
	return c:IsSetCard(0xa530) and c:IsType(TYPE_TRAP)
end
function cm.cfilter(c)
	return c:IsSetCard(0xa530) and c:IsFaceup()
end
function cm.thfilter(c)
	return c:IsSetCard(0xa530) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.spfilter(c,e,tp)
	return (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED)) and c:IsCode(53756001) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK) else Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED) end
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	else
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end
