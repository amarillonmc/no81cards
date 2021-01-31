--D.A.L 出击
local m=33401204
local cm=_G["c"..m]
function cm.initial_effect(c)
	   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
 --atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(cm.target)
	e2:SetValue(cm.atkval)
	c:RegisterEffect(e2)
 --to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH+CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCost(cm.cost1)
	e3:SetTarget(cm.target1)
	e3:SetOperation(cm.activate1)
	c:RegisterEffect(e3)
end
function cm.target(e,c)
	return c:IsSetCard(0x341)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) and c:GetAttribute()~=0
end
function cm.atkval(e,c)
	local g=Duel.GetMatchingGroup(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local att=0
	local tc=g:GetFirst()
	while tc do
		att=bit.bor(att,tc:GetAttribute())
		tc=g:GetNext()
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return ct*400
end

function cm.costfilter1(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function cm.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter1,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter1,tp,LOCATION_HAND,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.spfilter1(c,e,tp)
	return  c:IsSetCard(0x341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.spfilter1,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function cm.activate1(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if ct>2 then ct=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.spfilter1,tp,LOCATION_HAND,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
	local sp=Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		if sp==2 then 
		 local tg=Duel.GetOperatedGroup()
		 local tc=tg:GetFirst()
		 local tc2=tg:GetNext()
		 if tc:GetAttribute()~=tc2:GetAttribute() and Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil)  and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local g2=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
			if g2:GetCount()>0 then
				Duel.SendtoHand(g2,nil,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,g2)
			end
		 end
		end 
	end
end
function cm.cckfilter(c,at)
	return   c:IsFaceup() and c:GetAttribute()&at~=0
end
function cm.thfilter1(c)
	return c:IsSetCard(0x341) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand() and not Duel.IsExistingMatchingCard(cm.cckfilter,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute()) 
end