--化胧点津
local s,id,o=GetID()
function s.initial_effect(c)
	--发动
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--① 送墓等级比原本高的化胧怪兽，同属性化胧从额外特召
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(s.spcon)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--② 4张回卡组底，抽1或破坏非恶魔族
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,id)
	e3:SetTarget(s.rettg)
	e3:SetOperation(s.retop)
	c:RegisterEffect(e3)
end
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x894)
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function s.exfilter(c,e,tp,attr)
	return c:IsSetCard(0x894) and c:IsType(TYPE_MONSTER) and c:IsAttribute(attr)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function s.gfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x894) and c:IsType(TYPE_MONSTER)
		and c:GetLevel()>c:GetOriginalLevel() and c:IsAbleToGrave()
		and Duel.IsExistingMatchingCard(s.exfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetAttribute())
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetFlagEffect(tp,id+200)>=4 then return false end
		return Duel.IsExistingMatchingCard(s.gfilter,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,id+200,RESET_PHASE+PHASE_END,0,0)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.gfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	if #g==0 then return end
	local tc=g:GetFirst()
	local attr=tc:GetAttribute()
	if Duel.SendtoGrave(tc,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,s.exfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,attr)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.retfilter(c)
	return c:IsSetCard(0x894) and c:IsAbleToDeck()
end
function s.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.retfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.retfilter,tp,LOCATION_GRAVE,0,4,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,s.retfilter,tp,LOCATION_GRAVE,0,4,4,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,4,0,0)
end
function s.desfilter(c)
	return not c:IsRace(RACE_FIEND)
end
function s.retop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetTargetsRelateToChain()
	if #tg==0 then return end
	if Duel.SendtoDeck(tg,nil,SEQ_DECKBOTTOM,REASON_EFFECT)~=0 then
		local op=aux.SelectFromOptions(tp,
			{true,aux.Stringid(id,2),1},
			{true,aux.Stringid(id,3),2})
		if op==1 then
			Duel.Draw(tp,1,REASON_EFFECT)
		elseif op==2 then
			local g=Duel.GetMatchingGroup(s.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end
