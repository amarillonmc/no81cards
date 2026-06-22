-- 愚人众III-少女
local cm,m,o=GetID()
function cm.initial_effect(c)
  aux.AddXyzProcedure(c,nil,4,2)
  
  -- 添加卡名记述，方便其他卡识别
  aux.AddCodeList(c,60013025,60013027)
  
  -- ②：场上·墓地的这张卡也当作「月下的少女 哥伦比娅」使用
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_ADD_CODE)
  e2:SetValue(60013027)
  e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
  c:RegisterEffect(e2)
  
  -- ①：自己·对方回合1次，把这张卡的1个超量素材取除才能发动。从卡组把1张有「月下的少女 哥伦比娅」或是「绝代的智械 桑多涅」卡名记述的卡加入手卡。把同时具有两者卡名记述的卡加入手卡的场合，对方场上的卡全部除外。
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(m,0))
  e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetRange(LOCATION_MZONE)
  e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
  e1:SetCountLimit(1,m)
  e1:SetCost(cm.xyzcost)
  e1:SetTarget(cm.xyztg)
  e1:SetOperation(cm.xyzop)
  c:RegisterEffect(e1)
  
  -- ③：「绝代的智械 桑多涅」从自己场上离开的场合才能发动。这张卡从手卡（每回合限1次）·墓地特殊召唤。那之后，可以让这个回合，对方不能攻击宣言。这个效果特殊召唤的怪兽从场上离开的场合回到手卡。
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(m,1))
  e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_LEAVE_FIELD)
  e3:SetRange(LOCATION_GRAVE)
  e3:SetCondition(cm.spcon)
  e3:SetTarget(cm.sptg)
  e3:SetOperation(cm.spop)
  c:RegisterEffect(e3)
  -- 手卡的版本，每回合限1次
  local e4=e3:Clone()
  e4:SetCountLimit(1,m+1)
  e4:SetRange(LOCATION_HAND)
  c:RegisterEffect(e4)
end

-- 筛选检索的卡：有哥伦比娅或桑多涅卡名记述的卡
function cm.thfilter(c)
  return c:IsAbleToHand() and (aux.IsCodeListed(c,60013027) or aux.IsCodeListed(c,60013025))
end
-- ①的cost：取除1个超量素材
function cm.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
  e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
-- ①的target
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
-- ①的operation：检索，然后如果是同时有两者卡名的卡，就除外对方场上的所有卡
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT) then
    Duel.ConfirmCards(1-tp,g)
    local tc=g:GetFirst()
    -- 检查是不是同时有两者的卡名记述
    if aux.IsCodeListed(tc,60013025) and aux.IsCodeListed(tc,60013027) then
      Duel.BreakEffect()
      local rg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,LOCATION_ONFIELD,nil)
      if rg:GetCount()>0 then
        Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
      end
    end
  end
end

-- 筛选离开的桑多涅
function cm.cfilter(c,tp,rp)
  return c:IsPreviousPosition(POS_FACEUP) and c:IsPreviousControler(tp)
    and c:IsCode(60013025)
end
-- ③的condition：桑多涅从自己场上离开
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
  return eg:IsExists(cm.cfilter,1,nil,tp,rp) and not eg:IsContains(e:GetHandler())
end
-- ③的target
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
    and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
-- ③的operation：特殊召唤，然后对方不能攻击，离开回手卡
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
    -- 选双方场上·墓地1张卡作为超量素材
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
    local g=Duel.SelectMatchingCard(tp,Card.IsCanBeOverlay,tp,LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_ONFIELD+LOCATION_GRAVE,1,1,c)
    if g:GetCount()>0 then
      Duel.Overlay(c,g)
    end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
    e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
    e1:SetValue(LOCATION_HAND)
    e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
    c:RegisterEffect(e1,true)
  end
end

