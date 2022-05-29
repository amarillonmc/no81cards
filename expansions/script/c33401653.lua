--白之女王 「死刑执行人」
local m=33401653
local cm=_G["c"..m]
function cm.initial_effect(c)
	   c:EnableCounterPermit(0x34f)
	  --counter
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_COUNTER)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(cm.addct)
	e3:SetOperation(cm.addc)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	 --search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con1)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.thtg2)
	e1:SetOperation(cm.thop2)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(cm.con2)
	c:RegisterEffect(e2)
 --search
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCountLimit(1,m+10000)
	e5:SetCondition(cm.con1)
	e5:SetCost(cm.cost2)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCondition(cm.con2)
	c:RegisterEffect(e6)
end
function cm.addct(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,2,0,0x34f)
end
function cm.addc(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		e:GetHandler():AddCounter(0x34f,2)
	end
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
   return not Duel.IsPlayerAffectedByEffect(tp,33401655)
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp) 
	return  Duel.IsPlayerAffectedByEffect(tp,33401655)
end
function cm.refilter1(c)
	return ((c:IsType(TYPE_EFFECT) and c:IsDisabled()) or c:IsType(TYPE_NORMAL) or c:IsType(TYPE_TOKEN)) and c:IsReleasable()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST) or  Duel.IsExistingMatchingCard(cm.refilter1,tp,LOCATION_MZONE,0,1,nil)  end
	local b1=Duel.IsCanRemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	local b2=Duel.IsExistingMatchingCard(cm.refilter1,tp,LOCATION_MZONE,0,1,nil) 
	if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(m,2))) then
	  local g=Duel.SelectMatchingCard(tp,cm.refilter1,tp,LOCATION_MZONE,0,1,1,nil)
	  Duel.Release(g,REASON_COST)
	  e:SetLabel(1)
	else
	  Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	  Duel.RemoveCounter(tp,1,0,0x34f,2,REASON_COST)
	end   
end
function cm.thtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local sg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function cm.thop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then return end 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g2>0 then
	Duel.HintSelection(g2)
	 if Duel.Destroy(g2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,0,1,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
		local tg=Duel.SelectMatchingCard(tp,aux.disfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
		local tc=tg:GetFirst()
		Duel.NegateRelatedChain(tc,RESET_TURN_SET)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	 end
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)and Duel.SelectYesNo(tp,aux.Stringid(m,1))
	then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g2>0 then
		Duel.HintSelection(g2)
		Duel.Destroy(g2,REASON_EFFECT)
		end
	end 
end

function cm.refilter(c,tp,re)
	local flag=true
	local value={Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_RELEASE)}
	if #value>0 then
		for k,re in ipairs(value) do
			local val=re:GetTarget()
			if val and val(re,c,tp) then
				flag=false
			end
		end 
	end
	return  c:IsReleasable() or (c:IsType(TYPE_SPELL+TYPE_TRAP)  and flag)
end
function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,nil,tp) and e:GetHandler():IsAbleToRemoveAsCost()  end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,nil,tp)
	if g:GetCount()>0  then  
		local ck=0 
		local tc=g:GetFirst()
		Duel.Release(tc,REASON_COST)
	end
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if chk==0 then return ft1>0 and ft2>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,1-tp)
		and not Duel.IsPlayerAffectedByEffect(tp,59822133) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if ft1<=0 or ft2<=0 or Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,tp)
		and Duel.IsPlayerCanSpecialSummonMonster(tp,33401660,0x341,0x4011,1500,1500,4,RACE_FAIRY,ATTRIBUTE_DARK,POS_FACEUP,1-tp) then
		local token=Duel.CreateToken(tp,33401660)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local token=Duel.CreateToken(tp,33401660)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end