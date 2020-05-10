--D.E.M 绝望预兆
local m=33401450
local cm=_G["c"..m]
function cm.initial_effect(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c) 
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.setcon)
	e3:SetTarget(cm.settg)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
  --position change
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,4))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.poscon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(cm.postg)
	e2:SetOperation(cm.posop)
	c:RegisterEffect(e2)
end
function cm.cfilter2(c)
	return c:IsFaceup() and c:IsSetCard(0x341,0x340)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(cm.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,0,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(cm.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) then return end 
	 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cfilter2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,2,aux.ExceptThisCard(e))
	Duel.SendtoGrave(g,REASON_EFFECT)
	local ck=0
	if Duel.GetOperatedGroup():Filter(cm.cfilter1,nil):GetCount()>0 then ck=1 end 
	if Duel.IsExistingMatchingCard(cm.cfilter3,1-tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(m,1)) then
	 Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SET)
		local tg=Duel.SelectMatchingCard(1-tp,cm.cfilter3,1-tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)   
		Duel.SSet(1-tp,tg,1-tp)  
		if ck==1 then 
		  local tc=tg:GetFirst()
		 local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
		end
		if Duel.IsExistingMatchingCard(cm.cfilter4,1-tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_ATOHAND)
		 local tg1=Duel.SelectMatchingCard(1-tp,cm.cfilter4,1-tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		 Duel.SendtoHand(tg1,1-tp,REASON_EFFECT)
		end
	end
end
function cm.cfilter1(c)
	return c:IsSetCard(0xc342) and c:IsType(TYPE_MONSTER)
end
function cm.cfilter3(c)
	return c:IsCode(33401200) and c:IsSSetable()
end
function cm.cfilter4(c)
	return c:IsCode(33400037,33400222,33400320,33400413) and c:IsAbleToHand()
end

function cm.cfilter6(c,tp,eg)
	local pd=0
	local des=eg:GetFirst() 
	 while des do   
	  if	pd==0 and (c:IsReason(REASON_BATTLE) or (c:GetReasonPlayer()==1-tp and c:IsReason(REASON_EFFECT))) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) 
	  then pd=1 end
		 des=eg:GetNext()
	 end
	return  pd==1
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter6,1,nil,tp,eg)
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
  if not Duel.IsExistingMatchingCard(cm.cfilter3,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) then return end 
	 local c=e:GetHandler()
   local ck=0
	 local des=eg:GetFirst() 
	 while des do  
	 if   ck==0 and des:IsSetCard(0xc342) and des:IsType(TYPE_MONSTER) then ck=1 end 
		 des=eg:GetNext()
	 end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
   local tg=Duel.SelectMatchingCard(tp,cm.cfilter3,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)  
		Duel.SSet(tp,tg)		
		if ck==1 then 
		  local tc=tg:GetFirst()
		 local e2=Effect.CreateEffect(e:GetHandler())
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
				e2:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2)
		end
		if Duel.IsExistingMatchingCard(cm.cfilter4,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		 local tg1=Duel.SelectMatchingCard(tp,cm.cfilter4,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil)
		 Duel.SendtoHand(tg1,tp,REASON_EFFECT)
		end
end

function cm.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x341) and c:IsLevel(12) and c:IsType(TYPE_RITUAL)
end
function cm.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function cm.posfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsAbleToRemove()
end
function cm.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and cm.posfilter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter2,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(cm.posfilter2,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND+CATEGORY_SEARCH,0,1,0,0)
   if Duel.IsExistingMatchingCard(cm.cfilter,tp,0,LOCATION_MZONE,1,nil) then 
	 Duel.SetChainLimit(aux.FALSE)
	end 
end
function cm.posop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(cm.posfilter2,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.SelectYesNo(tp,aux.Stringid(m,5)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g1:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
		end
	end
   if Duel.IsExistingMatchingCard(cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,6)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g1=Duel.SelectMatchingCard(tp,cm.filter2,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoHand(g1,tp,REASON_EFFECT)
   end 
end
function cm.filter(c,e,tp)
	return c:IsSetCard(0xc343,0xa343) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.filter2(c)
	return c:IsSetCard(0xc343,0xa343)  and c:IsAbleToHand()
end

