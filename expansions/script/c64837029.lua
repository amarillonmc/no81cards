--『开始吧，一辈子的约定』千早爱音
local s,id=GetID()
function s.initial_effect(c)
	 aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_FIRE),aux.NonTuner(Card.IsAttribute,ATTRIBUTE_FIRE),1)
	c:EnableReviveLimit()
 --to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
 --negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+10000)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.negcon)
	e2:SetTarget(s.negtg)
	e2:SetOperation(s.negop)
	c:RegisterEffect(e2)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.thfilter(c,e,tp,ft)
	return c:IsAttribute(ATTRIBUTE_FIRE) and (c:IsAbleToHand() or (ft>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)))
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,5) end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	 local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			if g:IsExists(s.thfilter,1,nil,e,tp,ft) then
				local tg=g:Filter(s.thfilter,nil,e,tp,ft)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
				local tc=tg:Select(tp,1,1,nil):GetFirst()
				local opt=0
				if not tc:IsAbleToHand() then
					opt=1
				elseif not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) or ft<=0 then
					opt=0
				else
					opt=Duel.SelectOption(tp,1190,1152)
				end
				if opt==0 then
					Duel.SendtoHand(tc,nil,REASON_EFFECT)
					Duel.ConfirmCards(1-tp,tc)
				else
					Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
				end
			end
		   
		end
	end
end
--
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return ep~=tp and (LOCATION_HAND+LOCATION_ONFIELD)&loc~=0
end
function s.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsFaceupEx()
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_MZONE,0,1,1,nil)
		if dg:GetCount()>0 and  Duel.Destroy(dg,REASON_EFFECT)~=0 then  
				local g=Group.CreateGroup()
				Duel.ChangeTargetCard(ev,g)
				Duel.ChangeChainOperation(ev,s.repop)
		end
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		Duel.SendtoGrave(c,REASON_EFFECT) 
end















