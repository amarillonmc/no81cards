--宇宙姬的更衣
local s,id,o=GetID()
function s.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1101)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
function s.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_PSYCHO) and c:GetBaseAttack()==900
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function s.spfilter(c,e,tp,code)
	return c:IsSetCard(0xCA7D) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsCode(code)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local code=tc:GetCode()
	if tc:IsRelateToChain() and Duel.Destroy(tc,REASON_EFFECT)>0 then
		local b1=Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		local b2=Duel.IsPlayerCanDraw(tp,2)
		local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(id,0)},{b2,aux.Stringid(id,1)},{true,aux.Stringid(id,2)})
		if op==1 then 
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
			if #sg>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		elseif op==2 then
			Duel.BreakEffect()
			Duel.Draw(tp,2,REASON_EFFECT)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local sg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
			if #sg>0 then
				Duel.Destroy(sg,REASON_EFFECT)
			end
		end
	end
end