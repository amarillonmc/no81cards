local m=15000231
local cm=_G["c"..m]
cm.name="龙辉巧-少宰η"
function cm.initial_effect(c)
	--synchro material
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,nil,1)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(cm.valcheck)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(cm.splimit)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.hspcon)
	e2:SetOperation(cm.hspop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.mattg)
	e3:SetOperation(cm.matop)
	c:RegisterEffect(e3)
	e0:SetLabelObject(e3)
	--immune
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.econ)
	e4:SetValue(cm.efilter)
	c:RegisterEffect(e4)
	--SearchCard and Destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(cm.srcost)
	e5:SetTarget(cm.srtg)
	e5:SetOperation(cm.srop)
	c:RegisterEffect(e5)
end
function cm.lvfilter(c,rc)
	return c:GetLevel()>0
end
function cm.valcheck(e,c)
	local mg=c:GetMaterial()
	local fg=mg:Filter(cm.lvfilter,nil,c)
	if #fg>0 and fg:GetSum(Card.GetLevel,c)<=2 then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or aux.synlimit(e,se,sp,st)
end
function cm.m1filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function cm.relfilter(c,tp,mg)
	if not (c:IsAttackAbove(1) and c:IsRace(RACE_MACHINE) and c:IsType(TYPE_MONSTER) and c:IsReleasable()) then return false end
	return mg:CheckSubGroup(cm.fselect,2,99,tp,c)
end
function cm.fselect(g,tp,mc)
	local mg=g:Clone()
	if Duel.GetMZoneCount(tp,mg)>0 then
		Duel.SetSelectedCard(g)
		return g:CheckWithSumGreater(Card.GetAttack,4000) and g:IsContains(mc) and g:GetCount()>=2
	else return false end
end
function cm.f2select(g,tp,mc)
	g:AddCard(mc)
	local mg=g:Clone()
	if Duel.GetMZoneCount(tp,mg)>0 then
		Duel.SetSelectedCard(g)
		return g:CheckWithSumGreater(Card.GetAttack,4000) and g:IsContains(mc) and g:GetCount()>=2
	else return false end
end
function cm.hspcon(e,c)
	if c==nil then return true end
	local mg=Duel.GetMatchingGroup(cm.m1filter,c:GetControler(),LOCATION_MZONE,0,nil)
	return Duel.IsExistingMatchingCard(cm.relfilter,c:GetControler(),LOCATION_MZONE,0,1,nil,c:GetControler(),mg)
end
function cm.hspop(e,tp,eg,ep,ev,re,r,rp,c)
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.m1filter,c:GetControler(),LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local tc1=Duel.SelectMatchingCard(tp,cm.relfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,mg):GetFirst()
	mg:RemoveCard(tc1)
	local g=mg:SelectSubGroup(tp,cm.f2select,false,1,99,tp,tc1)
	g:AddCard(tc1)
	c:SetMaterial(g)
	Duel.Release(g,REASON_COST)
end
function cm.mattg(e,tp,eg,ep,ev,re,r,chk)
	if chk==0 then
		if e:GetLabel()~=1 then return false end
		e:SetLabel(0)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
	end
end
function cm.matop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(15000231,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(15000231,2))
end
function cm.econ(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(15000231)>0
end
function cm.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function cm.srcfilter(c)
	return c:IsSetCard(0x154) and c:IsAbleToRemoveAsCost()
end
function cm.srcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srcfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.srcfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.srfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function cm.srtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.srfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.srop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.srfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,g)
		if g:IsExists(Card.IsSetCard,1,nil,0x154) and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local ag=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
			if #ag>0 then
				Duel.HintSelection(ag)
				Duel.Destroy(ag,REASON_EFFECT)
			end
		end  
	end
end