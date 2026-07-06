--泣血应龙
local m=43990126
local cm=_G["c"..m]
function cm.initial_effect(c)
	--不能通常召唤
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(cm.splimit)
	c:RegisterEffect(e0)
	--①：自己·对方回合，手卡·墓地·除外中，从手卡·卡组各除外1只幻想魔族/兽战士族，自身特殊召唤
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1,43990126)
	e1:SetCost(cm.spcost)
	e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	--②：特殊召唤成功时，选墓地1只幻想魔族/兽战士族特殊召唤（非取对象）
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,43999126)
	e4:SetTarget(cm.sptg2)
	e4:SetOperation(cm.spop2)
	c:RegisterEffect(e4)
	--③：ATK/DEF上升 自己场上幻想魔族·兽战士族数量×1000
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetValue(cm.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
end
--不能通常召唤
function cm.splimit(e,se,sp,st)
	return se:IsHasType(EFFECT_TYPE_ACTIONS)
end
--① cost filter：幻想魔族或兽战士族（除外用）
function cm.cfilter(c,exc)
	return (c:IsRace(RACE_ILLUSION) or c:IsRace(RACE_BEASTWARRIOR))
		and c:IsAbleToRemove() and c~=exc
end
--① cost SubGroup 校验：恰好 1手卡 + 1卡组
function cm.spcostcheck(g,tp)
	return g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND)
		and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
end
--① cost：CheckSubGroup判定 + SelectSubGroup选择
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_HAND,0,c)
	local g2=Duel.GetMatchingGroup(cm.cfilter,tp,LOCATION_DECK,0,nil)
	g1:Merge(g2)
	if chk==0 then return g1:CheckSubGroup(cm.spcostcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g1:SelectSubGroup(tp,cm.spcostcheck,false,2,2)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
--① target
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
--① operation
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
--② filter：墓地幻想魔族或兽战士族（可特殊召唤）
function cm.gyfilter(c,e,tp)
	return (c:IsRace(RACE_ILLUSION) or c:IsRace(RACE_BEASTWARRIOR))
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
--② target（非取对象）
function cm.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(cm.gyfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
--② operation（非取对象）
function cm.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.gyfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
end
--③ filter：自己场上表侧的幻想魔族·兽战士族
function cm.atkfilter(c)
	return c:IsFaceup() and (c:IsRace(RACE_ILLUSION) or c:IsRace(RACE_BEASTWARRIOR))
end
--③ ATK/DEF值
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.atkfilter,c:GetControler(),LOCATION_MZONE,0,nil)*1000
end
