--抵抗巨炮 回收站

local s,id,o=GetID()
local zd=0x3d4
function s.initial_effect(c)

  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)

	
	--SpSumWhebnMonsterLevae
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOGRAVE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.e2con)
	e2:SetTarget(s.e2tg)
	e2:SetOperation(s.e2op)
	c:RegisterEffect(e2)

	--SelfFGReturnToDeckAndDrawWhenLinkSpumm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.e3con)
	e3:SetTarget(s.e3tg)
	e3:SetOperation(s.e3op)
	c:RegisterEffect(e3)
	
  
end


--e2

function s.e2confilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsReason(REASON_EFFECT)
end

function s.e2con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.e2confilter,1,nil)
end

function s.e2spfilter(c,e,tp)
	return c:IsSetCard(zd) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.e2lkfilter(c,lc)
	return c:IsSetCard(zd) and c:IsLinkSummonable(nil,lc)
end

function s.e2tg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(s.e2spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end

function s.e2op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.e2spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE) > 0) then return end
	
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,s.e2spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
  Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
  
  local lmc=g:GetFirst()
  
  if not (Duel.IsExistingMatchingCard(s.e2lkfilter,tp,LOCATION_EXTRA,0,1,nil,lmc) and Duel.SelectYesNo(tp,aux.Stringid(id,2))) then return end
	local g=Duel.GetMatchingGroup(s.e2lkfilter,tp,LOCATION_EXTRA,0,nil,lmc)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,lmc)
	end	
end


--e3
function s.e3cfilter(c,tp,sumt)
	return c:IsFaceup() and c:IsSetCard(zd) and c:IsSummonType(sumt) and c:IsSummonPlayer(tp)
end

function s.e3con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.e3cfilter,1,nil,tp,SUMMON_TYPE_LINK)
end

function s.e3todfilter(c)
	return c:IsAbleToDeck() and c:IsSetCard(zd) and (not c:IsLocation(LOCATION_REMOVED) or c:IsFaceup())
end

function s.e3tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.e3todfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE+LOCATION_REMOVED)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,0)
end


function s.e3op(e,tp,eg,ep,ev,re,r,rp)
	if not (Duel.IsExistingMatchingCard(s.e3todfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil) and Duel.IsPlayerCanDraw(tp,1))  then return end 
  
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
  local g2=Duel.SelectMatchingCard(tp,s.e3todfilter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,3,nil)
  Duel.SendtoDeck(g2,nil,3,REASON_EFFECT)
	Duel.Draw(tp,1,REASON_EFFECT)
end




