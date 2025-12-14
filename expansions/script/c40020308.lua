--天觉龙 拿欧
local s,id=GetID()

s.named_with_AwakenedDragon=1
function s.AwakenedDragon(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_AwakenedDragon
end
local CODE_MITRA=40020256

function s.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetTargetRange(1,0)
	e0:SetTarget(s.splimit)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND+LOCATION_EXTRA)
	e1:SetCountLimit(1,id)  
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)

	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1,id+1)	
	e2:SetCondition(s.drcon)
	e2:SetTarget(s.drtg)
	e2:SetOperation(s.drop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function s.splimit(e,c,tp,sumtp,sumpos)
	return not s.AwakenedDragon(c) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end

function s.mitrafilter(c)
	return c:IsFaceup() and c:IsCode(CODE_MITRA)
end
function s.has_mitra(tp)
	return Duel.IsExistingMatchingCard(
		s.mitrafilter,tp,
		LOCATION_ONFIELD+LOCATION_EXTRA,0,1,nil
	)
end
local function adds_from_deck_to_hand(ev,re,tp)
	if re:GetHandlerPlayer()==tp then return false end
	if not re:IsHasCategory(CATEGORY_TOHAND) then return false end
	local ex1,g1,gc1,dp1,dv1=Duel.GetOperationInfo(ev,CATEGORY_TOHAND)
	if not ex1 then return false end
	if g1 then
		return g1:IsExists(Card.IsLocation,1,nil,LOCATION_DECK)
	end
	return true
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsLocation(LOCATION_HAND)
		or (c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())) then
		return false
	end
	if not s.has_mitra(tp) then return false end
	return adds_from_deck_to_hand(ev,re,tp)
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
	if not s.has_mitra(tp) then return false end
	local my=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	local op=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	return op>my
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local op=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local dc=math.floor(op/2)
	if chk==0 then
		return dc>0 and Duel.IsPlayerCanDraw(tp,dc)
	end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,dc)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
	local op=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	local dc=math.floor(op/2)
	if dc<=0 or not Duel.IsPlayerCanDraw(tp,dc) then return end
	local drew=Duel.Draw(tp,dc,REASON_EFFECT)
	if drew<2 then return end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoDeck(sg,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
	end
end
