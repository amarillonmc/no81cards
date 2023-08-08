--『星光歌剧』台本-摘星Revue
local m=33405003
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.thcost)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
 --lv
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.target)
	e2:SetOperation(cm.activate)
	c:RegisterEffect(e2)
end
function cm.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function cm.thfilter(c,tp)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_CONTINUOUS+TYPE_FIELD)
		and  c:GetActivateEffect():IsActivatable(tp)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,2,nil,tp)
	local tc=g:GetFirst()
	if tc then  
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b2 then
			if tc:IsType(TYPE_FIELD) then 
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
		tc=g:GetNext()
	end 
	if tc then  
		local b2=tc:GetActivateEffect():IsActivatable(tp)
		if b2 then
			if tc:IsType(TYPE_FIELD) then 
			Duel.MoveToField(tc,tp,tp,LOCATION_FZONE,POS_FACEUP,true)
			else
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			end
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
			local cost=te:GetCost()
			if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		end
	end
end

function cm.filter1(c)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.filter2(c,e,tp)
	return c:IsSetCard(0x9da0) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter3(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) or 
	 Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp)or 
	Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND,0,1,nil)
	 end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	if Duel.IsExistingMatchingCard(cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if  Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	 if  Duel.IsExistingMatchingCard(cm.filter3,tp,LOCATION_HAND,0,1,nil) then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	if opval[op]==1 then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	   local g1=Duel.SelectMatchingCard(tp,cm.filter1,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
		Duel.SendtoHand(g1,nil,REASON_EFFECT)
	elseif opval[op]==2 then
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	   local g2=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		  Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	elseif opval[op]==3 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.filter3,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
		if tc then
			local s1=tc:IsSummonable(true,nil,1)
			local s2=tc:IsMSetable(true,nil,1)
				if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
					Duel.Summon(tp,tc,true,nil,1)
				else
					Duel.MSet(tp,tc,true,nil,1)
				end
		 end
	end
end
