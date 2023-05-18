--地中族邪界兽·西西里岩十字龙
function c98920347.initial_effect(c)
	 --link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_FLIP),3,3)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920347,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,98920347)
	e1:SetTarget(c98920347.postg)
	e1:SetOperation(c98920347.posop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(98920347,1))
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_FLIP)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,98930347)
	e3:SetCondition(c98920347.thcon)
	e3:SetTarget(c98920347.thtg)
	e3:SetOperation(c98920347.thop)
	c:RegisterEffect(e3)
end
function c98920347.posfilter(c,e,tp)
	return c:IsFacedown() and Duel.IsExistingMatchingCard(c98920347.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,c)
end
function c98920347.spfilter(c,e,tp,dc)
	return c:IsSetCard(0xed) and c:IsType(TYPE_MONSTER) and not c:IsLevel(dc:GetLevel()) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c98920347.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920347.posfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920347.posop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local dc=Duel.SelectMatchingCard(tp,c98920347.posfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if dc then
		 Duel.ConfirmCards(1-tp,dc)
		 local tg=Duel.SelectMatchingCard(tp,c98920347.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,dc):GetFirst()
		 Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		 Duel.ConfirmCards(1-tp,tg)
	end
end
function c98920347.cfilter(c,ec)
	if c:IsLocation(LOCATION_MZONE) then
		return ec:GetLinkedGroup():IsContains(c)
	else
		return bit.extract(ec:GetLinkedZone(c:GetPreviousControler()),c:GetPreviousSequence())~=0
	end
end
function c98920347.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920347.cfilter,1,nil,e:GetHandler())
end
function c98920347.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c98920347.cfilter,nil,e:GetHandler())
	local tg=g:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.SetTargetCard(tg)
end
function c98920347.thop(e,tp,eg,ep,ev,re,r,rp) 
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		if g:GetCount()>1 then
			 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			 g=g:Select(tp,1,1,nil)
		end
		local lv=g:GetFirst():GetLevel()
		Duel.Damage(1-tp,lv*200,REASON_EFFECT)
   end
end