--降罪的雷击
local m=33401628
local cm=_G["c"..m]
function cm.initial_effect(c)
	  --activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
   --indes/untarget
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_ONFIELD,0)
	e2:SetTarget(cm.intg)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
--activate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(cm.condition)
	e3:SetTarget(cm.target)
	e3:SetOperation(cm.activate)
	c:RegisterEffect(e3)
end
function cm.intg(e,c)
	return c:IsFaceup() and ((c:IsSetCard(0x6344) and c:IsType(TYPE_MONSTER)) or c:IsCode(33401625))
end

function cm.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and  (c:IsSetCard(0x6344) or Duel.IsExistingMatchingCard(cm.ckfilter3,tp,LOCATION_MZONE,0,1,nil,c:GetAttribute()))
end
function cm.ckfilter2(c)
	return c:IsSetCard(0x6344) and c:IsFaceup() and c:IsType(TYPE_MONSTER)   
end
function cm.ckfilter3(c,at)
	return  c:IsFaceup() and c:IsType(TYPE_MONSTER)   and   c:IsAttribute(at)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(cm.ckfilter2,tp,LOCATION_MZONE,0,1,nil) and eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc~=e:GetHandler() end
	if chk==0 then return  Duel.IsExistingTarget(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then 
	Duel.Destroy(tc,REASON_EFFECT)	 
	end
end
