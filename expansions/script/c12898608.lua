--现世 茶渡泰虎
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1118)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.negcon)
	e2:SetCost(s.negcost)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
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
function s.spfilter(c)
	local mt=_G["c"..c:GetOriginalCode()] 
	return (mt.bleach_mark==true or c:IsSetCard(0x3a7f)) and c:IsFaceup()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if not aux.NecroValleyFilter()(c) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if c:IsPreviousLocation(LOCATION_GRAVE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(LOCATION_REMOVED)
			e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
			c:RegisterEffect(e1)
		end
	end
end
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev) and not e:GetHandler():IsStatus(STATUS_DESTROY_CONFIRMED)
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end