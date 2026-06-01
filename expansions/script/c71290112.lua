Duel.LoadScript("c71290100.lua")
local cm,m,o=GetID()
cm.isPlaneswalker=true
function cm.initial_effect(c)
  
	local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetValue(Heita.atkval)
  c:RegisterEffect(e2)
	local e3=e2:Clone()
  e3:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(Heita.splimit)
	c:RegisterEffect(e4)
  
  -- ①：手卡特招，然后加等级的效果
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_HAND)
  e1:SetCountLimit(1,m)
  e1:SetCondition(cm.spcon1)
  e1:SetTarget(cm.sptg1)
  e1:SetOperation(cm.spop1)
  c:RegisterEffect(e1)
  
  -- ②：双方没有手卡数量限制，参考无限的手札
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_HAND_LIMIT)
  e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
  e2:SetRange(LOCATION_MZONE)
  e2:SetTargetRange(1,1)
  e2:SetValue(100)
  c:RegisterEffect(e2)
end

-- ①的条件：自己场上没有怪兽，场地区域有卡
function cm.spcon1(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)==0
    and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_FZONE,0,1,nil)
end
-- ①的target
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
-- ①的operation
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
  if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then return end
  --
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_ADJUST)
		e1:SetCondition(cm.levelchangecon)
		e1:SetOperation(cm.levelchangeop)
		e1:SetReset(RESET_EVENT+0xff0000)
		c:RegisterEffect(e1)
		for i=1,c:GetLevel() do
			Duel.RegisterFlagEffect(tp,71290111,0,0,1)
		end
end
function cm.levelchangecon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)
	if lv==0 then lv=1 end
	if lv>13 then lv=13 end
	return c:GetLevel()~=lv
end
function cm.levelchangeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,nil)+1
	if lv==0 then lv=1 end
	if lv>13 then lv=13 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(lv)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
  
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(71290111)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e2)
end