--极简塔防 围墙
function c65850020.initial_effect(c)
	--特招
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65850020)
	e1:SetCondition(c65850020.rmcon)
	e1:SetTarget(c65850020.rmtg)
	e1:SetOperation(c65850020.rmop)
	c:RegisterEffect(e1)
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65850020,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,65850020+1)
	e2:SetCondition(c65850020.lkcon)
	e2:SetTarget(c65850020.lktg)
	e2:SetOperation(c65850020.lkop)
	c:RegisterEffect(e2)
end


function c65850020.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function c65850020.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c65850020.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850020.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CHANGE_DAMAGE)
		e3:SetTargetRange(1,0)
		e3:SetValue(0)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
		e4:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e4,tp)
	end
end
function c65850020.splimit(e,c)
	return not c:IsSetCard(0xa35)
end

function c65850020.lkcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c65850020.lktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c65850020.lkfilter,tp,LOCATION_EXTRA,0,1,nil,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c65850020.lkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c65850020.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	if c:IsControler(1-tp) or not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local g=Duel.GetMatchingGroup(c65850020.lkfilter,tp,LOCATION_EXTRA,0,nil,nil,c)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.LinkSummon(tp,sg:GetFirst(),nil,c)
	end
end
function c65850020.lkfilter(c,lc)
	return c:IsSetCard(0xa35) and c:IsLinkSummonable(nil,lc)
end