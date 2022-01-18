--守护天使 急诊天马
local m=40009101
local cm=_G["c"..m]
cm.named_with_ProtectorSpirit=1
function cm.initial_effect(c)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.sumcon1)
	e2:SetTarget(cm.sumtg1)
	e2:SetOperation(cm.sumop1)
	c:RegisterEffect(e2)  
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.sumcon2)
	e1:SetTarget(cm.sumtg2)
	e1:SetOperation(cm.sumop2)
	c:RegisterEffect(e1) 
	--summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCost(aux.bfgcost)
	e3:SetTarget(cm.sumtg)
	e3:SetOperation(cm.sumop)
	c:RegisterEffect(e3)	  
end
function cm.ProtectorSpirit(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ProtectorSpirit
end
function cm.sumcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())<=10000 or Duel.GetLP(1-tp)<=10000
end
function cm.sumfilter1(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonable(true,nil)
end
function cm.sumtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.sumcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(e:GetHandlerPlayer())>=10000 or Duel.GetLP(1-tp)>=10000
end
function cm.sumfilter2(c)
	return ((c:IsRace(RACE_FAIRY) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE)) or (cm.ProtectorSpirit(c) and c:IsLocation(LOCATION_DECK))) and c:IsSummonable(true,nil)
end
function cm.sumtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter2,tp,LOCATION_HAND+LOCATION_MZONE+LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end
function cm.sumfilter(c)
	return c:IsRace(RACE_FAIRY) and c:IsSummonable(true,nil)
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.Summon(tp,tc,true,nil)
	end
end 