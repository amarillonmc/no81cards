--混沌No.2 混沌源数门-虚
local m=82209155
local cm=c82209155
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,4,cm.ovfilter,aux.Stringid(m,0))
	c:EnableReviveLimit()
	--code  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)  
	e0:SetCode(EFFECT_CHANGE_CODE)  
	e0:SetRange(LOCATION_MZONE+LOCATION_GRAVE)  
	e0:SetValue(79747096)  
	c:RegisterEffect(e0)  
	--change effect
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.con)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)  
end
aux.xyz_number[m]=2
function cm.ovfilter(c)
	return c:IsFaceup() and c:IsCode(42230449)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)  
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and (re:GetHandler():GetType()==TYPE_SPELL or re:GetHandler():GetType()==TYPE_TRAP) --and rp==1-tp  
end  
function cm.filter(c)
	local te=c:CheckActivateEffect(false,true,false)  
	return (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP) and te and bit.band(te:GetProperty(),EFFECT_FLAG_CARD_TARGET)==0
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetFlagEffect(m)>0 or (not Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)) or (not Duel.SelectEffectYesNo(tp,c)) then return end
	Duel.Hint(HINT_CARD,0,m)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RESOLVECARD)
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	if g:GetCount()<=0 then return end 
	c:RegisterFlagEffect(m,RESET_PHASE+PHASE_END+RESET_EVENT+RESETS_STANDARD,0,1)
	Duel.HintSelection(g)
	local empty=Group.CreateGroup()  
	Duel.ChangeTargetCard(ev,empty)  
	Duel.ChangeChainOperation(ev,cm.repop)  
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(false,true,true)
	re:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(re,rp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(re:GetLabelObject())
	re:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)  
	local te=e:GetLabelObject()  
	if not te then return end  
	e:SetLabelObject(te:GetLabelObject())  
	local op=te:GetOperation()  
	if op then op(e,tp,eg,ep,ev,re,r,rp) end 
end  