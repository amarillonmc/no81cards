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

end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
   local ss=Duel.GetTurnCount()
	return Duel.GetFlagEffect(tp,33413501)<ss and Duel.GetFlagEffect(tp,m+30000)==0 and Duel.GetFlagEffect(tp,33443500)==0
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
	return  not c:IsCode(33403501) and  c:IsSetCard(0x5349) and c:IsType(TYPE_SPELL+TYPE_TRAP) 
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	Duel.ClearTargetCard()
	g:GetFirst():CreateEffectRelation(e)
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
	if e:GetLabel()==1 then 
	Duel.RegisterFlagEffect(tp,m+20000,RESET_PHASE+PHASE_END,0,1) --t1 t2
	Duel.RegisterFlagEffect(tp,33413501,RESET_PHASE+PHASE_END,0,1) --t1
	Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
	e:SetLabel(2)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return false end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end 
  Duel.RegisterFlagEffect(tp,33403501,0,0,0)  
  local tc=te:GetHandler()
end

