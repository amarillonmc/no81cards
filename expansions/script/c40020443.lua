--龙神之霸皇 齐格·大和·弗利德
local s,id=GetID()

function s.Grandwalker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Grandwalker
end

function s.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE+EVENT_EFFECT_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(s.spcon2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(aux.bdocon)
	e3:SetTarget(s.damtg)
	e3:SetOperation(s.damop)
	c:RegisterEffect(e3)
end
function s.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return (ep==tp or ep==1-tp) and ev>0
end
function s.spcon2(e,tp,eg,ep,ev,re,r,rp)
return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE
		and rp==1-tp and not re:GetHandler():IsLocation(LOCATION_ONFIELD)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_MZONE,1,nil) end 
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
	local b1=Duel.IsExistingMatchingCard(s.Grandwalker,tp,LOCATION_PZONE,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_SZONE,1,nil)
	if not (b1 and b2) then return end
	
	if Duel.SelectYesNo(tp,aux.Stringid(id,2)) then 
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local pg=Duel.SelectMatchingCard(tp,s.Grandwalker,tp,LOCATION_PZONE,0,1,1,nil)
		if #pg>0 then
			Duel.Destroy(pg,REASON_EFFECT)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local tg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_SZONE,0,2,nil)
		if #tg>0 then
			Duel.Destroy(tg,REASON_EFFECT)
		end
	end
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1600)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1600)
end

function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
