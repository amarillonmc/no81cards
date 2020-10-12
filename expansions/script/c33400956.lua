--破军歌姬 幻想曲
local m=33400956
local cm=_G["c"..m]
function cm.initial_effect(c)
  --Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)	
	 --
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33400956,1))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.con)
	e1:SetCountLimit(1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
 --
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33400956,2))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.setcon)
	e2:SetTarget(cm.tftg)
	e2:SetOperation(cm.tfop)
	c:RegisterEffect(e2)
end
function cm.ckfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xc341) and c:IsType(TYPE_MONSTER)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.ckfilter,tp,LOCATION_MZONE,0,1,nil) 
end
function cm.filter(c)
	return c:IsFaceup() and (c:GetAttack()>0 or c:GetDefense()>0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and cm.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(cm.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local atk=g:GetFirst():GetAttack()
	local def=g:GetFirst():GetDefense()
	if def>atk then atk=def end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,atk)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	if def>atk then atk=def end
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and atk>0 then
		Duel.Recover(tp,atk,REASON_EFFECT)
	end
end

function cm.cfilter(c,tp)
	return  c:IsPreviousLocation(LOCATION_HAND) and c:GetPreviousControler()==tp
end
function cm.setcon(e,tp,eg,ep,ev,re,r,rp)
	return  eg:IsExists(cm.cfilter,1,nil,tp) 
end
function cm.tffilter(c,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsType(TYPE_CONTINUOUS) and c:IsSetCard(0x5340) and not c:IsCode(m)
		and not c:IsForbidden() and c:CheckUniqueOnField(tp) and not Duel.IsExistingMatchingCard(cm.ckilter2,tp,LOCATION_SZONE,0,1,nil,c:GetCode())
end
function cm.ckilter2(c,code)
	return  c:IsFaceup() and c:IsCode(code)
end
function cm.tftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.tffilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,nil,tp) end
end
function cm.tfop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,cm.tffilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
