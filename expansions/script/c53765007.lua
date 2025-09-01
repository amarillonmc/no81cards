if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local m=53765007
local cm=_G["c"..m]
cm.name="枷狱前大检察官 正义"
cm.Snnm_Ef_Rst=true
cm.AD_Ht=true
function cm.initial_effect(c)
	SNNM.AllEffectReset(c)
	local e1,_,_,_=SNNM.ActivatedAsSpellorTrap(c,0x20004,LOCATION_HAND)
	e1:SetDescription(aux.Stringid(m,0))
	SNNM.HelltakerActivate(c,m)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,3))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.negcon)
	e2:SetTarget(cm.negtg)
	e2:SetOperation(cm.negop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,4))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(cm.mvtg)
	e3:SetOperation(cm.mvop)
	c:RegisterEffect(e3)
	SNNM.ActivatedAsSpellorTrapCheck(c)
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_GRAVE) and c:IsType(TYPE_MONSTER)
end
function cm.negcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:GetActivateLocation()==LOCATION_GRAVE then return true end
	local ex4,g4,gc4,dp4,dv4=Duel.GetOperationInfo(ev,CATEGORY_SPECIAL_SUMMON)
	return ex4 and (dv4&LOCATION_GRAVE==LOCATION_GRAVE or g4 and g4:IsExists(cm.cfilter,1,nil))
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(m+50) or 0
	if chk==0 then return aux.nbcon(tp,re) and c:GetFlagEffect(m)<ct end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
	if re:GetActivateLocation()==LOCATION_GRAVE then
		e:SetCategory(e:GetCategory()|CATEGORY_GRAVE_ACTION)
	else
		e:SetCategory(e:GetCategory()&~CATEGORY_GRAVE_ACTION)
	end
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function cm.mvfilter(c)
	local loc,seq=c:GetLocation(),c:GetSequence()
	if seq>3 then return false end
	for i=4,seq+1,-1 do
		if c:IsLocation(LOCATION_PZONE) and i~=4 then return false end
		if Duel.CheckLocation(c:GetControler(),loc,i) then return true end
	end
	return false
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.mvfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,5))
	local tc=Duel.SelectMatchingCard(tp,cm.mvfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil):GetFirst()
	if not tc then return end
	local loc,seq=tc:GetLocation(),tc:GetSequence()
	for i=4,seq+1,-1 do
		if Duel.CheckLocation(tc:GetControler(),loc,i) then
			Duel.MoveSequence(tc,i)
			break
		end
	end
end
