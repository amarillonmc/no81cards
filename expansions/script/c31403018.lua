local m=31403018
local cm=_G["c"..m]
cm.name="本我追想"
cm._GetRitualLevel=Card.GetRitualLevel
function Card.GetRitualLevel(c,rc)
	if c:GetLevel()>0 then return cm._GetRitualLevel(c,rc) end
	local e=c:IsHasEffect(EFFECT_RITUAL_LEVEL)
	if e then return e:GetValue()(e,rc) end
	return 0
end
cm._IsCanBeRitualMaterial=Card.IsCanBeRitualMaterial
function Card.IsCanBeRitualMaterial(c,rc)
	local e=c:IsHasEffect(EFFECT_RITUAL_LEVEL)
	if e and e:GetLabel()==m and e:GetValue()(e,rc)~=nil then return true end
	return cm._IsCanBeRitualMaterial(c,rc)
end
cm._GetRitualMaterial=Duel.GetRitualMaterial
function cm.grmfilter(c)
	local e=c:IsHasEffect(EFFECT_RITUAL_LEVEL)
	if not (e and e:GetLabel()==m) then return false end
	local con1=c:IsLocation(LOCATION_MZONE)
	local con2=c:IsHasEffect(EFFECT_EXTRA_RITUAL_MATERIAL)
	return con1 or con2
end
function Duel.GetRitualMaterial(tp)
	local g=cm._GetRitualMaterial(tp)
	local exg=Duel.GetMatchingGroup(cm.grmfilter,tp,LOCATION_GRAVE+LOCATION_MZONE,0,nil)
	g:Merge(exg)
	return g
end
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_PENDULUM),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1,31403101)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(cm.athcost)
	e2:SetTarget(cm.athtg)
	e2:SetOperation(cm.athop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_RITUAL_LEVEL)
	e3:SetValue(cm.rlevel)
	e3:SetLabel(m)
	c:RegisterEffect(e3)
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.thfilter(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and not c:IsType(TYPE_PENDULUM)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if not tc then return end
	if Duel.SendtoHand(tc,nil,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(1-tp,tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetTarget(cm.aclimit)
		e1:SetLabel(tc:GetCode())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
function cm.aclimit(e,re,tp)
	return re:GetHandler():IsCode(e:GetLabel()) and re:IsActiveType(TYPE_MONSTER)
end
function cm.athcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	return true
end
function cm.cfilter(c)
	return c:IsSetCard(0xc311) and c:IsType(TYPE_MONSTER) and c:IsAbleToGraveAsCost()
end
function cm.athfilter(c,cg)
	local lv=cg:Filter(aux.TRUE,c):GetClassCount(Card.GetAttribute)
	return c:IsSetCard(0xc311) and c:IsAbleToHand() and c:IsLevelBelow(lv) 
end
function cm.cgfilter(g,cg,lv)
	return cg:Filter(aux.TRUE,g):FilterCount(Card.IsLevel,nil,lv)>0
end
function cm.athtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		local cg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
		return cg:GetCount()>0 and Duel.IsExistingMatchingCard(cm.athfilter,tp,LOCATION_DECK,0,1,nil,cg)
	end
	local cg=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
	local tg=Duel.GetMatchingGroup(cm.athfilter,tp,LOCATION_DECK,0,nil,cg)
	local lvt={}
	local tc=tg:GetFirst()
	while tc do
		local tlv=0
		tlv=tlv+tc:GetLevel()
		lvt[tlv]=tlv
		tc=tg:GetNext()
	end
	local pc=1
	for i=1,12 do
		if lvt[i] then lvt[i]=nil lvt[pc]=i pc=pc+1 end
	end
	lvt[pc]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local lv=Duel.AnnounceNumber(tp,table.unpack(lvt))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	aux.GCheckAdditional=aux.dabcheck
	local rg=cg:SelectSubGroup(tp,cm.cgfilter,false,lv,lv,cg,lv)
	aux.GCheckAdditional=nil
	Duel.SendtoGrave(rg,REASON_COST)
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function cm.athfilter2(c,lv)
	return c:IsSetCard(0xc311) and c:IsLevel(lv) and c:IsAbleToHand()
end
function cm.athop(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	local g=Duel.SelectMatchingCard(tp,cm.athfilter2,tp,LOCATION_DECK,0,1,1,nil,lv)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function cm.rlevel(e,c)
	if not c:IsType(TYPE_EFFECT) then
		local clv=c:GetLevel()
		return clv
	else return nil end
end