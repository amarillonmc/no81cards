   --森罗万象 万物流转
local m=33403501
local cm=_G["c"..m]
Duel.LoadScript("c33400000.lua")
function cm.initial_effect(c)
   XY.REZS(c)
   --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
 --draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCost(cm.cost2)
	e2:SetTarget(cm.drtg)
	e2:SetOperation(cm.drop)
	c:RegisterEffect(e2)
  --act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e3:SetCondition(cm.handcon)
	c:RegisterEffect(e3)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33413501)<(Duel.GetFlagEffect(tp,33403501)/2+1)and Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)  
	e:SetLabel(1)
 if chk==0 then return true  end
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
	return not se:GetHandler():IsSetCard(0x5349) and  not c:IsCode(33403500)
end
function cm.cpfilter(c)
	return  not c:IsCode(33403501) and  c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToGraveAsCost() 
		and c:CheckActivateEffect(false,true,false)~=nil 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg and tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	Duel.SendtoGrave(g,REASON_COST)
	if e:GetLabel()==1 then 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop2)
	e2:SetReset(RESET_EVENT+RESET_CHAIN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)   --t2
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)   --duel 1
	e:SetLabel(2)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0x5349) and rp==tp
end
function cm.regop2(e,tp,eg,ep,ev,re,r,rp)
	local n1=Duel.GetFlagEffect(tp,33413501)
	local n2=Duel.GetFlagEffect(tp,33403501)
	local n3=Duel.GetFlagEffect(tp,m+20000)
	Duel.ResetFlagEffect(tp,33413501)
	Duel.ResetFlagEffect(tp,33403501)
	Duel.ResetFlagEffect(tp,m+20000) 
	if n1>=2 then 
		for i=1,n1-1 do
		Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1)
		end 
	end
	if n2>=2 then 
		for i=1,n2-1 do
		 Duel.RegisterFlagEffect(tp,33403501,0,0,0)
		end 
	end 
	if n3>=2 then 
		for i=1,n3-1 do
		  Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1)
		end 
	end 
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)
	local te=e:GetLabelObject()
	if not te then return false end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end   
end

function cm.cost2(e,tp,eg,ep,ev,re,r,rp,chk)  
if chk==0 then return  Duel.GetFlagEffect(tp,33443500)==0
		and aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,0) end
   local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp) 
	aux.bfgcost(e,tp,eg,ep,ev,re,r,rp,1)
end
function cm.drfilter(c,e)
	return c:IsSetCard(0x5349) and c:IsAbleToDeck() 
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local g=Duel.GetMatchingGroup(cm.drfilter,tp,LOCATION_REMOVED,0,e:GetHandler())
	local n=g:GetCount()
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and n>=5 and Duel.GetFlagEffect(tp,m+10000)==0  end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,5,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.RegisterFlagEffect(tp,m+30000,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)
	local c=e:GetHandler()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_NEGATED)
	e2:SetCondition(cm.regcon)
	e2:SetOperation(cm.regop3)
	e2:SetReset(RESET_EVENT+RESET_CHAIN+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function cm.regop3(e,tp,eg,ep,ev,re,r,rp)
	local n1=Duel.GetFlagEffect(tp,33403501)
	local n3=Duel.GetFlagEffect(tp,m+30000)
	Duel.ResetFlagEffect(tp,33403501)
	Duel.ResetFlagEffect(tp,m+30000)
	if n1>=2 then
		for i=1,n1-1 do
		Duel.RegisterFlagEffect(tp,33403501,RESET_PHASE+PHASE_END,0,1)
		end 
	end 
	if n3>=2 then 
		for i=1,n3-1 do
		  Duel.RegisterFlagEffect(tp,m+30000,RESET_PHASE+PHASE_END,0,1)
		end
	end 
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.drfilter,tp,LOCATION_REMOVED,0,5,5,nil,e)
	Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp) 
	Duel.BreakEffect()
	Duel.Draw(tp,2,REASON_EFFECT)
end

function cm.filter(c)
	return c:IsFaceup() and c:IsCode(33403500)
end
function cm.handcon(e)
	return Duel.IsExistingMatchingCard(cm.filter,e:GetHandlerPlayer(),LOCATION_MZONE+LOCATION_GRAVE,0,1,nil)
end
