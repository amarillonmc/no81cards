--红 之 印 象 古 生 始 源 之 海
local m=22348060
local cm=_G["c"..m]
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function cm.initial_effect(c)
	local e1,e1_1,e2,e3=SNNM.ActivatedAsSpellorTrap(c,0x4,LOCATION_SZONE,true)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DECKDES)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCondition(c22348060.condition)
	e1:SetTarget(c22348060.target)
	e1:SetOperation(c22348060.operation)
	e1_1:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1_1:SetRange(0xff)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MONSTER_SSET)
	e4:SetValue(TYPE_TRAP)
	c:RegisterEffect(e4)
	--set2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22348060,0))
	e5:SetCategory(CATEGORY_POSITION+CATEGORY_DECKDES)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(c22348060.target)
	e5:SetOperation(c22348060.operation)
	c:RegisterEffect(e5)
	--SpecialSummon
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(22348060,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetCondition(c22348060.spcon)
	e6:SetTarget(c22348060.sptg)
	e6:SetOperation(c22348060.spop)
	c:RegisterEffect(e6)
	SNNM.ActivatedAsSpellorTrapCheck(c)
	SNNM.SetAsSpellorTrapCheck(c,0x4)
end
function c22348060.setfilter(c,lv)
	return c:IsFaceup() and c:IsCanTurnSet() and c:IsLevelBelow(lv)
end
function c22348060.tgfilter(c,tp)
	return c:IsAbleToGrave() and c:IsSetCard(0x3702) and Duel.IsExistingMatchingCard(c22348060.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c:GetLevel())
end
function c22348060.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22348060.tgfilter,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
end
function c22348060.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c22348060.tgfilter,tp,LOCATION_DECK,0,1,1,nil,tg)
	local tc=g1:GetFirst()
	if tc and Duel.SendtoGrave(tc,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_GRAVE) and Duel.IsExistingMatchingCard(c22348060.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,tc:GetLevel()) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g2=Duel.SelectMatchingCard(tp,c22348060.setfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,tc:GetLevel())
		if g2:GetFirst():IsFaceup() then
			Duel.ChangePosition(g2:GetFirst(),POS_FACEDOWN_DEFENSE)
		end
	end
end
function c22348060.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_TRAP)
end
function c22348060.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c22348060.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)~=0 then
		Duel.ConfirmCards(1-tp,c)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		c:RegisterEffect(e1,true)
	end
end
function c22348060.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetType()==TYPE_TRAP and (Duel.GetTurnCount()~=c:GetTurnID() or c:IsHasEffect(EFFECT_TRAP_ACT_IN_SET_TURN))
end