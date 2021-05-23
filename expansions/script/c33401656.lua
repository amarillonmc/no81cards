--白之女王 量产者
local m=33401656
local cm=_G["c"..m]
function cm.initial_effect(c)
	 c:EnableCounterPermit(0x34f)
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x6340))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
--sp
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetCode(cm.con1)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.thtg2)
	e3:SetOperation(cm.thop2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.con2)
	c:RegisterEffect(e4)
end
function cm.lcheck(g)
	return g:IsExists(Card.IsLinkSetCard,1,nil,0x9344)
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsPlayerAffectedByEffect(tp,33401655)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp) 
	return  Duel.IsPlayerAffectedByEffect(tp,33401655)
end
function cm.refilter(c)
	return ((c:IsType(TYPE_EFFECT) and c:IsDisabled()) or c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN)) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) or  Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil)  end
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_MZONE,0,1,nil) 
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
	  local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_MZONE,0,1,1,nil)
	  Duel.Release(g,REASON_COST)
	  e:SetLabel(1)
	else
	  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	  Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	end   
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0x3341) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
   if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.thfilter2(c)
	return c:IsSetCard(0x9344) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK) then
	 local lvt={} 
	 for i=1,2 do
		 if Duel.GetLocationCount(tp,LOCATION_MZONE)>=i then
		 lvt[i]=i
		 end
	 end
	 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
		for i=1,sc1 do
			local token=Duel.CreateToken(tp,33401660)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)				
		end
		Duel.SpecialSummonComplete()
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_FIELD)
		 e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		 e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		 e1:SetTargetRange(1,0)
		 e1:SetTarget(cm.splimit)
		 e1:SetReset(RESET_PHASE+PHASE_END)
		 Duel.RegisterEffect(e1,tp)
	end
	 if e:GetLabel()==1 and Duel.IsExistingMatchingCard(cm.thfilter2,tp,LOCATION_GRAVE,0,1,nil)and Duel.SelectYesNo(tp,aux.Stringid(m,3))
	then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g2=Duel.SelectMatchingCard(tp,cm.thfilter2,tp,LOCATION_GRAVE,0,1,1,nil)
		if #g2>0 then
		Duel.SendtoHand(g2,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g2)  
		end
	end 
end
function cm.splimit(e,c)
	return not c:IsSetCard(0x9344) and c:IsLocation(LOCATION_EXTRA)
end