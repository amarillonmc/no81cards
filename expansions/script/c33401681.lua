--狂狂帝 「双子之剑」
local m=33401681
local cm=_G["c"..m]
function cm.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9344)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
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
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return  Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function cm.tgfilter(c,g)
	return c:IsFaceup() and g:IsContains(c) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	 if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK) then
		local lvt={} 
		local ss=2
		if e:GetLabel()==1 then ss=4 end
		local sps=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ss>sps then ss=sps end 
		for i=1,ss do 
		lvt[i]=i
		end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local sc1=Duel.AnnounceNumber(tp,table.unpack(lvt))
		for i=1,sc1 do
			local token=Duel.CreateToken(tp,33401660)
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)			 
		end
		Duel.SpecialSummonComplete()	 
	end
  local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_FIELD)
		 e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		 e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		 e1:SetTargetRange(1,0)
		 e1:SetTarget(cm.splimit)
		 e1:SetReset(RESET_PHASE+PHASE_END)
		 Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c)
	return not (c:IsSetCard(0x341) or c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN))
end