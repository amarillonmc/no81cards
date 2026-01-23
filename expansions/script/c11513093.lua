--人理嘘饰 厄斐墨洛斯
local m=11513093
local cm=_G["c"..m]
function cm.initial_effect(c)
	--cg
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,11513093)
	e1:SetCondition(c11513093.cgcon)
	e1:SetTarget(c11513093.cgtg)
	e1:SetOperation(c11513093.cgop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11513093,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_TO_DECK)
	e2:SetCondition(c11513093.thcon)
	e2:SetTarget(c11513093.thtg)
	e2:SetOperation(c11513093.thop)
	c:RegisterEffect(e2)
end
function c11513093.cgcon(e,tp,eg,ep,ev,re,r,rp)
	return  ep~=tp
end
function c11513093.cgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d1=(re:IsHasCategory(CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_TOHAND)) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
	local d2=re:IsHasCategory(CATEGORY_TOGRAVE) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	local d3=re:IsHasCategory(CATEGORY_REMOVE) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
	if chk==0 then return d1 or d2 or d3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c11513093.cgop(e,tp,eg,ep,ev,re,r,rp)
	local off=1
	local ops={}
	local opval={}
	local c=e:GetHandler()
	local d1=(re:IsHasCategory(CATEGORY_DRAW) or re:IsHasCategory(CATEGORY_TOHAND)) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil)
	local d2=re:IsHasCategory(CATEGORY_TOGRAVE) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_DECK,0,1,nil)
	local d3=re:IsHasCategory(CATEGORY_REMOVE) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=1 and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
	if d1 then
		ops[off]=aux.Stringid(11513093,0)
		opval[off-1]=1
		off=off+1
	end
	if d2 then
		ops[off]=aux.Stringid(11513093,1)
		opval[off-1]=2
		off=off+1
	end
	if d3 then
		ops[off]=aux.Stringid(11513093,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	if opval[op]==1 then
		Duel.ChangeChainOperation(ev,c11513093.threpop)
	elseif opval[op]==2 then
		Duel.ChangeChainOperation(ev,c11513093.tgrepop)
	elseif opval[op]==3 then
		Duel.ChangeChainOperation(ev,c11513093.rerepop)
	end
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 and Duel.IsExistingMatchingCard(c11513093.penfilter,tp,LOCATION_EXTRA,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(11513093,3)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,c11513093.penfilter,tp,LOCATION_EXTRA,0,1,1,nil)
		local tc=g:GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function c11513093.penfilter(c)
	return c:IsCode(11513094) and c:IsType(TYPE_PENDULUM) and not c:IsForbidden() and c:IsFacedown()
end
function c11513093.threpop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sg=g:GetMaxGroup(Card.GetSequence)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
	end
end
function c11513093.tgrepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sg=g:GetMaxGroup(Card.GetSequence)
	if sg:GetCount()>0 then
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c11513093.rerepop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	local sg=g:GetMaxGroup(Card.GetSequence)
	if sg:GetCount()>0 then
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function c11513093.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c11513093.thfilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsSetCard(0x0ff1) and c:IsAbleToHand()
end
function c11513093.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11513093.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c11513093.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c11513093.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
