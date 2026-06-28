-- 热血龙教师·乔
Duel.LoadScript("c60001511.lua")
local cm,m,o=GetID()
function cm.initial_effect(c)
	byd.pglBegin(c)
	c:EnableReviveLimit()
	
  c:EnableCounterPermit(0x624)
  
  -- 融合召唤条件：龙族怪兽2只
  aux.AddFusionProcFunRep(c,function(c) return c:IsRace(RACE_DRAGON) end,2,true)
  
  -- ②：这张卡上是已有进化指示物的场合，这张卡获得下述效果
  -- 守备力上升1600
  local ee1=Effect.CreateEffect(c)
  ee1:SetType(EFFECT_TYPE_SINGLE)
  ee1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  ee1:SetRange(LOCATION_MZONE)
  ee1:SetCode(EFFECT_UPDATE_DEFENSE)
  ee1:SetCondition(cm.incon)
  ee1:SetValue(1600)
  c:RegisterEffect(ee1)
  
	--defense attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DEFENSE_ATTACK)
	e1:SetValue(1)
	c:RegisterEffect(e1)
  
  -- 守备力5500以上的这张卡不受其他卡的效果影响
  local ee2=Effect.CreateEffect(c)
  ee2:SetType(EFFECT_TYPE_SINGLE)
  ee2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  ee2:SetRange(LOCATION_MZONE)
  ee2:SetCode(EFFECT_IMMUNE_EFFECT)
  ee2:SetCondition(cm.immunecon)
  ee2:SetValue(cm.immunefilter)
  c:RegisterEffect(ee2)
  
  -- ①：这张卡特殊召唤成功的场合才能发动。自己场上的怪兽守备力合计是8000以上的场合，对方场上的卡尽可能破坏。给与对方2000伤害。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_DELAY)
  e1:SetCode(EVENT_SPSUMMON_SUCCESS)
  e1:SetOperation(cm.op1)
  c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end

-- 进化指示物的condition
function cm.incon(e)
  return Card.GetCounter(e:GetHandler(),0x624)>=1
end

-- 免疫效果的condition：有进化指示物，且守备力达到5500以上
function cm.immunecon(e)
  local c=e:GetHandler()
  return cm.incon(e) and c:GetDefense()>=5500
end

-- 免疫效果的filter：不受其他卡的效果影响
function cm.immunefilter(e,te)
  return te:GetOwner()~=e:GetOwner()
end

-- ①的operation
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  -- 计算自己场上所有表侧怪兽的守备力合计
  local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
  local sum=0
  for tc in aux.Next(g) do
    sum=sum+tc:GetDefense()
  end
  if sum>=8000 then
    -- 对方场上的卡全部破坏
    local og=Duel.GetMatchingGroup(nil,tp,0,LOCATION_ONFIELD,nil)
    if og:GetCount()>0 then
      Duel.Destroy(og,REASON_EFFECT)
    end
    -- 给与对方2000伤害
    Duel.Damage(1-tp,2000,REASON_EFFECT)
  end
end

function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	local rc=re:GetHandler()
	if chk==0 then return c:IsAbleToGrave() and rc:IsAbleToGrave() and rc:IsLocation(LOCATION_HAND+LOCATION_MZONE) and rc:GetDefense()~=rc:GetBaseDefense() and rc:IsRace(RACE_DRAGON) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		local tg=Group.FromCards(c,rc)
		if Duel.SendtoGrave(tg,REASON_EFFECT) then
			
      local e1=Effect.CreateEffect(c)
      e1:SetType(EFFECT_TYPE_FIELD)
      e1:SetCode(EFFECT_UPDATE_DEFENSE)
      e1:SetTargetRange(LOCATION_MZONE,0)
      e1:SetTarget(cm.drtg)
      e1:SetValue(500)
      Duel.RegisterEffect(e1,tp)
			local bg=Duel.GetOperatedGroup()
      for tc in aux.Next(bg) do
        tc:CompleteProcedure()
      end
			if bg and #bg==#bg:Filter(Card.IsSetCard,nil,0x5624) then
				Duel.Draw(tp,2,REASON_EFFECT)
			end
		end
	end
end
function cm.drtg(e,c)
	return c:IsRace(RACE_DRAGON)
end