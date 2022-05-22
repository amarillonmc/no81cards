--邪骨团 轮回天生
local m=64800142
local cm=_G["c"..m]
Duel.LoadScript("c64800135.lua")
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
cm.setname="Zx02"
function cm.costfilter(c,e,tp)
	return c.setname=="Zx02" and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
		and (Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK,0,1,c,c:GetCode()) or Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_MZONE,0,1,nil) )
end
function cm.filter(c,mc)
	return c.setname=="Zx02" and not c:IsCode(mc) and c:IsAbleToHand()
end
function cm.filter0(c,mc)
	return c.setname=="Zx02" and c:IsSummonLocation(LOCATION_EXTRA) and Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_DECK,0,1,c,c:GetCode())
end
function cm.filter1(c,mc)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToHand()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabel(g:GetFirst():GetOriginalCode())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil,code)
	if Duel.IsExistingMatchingCard(cm.filter0,tp,LOCATION_MZONE,0,1,nil) then
		local sg=Duel.GetMatchingGroup(cm.filter1,tp,LOCATION_DECK,0,nil)
		g:Merge(sg)
	end
	if g:GetCount()>0 then
		local gg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(gg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,gg)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(1,0)
	e2:SetValue(cm.aclimit)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_ZOMBIE)
end
