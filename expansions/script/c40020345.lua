--溶星龟 始祖龟
local s,id=GetID()


s.named_with_LavaAstral=1
function s.LavaAstral(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_LavaAstral
end


local OME_ID=40020321

function s.initial_effect(c)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O) 
	e1:SetCode(EVENT_SPSUMMON)   
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)  
	e1:SetCondition(s.spcon_summon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_MOVE)
	e2:SetRange(LOCATION_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.spcon_move)
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(s.actcon)
	e3:SetValue(s.aclimit)
	c:RegisterEffect(e3)
end

function s.spcon_summon(e,tp,eg,ep,ev,re,r,rp)
	return ep==1-tp
end
function s.omefilter(c,tp)
	return c:IsCode(OME_ID) and c:IsControler(tp) and c:IsLocation(LOCATION_PZONE)
		and c:IsPreviousLocation(LOCATION_HAND+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA)
end
function s.spcon_move(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(s.omefilter,1,nil,tp)
end

function s.desfilter(c)
	return c:IsFaceup() and c:GetAttack()>=0
end

function s.gcheck(g)
	local sum=g:GetSum(Card.GetAttack)

	if sum<2100 then return false end

	return not g:IsExists(function(c) return sum-c:GetAttack()>=2100 end, 1, nil)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)
	if chk==0 then

		return g:GetCount()>0 and g:CheckSubGroup(s.gcheck,1,#g)
			and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.desfilter,tp,0,LOCATION_MZONE,nil)

	if g:GetCount()>0 and g:CheckSubGroup(s.gcheck,1,#g) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)

		local dg=g:SelectSubGroup(tp,s.gcheck,false,1,#g)
		if dg and dg:GetCount()>0 then
			Duel.HintSelection(dg)
			if Duel.Destroy(dg,REASON_EFFECT)~=0 then
				if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
					Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		end
	end
end

function s.omepzfilter(c)
	return c:IsFaceup() and c:IsCode(OME_ID)
end
function s.actcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	return Duel.IsExistingMatchingCard(s.omepzfilter,tp,LOCATION_PZONE,0,1,nil)
		and a and a:IsControler(tp) and s.LavaAstral(a)
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
