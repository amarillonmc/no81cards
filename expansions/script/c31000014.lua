--Fallacio ad Hominem
function c31000014.initial_effect(c)
  c:SetUniqueOnField(1,0,31000014)
  --Synchro Summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x308),aux.NonTuner(Card.IsSetCard,0x308),1)
	c:EnableReviveLimit()
  --Gain ATK/DEF
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c31000014.adval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
  --Negate
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DESTROY+CATEGORY_DISABLE)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_CHAINING)
  e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCountLimit(1)
  e3:SetCondition(c31000014.con)
  e3:SetTarget(c31000014.tg)
  e3:SetOperation(c31000014.op)
  c:RegisterEffect(e3)
end

function c31000014.adval(e,c)
  local filter=function(c)
    return c:IsSetCard(0x308) and c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP)
  end
  local g=Duel.GetMatchingGroup(filter,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil)
	return g:GetCount()*500
end

function c31000014.tgfilter(c)
  return c:IsType(TYPE_MONSTER) and c:IsPosition(POS_FACEUP)
end

function c31000014.con(e,tp,eg,ep,ev,re,r,rp)
  local tgp=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_PLAYER)
  return tgp~=tp
end

function c31000014.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsPosition(POS_FACEUP) end
  if chk==0 then return Duel.IsExistingTarget(c31000014.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c31000014.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,g:GetFirst(),1,1-tp,LOCATION_MZONE)
end

function c31000014.op(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  local dg=Group.CreateGroup()
  local vl1=e:GetHandler():GetAttack()*(-1)
  local vl2=e:GetHandler():GetDefense()*(-1)
  if tc:IsRelateToEffect(e) then
    local preatk=tc:GetAttack()
    local predef=tc:GetDefense()
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(vl1)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    tc:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EFFECT_UPDATE_DEFENSE)
    e2:SetValue(vl2)
    tc:RegisterEffect(e2)
    if (preatk~=0 or predef~=0) and tc:IsAttack(0) and tc:IsDefense(0)
      then dg:AddCard(tc) end
    if Duel.Destroy(dg,REASON_EFFECT) then
      for i=1,ev do
        local tgp=Duel.GetChainInfo(i,CHAININFO_TRIGGERING_PLAYER)
        if tgp~=tp then Duel.NegateEffect(i) end
      end
    end
  end
end
