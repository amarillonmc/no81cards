--百态妄相
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,60000032)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(cm.con)
	c:RegisterEffect(e2)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PREDRAW)
	e3:SetCountLimit(1)
	e3:SetRange(0xff)
	e3:SetOperation(cm.retop)
	c:RegisterEffect(e3)
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetLabelObject(e3)
	e1:SetCost(aux.bfgcost)
	e1:SetTarget(cm.lptg)
	e1:SetOperation(cm.lpop)
	c:RegisterEffect(e1)
end
function cm.confil(c)
	return c:IsCode(60000032) and c:IsFaceup()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandlerPlayer()
	local num=0
	for i=60000037,60000039 do
		for j=1,3 do
			if Duel.GetFlagEffect(tp,i+j*10000000)~=0 then num=num+1 end
		end
	end
	if chk==0 then return num~=0 end
	
	local checktable={}
	local num=1
	for i=60000037,60000039 do
		for j=1,3 do
			if Duel.GetFlagEffect(tp,i+j*10000000)~=0 then 
				checktable[num]=i+j*10000000
				num=num+1
			end
		end
	end
	
	local ct=math.random(1,num-1)
	local jt=checktable[ct]
	Duel.ResetFlagEffect(tp,jt)
	local um=0
	if jt==70000037 then um=1 
	elseif jt==80000037 then um=2 
	elseif jt==90000037 then um=3 
	elseif jt==70000038 then um=4
	elseif jt==80000038 then um=5 
	elseif jt==90000038 then um=6 
	elseif jt==70000039 then um=7 
	elseif jt==80000039 then um=8 
	elseif jt==90000039 then um=9 end
	
	Duel.SelectOption(tp,aux.Stringid(m,um))
	Duel.Hint(HINT_MESSAGE,1-tp,aux.Stringid(m,um))
	
	e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
end
function cm.filter(c)
	return c:IsCode(60000032) and c:IsAbleToGraveAsCost()
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(m)==0 then return end
	--negate
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAINING)
	e3:SetOperation(cm.negop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp) 
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if rc:GetControler()~=tp and Duel.SelectEffectYesNo(tp,e:GetHandler()) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.NegateEffect(ev)
		Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
		e:Reset()
	end
end
--random
function getrand()
	local result=0
	local g=Duel.GetDecktopGroup(0,5)
	local tc=g:GetFirst()
	while tc do
		result=result+tc:GetCode()
		tc=g:GetNext()
	end
	math.randomseed(result)
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabel(Duel.GetLP(e:GetHandlerPlayer()))
end
function cm.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLP(e:GetHandlerPlayer())~=e:GetLabelObject():GetLabel() end
end
function cm.lpop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message(e:GetLabelObject():GetLabel())
	if Duel.GetLP(e:GetHandlerPlayer())~=e:GetLabelObject():GetLabel() then 
		Duel.SetLP(e:GetHandlerPlayer(),e:GetLabelObject():GetLabel())
	end
end