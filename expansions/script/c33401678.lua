--狂狂帝 「狮子之弹」
local m=33401678
local cm=_G["c"..m]
function cm.initial_effect(c)
 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
  --material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(cm.mtop)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
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
	if chk==0 then return true  end
	 Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_ONFIELD)
end
function cm.tgfilter(c,g)
	return g:IsContains(c) and c:IsAbleToGrave()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,cg) then
	   Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
	if e:GetLabel()==1 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then 
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function cm.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq=c:GetSequence()
	if seq>4 then return end
	local flag=0
	if seq>0 and Duel.CheckLocation(tp,LOCATION_SZONE,seq-1) then flag=flag|(1<<(seq+7)) end
	if seq<4 and Duel.CheckLocation(tp,LOCATION_SZONE,seq+1) then flag=flag|(1<<(seq+9)) end
	if flag==0 then Duel.SendtoGrave(c,REASON_EFFECT) 
	return 
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,~flag)
	local nseq=math.log(s,2)-8
	Duel.MoveSequence(c,nseq)
	local cg=c:GetColumnGroup()
	cg:AddCard(c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,cg)
	Duel.SendtoGrave(g,REASON_EFFECT)
end