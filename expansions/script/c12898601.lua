--斩月 黑崎一护
local s,id,o=GetID()
function s.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.sprcon)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--tograve
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1191)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DECKDES+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetTarget(s.tgtg)
	e2:SetOperation(s.tgop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not aux.check_bleach then
      aux.check_bleach=true
        local ge=Effect.CreateEffect(c)
        ge:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
        ge:SetCode(EVENT_ADJUST)
        ge:SetCondition(s.checkcon)
        ge:SetOperation(s.checkop)
        Duel.RegisterEffect(ge,0)
    end
end
function s.release_filter(c,tp,eg,ep,ev,re,r,rp,chk)
	return function(e)
		local cost=e:GetCost()
		if not cost then return false end
		local found=false
		bleach_Release=Card.IsReleasable
		function Card.IsReleasable(card,...)
				if card==c then
						found=true
				end
				return bleach_Release(card,...)
		end
		cost(e,c:GetControler(),nil,0,0,0,0,0,0)
		Card.IsReleasable=bleach_Release
		return found
	end
end
function s.checknull(c)
  local mt=_G["c"..c:GetOriginalCode()]
    return mt.bleach_mark==nil
end
function s.checkcon(e)
    return Duel.IsExistingMatchingCard(s.checknull,0,0xff,0xff,1,nil)
end
function s.checkop(e,...)
    local g=Duel.GetMatchingGroup(s.checknull,0,0xff,0xff,nil)
    for tc in aux.Next(g) do
      local mt=_G["c"..tc:GetOriginalCode()]
        if tc:IsOriginalEffectProperty(s.release_filter(tc,...)) then
            mt.bleach_mark=true
        else
            mt.bleach_mark=false
        end
    end
end
function s.sprfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR+RACE_ZOMBIE+RACE_FIEND)
end
function s.sprcon(e,c)
	if c==nil then return true end
	if c:IsHasEffect(EFFECT_NECRO_VALLEY) then return false end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (Duel.IsExistingMatchingCard(s.sprfilter,tp,LOCATION_MZONE,0,1,nil)
		or Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0)
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetTarget(s.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function s.splimit(e,c)
	return not c:IsRace(RACE_WARRIOR+RACE_ZOMBIE+RACE_FIEND)
end
function s.tdfilter(c)
	local mt=_G["c"..c:GetOriginalCode()]
  return c:IsRace(RACE_WARRIOR+RACE_FIEND+RACE_ZOMBIE) and c:IsAbleToGrave() and mt.bleach_mark==true
end
function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.tdfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=Duel.SelectMatchingCard(tp,s.tdfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #sg>0 and Duel.SendtoGrave(sg,REASON_EFFECT)~=0 then
		local tc=sg:GetFirst()
		if tc:IsPreviousLocation(LOCATION_HAND) and tc:IsLocation(LOCATION_GRAVE) 
			and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
			Duel.BreakEffect()
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end