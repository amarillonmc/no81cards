--森罗万象 创造之力
local m=33403513
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
	XY.REZS(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
  --Activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(cm.con)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.cptg)
	e2:SetOperation(cm.cpop)
	c:RegisterEffect(e2)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
  local ss=Duel.GetTurnCount()
	return Duel.GetFlagEffect(tp,33413501)<ss and  Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
e:SetLabel(m)
 if chk==0 then return true end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end
function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not se:GetHandler():IsSetCard(0x5349)and  not c:IsCode(33403500)
end

function cm.thfilter1(c)
	return c:IsCode(33403500) and c:IsType(TYPE_MONSTER) and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tgfilter(c)
	return c:IsSetCard(0x5349) and c:IsAbleToGraveAsCost()
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return true end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter1,tp,LOCATION_DECK,0,1,nil)  end
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(m,1))
	then 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
		if Duel.SendtoGrave(g,REASON_COST)~=0 then 
		 Duel.SetChainLimit(aux.FALSE)
		end
	end
	if e:GetLabel()==m then 
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1+t2
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
	e:SetLabel(2)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end

function cm.cpfilter(c)
	return  not c:IsCode(m) and  (c:IsSetCard(0x5349) or Duel.GetFlagEffect(tp,33403501)>13) and c:IsType(TYPE_SPELL+TYPE_TRAP)  and c:IsAbleToDeck()
		and c:CheckActivateEffect(false,true,false)~=nil 
end
function cm.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	if e:GetLabel()==m then 
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1+t2
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
	e:SetLabel(2)
	end
end
function cm.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	if not te:GetHandler():IsRelateToEffect(e) then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
	Duel.BreakEffect()
	Duel.SendtoDeck(te:GetHandler(),nil,2,REASON_EFFECT) 
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
end



