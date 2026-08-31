--千本樱 朽木白哉
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.cost)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(1118)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.spcon)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
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
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.filter(c)
	local mt=_G["c"..c:GetOriginalCode()]
	return c:IsRace(RACE_ZOMBIE) and c:IsLevelBelow(6) and c:IsAbleToGrave() and mt.bleach_mark==true
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,1,tp,1)
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)>0 and g:GetFirst():IsLocation(LOCATION_GRAVE) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
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
function s.desfilter(c,re)
	return c:IsReason(REASON_EFFECT+REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD)
	and re:GetHandler():IsRace(RACE_WARRIOR+RACE_FIEND+RACE_ZOMBIE)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re and eg:IsExists(s.desfilter,1,nil,re)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.SendtoHand(g,nil,REASON_EFFECT)
			end
		end
	end
end