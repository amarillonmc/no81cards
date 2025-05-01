--World and Me
local m=13000774
local cm=_G["c"..m]
function c13000774.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,cm.fusfilter1,cm.fusfilter2,true)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.spcon)
	e2:SetOperation(cm.spop)
	c:RegisterEffect(e2)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.negtg)
	e1:SetOperation(cm.negop)
	c:RegisterEffect(e1)
local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.con)
	e3:SetOperation(cm.setop)
	c:RegisterEffect(e3)
if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
  Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	local e0=Effect.CreateEffect(e:GetHandler())
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e0:SetTargetRange(1,0)
	e0:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e0,tp)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCondition(cm.discon)
	e2:SetOperation(cm.disop)
	Duel.RegisterEffect(e2,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,cm.rop)
end
function cm.rop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(nil,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,nil) and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		local aa=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_GRAVE+LOCATION_REMOVED,0,2,2,nil)
			Duel.SendtoDeck(aa,nil,0,REASON_EFFECT)
	end
end
function cm.filter(c,tp)
	return c:IsPreviousLocation(LOCATION_SZONE)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
return eg:IsExists(cm.filter,1,nil,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentPhase()==PHASE_DRAW or Duel.GetCurrentPhase()==0 then return false end
	local v=0
	if eg:IsExists(cm.cfilter,1,nil,0) then v=v+1 end
	if eg:IsExists(cm.cfilter,1,nil,1) then v=v+2 end
	if v==0 then return false end
	e:SetLabel(({0,1,PLAYER_ALL})[v])
	return true
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+94145021,re,r,rp,ep,e:GetLabel())
end
function cm.cfilter(c,tp)
	return c:IsControler(tp) and c:IsPreviousLocation(LOCATION_DECK)
end
function cm.negfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()--添加表侧检测
end
function cm.negtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and cm.negfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISABLE)
	local g=Duel.SelectTarget(tp,cm.negfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
end
function cm.negop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if tc:GetOriginalType()&TYPE_MONSTER~=0 then
			local e1=Effect.CreateEffect(tc)
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_CUSTOM+94145021)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.op)
			tc:RegisterEffect(e1)
		else
			local e1=Effect.CreateEffect(tc)
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
			e1:SetRange(LOCATION_SZONE)
			e1:SetCountLimit(1)
			e1:SetOperation(cm.op)
			tc:RegisterEffect(e1)
		end
	end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(c,REASON_EFFECT)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()--限制为怪兽区
	return Duel.IsExistingMatchingCard(cm.fusfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(cm.fusfilter2,tp,LOCATION_MZONE,0,1,nil) 
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local ga=Duel.SelectMatchingCard(tp,cm.fusfilter1,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local gb=Duel.SelectMatchingCard(tp,cm.fusfilter2,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
			Duel.MoveToField(ga,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			ga:RegisterEffect(e1)
			Duel.MoveToField(gb,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(c)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
			gb:RegisterEffect(e2)
end
function cm.fusfilter1(c)
	return c:IsLevel(1) or c:IsLink(1)
end
function cm.fusfilter2(c)
	return c:IsLevel(12) or c:IsType(TYPE_NORMAL)
end