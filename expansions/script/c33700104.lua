--动物朋友 八咫乌
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function c33700104.initial_effect(c)
	Senya.AddSummonSE(c,aux.Stringid(33700104,2))
	Senya.AddAttackSE(c,aux.Stringid(33700104,3))
	c33700104[c]={}
	local effect_list=c33700104[c]
	 c:EnableCounterPermit(0x442)
	--synchro summon
	aux.AddSynchroProcedure2(c,nil,aux.NonTuner(nil))
	 c:EnableReviveLimit()
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--win
	--[[local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(33700104)
	e2:SetCondition(c33700104.wincon)
	e2:SetOperation(c33700104.winop)
	c:RegisterEffect(e2)]]
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_ATTACK)
	e5:SetValue(10000)
	e5:SetCondition(function(e)
		return e:GetHandler():GetCounter(0x442)>=6
	end)
	c:RegisterEffect(e5)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetCondition(c33700104.con)
	e3:SetValue(c33700104.efilter)
	c:RegisterEffect(e3)   
	--atk
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_BASE_ATTACK)
	e5:SetValue(4000)
	e5:SetLabel(15)
	effect_list[15]=e5
	e5:SetCondition(c33700104.effcon)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e6)
   --ind  
   local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetCondition(c33700104.effcon2)
	e7:SetValue(1)
	e7:SetLabel(1)
	effect_list[1]=e7
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e8)
	--
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(33700104,0))
	e9:SetCategory(CATEGORY_COUNTER)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e9:SetCondition(c33700104.ccon)
	e9:SetCost(c33700104.cost)
	e9:SetTarget(c33700104.ctg)
	e9:SetOperation(c33700104.cop)
	c:RegisterEffect(e9)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(33700104,1))
	e4:SetCategory(CATEGORY_COUNTER+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e4:SetCondition(c33700104.ccon)
	e4:SetCost(c33700104.cost)
	e4:SetTarget(c33700104.retg)
	e4:SetOperation(c33700104.reop)
	c:RegisterEffect(e4)
end
function c33700104.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end
function c33700104.confilter(c)
	return c:IsSetCard(0x442) and c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c33700104.jfilter(c)
	return c:GetCode()==33700090 and c:IsFaceup() and not c:IsDisabled()
end
function c33700104.con(e,tp,eg,ep,ev,re,r,rp)
   local g=Duel.GetMatchingGroup(c33700104.confilter,tp,LOCATION_GRAVE,0,nil)
   return g:GetClassCount(Card.GetCode)>=30 or e:GetHandler():GetCounter(0x442)>=6
end
function c33700104.effcon(e)
	local g=Duel.GetMatchingGroup(c33700104.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090
end
function c33700104.effcon2(e)
	local g=Duel.GetMatchingGroup(c33700104.confilter,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil)
	return (g:GetClassCount(Card.GetCode)>=e:GetLabel() or e:GetLabel()==33700090)
	and  Duel.IsExistingMatchingCard(c33700104.confilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c33700104.ccon(e,tp,eg,ep,ev,re,r,rp)
	 local g=Duel.GetMatchingGroup(nil,e:GetHandlerPlayer(),0,LOCATION_GRAVE,nil)
	return Duel.GetTurnPlayer()==tp and  g:GetClassCount(Card.GetCode)<g:GetCount()
end
function c33700104.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c33700104.ctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanAddCounter(0x442,1) end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700104,4))
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,0x442)
end
function c33700104.cop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	 e:GetHandler():AddCounter(0x442,1)
  if e:GetHandler():GetCounter(0x442)>=9 then
  Duel.RaiseSingleEvent(e:GetHandler(),33700104,e,0,tp,0,0)
end
end
function c33700104.retg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SOUND,0,aux.Stringid(33700104,4))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_GRAVE,1,1,nil)
	local tg=Duel.GetMatchingGroup(c33700104.refilter,tp,0,LOCATION_GRAVE,nil,g:GetFirst():GetCode())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,tg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,tg:GetCount(),0,0x442)
end
function c33700104.refilter(c,tc)
	return c:GetCode()==tc and c:IsAbleToRemove()
end
function c33700104.reop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget():GetCode()
	if Duel.GetMatchingGroupCount(c33700104.refilter,tp,0,LOCATION_GRAVE,nil,tc)>0 then
	local g=Duel.GetMatchingGroup(c33700104.refilter,tp,0,LOCATION_GRAVE,nil,tc)
	local rg=Duel.Remove(g,POS_FACEUP,REASON_EFFECT) 
	if rg>0 and e:GetHandler():IsRelateToEffect(e) then
	 e:GetHandler():AddCounter(0x442,rg)
	if e:GetHandler():GetCounter(0x442)>=9 then
  Duel.RaiseSingleEvent(e:GetHandler(),33700104,e,0,tp,0,0)
end
end
end
end
function c33700104.wincon(e)
   return e:GetHandler():GetCounter(0x442)>=9
end
function c33700104.winop(e,tp,eg,ep,ev,re,r,rp)
  Duel.SetLP(1-tp,0)
end
