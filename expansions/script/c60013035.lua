-- 愚人众VII-木偶
local cm,m,o=GetID()
function cm.initial_effect(c)
  -- 超量召唤条件：4星怪兽×2
  aux.AddXyzProcedure(c,nil,4,2)
  
  -- 添加卡名记述，方便其他卡识别
  aux.AddCodeList(c,60013025,60013027)
  
  -- ②：场上·墓地的这张卡也当作「绝代的智械 桑多涅」使用
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_ADD_CODE)
  e2:SetValue(60013025)
  e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
  c:RegisterEffect(e2)
  
  -- ①：自己·对方回合1次，把这张卡的1个超量素材取除才能发动。这个回合，自己对有「月下的少女 哥伦比娅」或是「绝代的智械 桑多涅」卡名记述的速攻魔法·陷阱卡各有1次可以从手卡发动。那之后，自己抽1张。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_DRAW)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
  e1:SetCountLimit(1,m)
  e1:SetCost(cm.xyzcost)
  e1:SetOperation(cm.xyzop)
  c:RegisterEffect(e1)
  
  -- ③：自己·对方回合，自己场上有「月下的少女 哥伦比娅」存在的场合才能发动。这张卡从墓地特殊召唤。那之后，选双方场上·墓地1张卡作为这张卡的超量素材。这个效果特殊召唤的怪兽从场上离开的场合回到额外卡组。
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,2))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_QUICK_O)
  e3:SetCode(EVENT_FREE_CHAIN)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(cm.spcon)
  e3:SetTarget(cm.sptg)
  e3:SetOperation(cm.spop)
  c:RegisterEffect(e3)
end

-- 筛选自己场上的表侧的哥伦比娅
function cm.colfilter(c)
  return c:IsCode(60013027) and c:IsFaceup()
end
-- ③的condition：自己场上有表侧的哥伦比娅
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(cm.colfilter,tp,LOCATION_MZONE,0,1,nil)
end
-- ③的target
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
-- ③的operation：特殊召唤，然后加超量素材，然后离开回额外
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
    -- 选双方场上·墓地1张卡作为超量素材
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,Card.IsCanBeOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
    if g:GetCount()>0 then
      Duel.Overlay(c,g)
    end
    -- 这个效果特殊召唤的怪兽从场上离开的场合回到额外卡组
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e1:SetValue(LOCATION_EXTRA)
    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
    c:RegisterEffect(e1,true)
  end
end

-- ①的cost：取除1个超量素材
function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
-- 发动权限筛选：筛选有哥伦比娅或桑多涅卡名记述的速攻魔法/陷阱
function cm.acttg(e,c)
  return (aux.IsCodeListed(c,60013027) or aux.IsCodeListed(c,60013025)) and 
    (c:IsType(TYPE_QUICKPLAY) or c:IsType(TYPE_TRAP))
end
-- ①的operation：给速攻和陷阱加手卡发动权限，然后抽1张
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
  -- 速攻魔法发动权限
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
  e1:SetTargetRange(LOCATION_HAND,0)
  e1:SetTarget(cm.acttg)
  e1:SetCountLimit(1)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  
  -- 陷阱发动权限
  local e2=Effect.CreateEffect(e:GetHandler())
  e2:SetType(EFFECT_TYPE_FIELD)
  e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
  e2:SetTargetRange(LOCATION_HAND,0)
  e2:SetTarget(cm.acttg)
  e2:SetCountLimit(1)
  e2:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e2,tp)
  
  -- 那之后，自己抽1张
  Duel.BreakEffect()
  Duel.Draw(tp,1,REASON_EFFECT)
end
