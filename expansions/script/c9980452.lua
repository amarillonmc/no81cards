--SB-333 Delta
function c9980452.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c9980452.matfilter,2,2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(9980452,0))
	e3:SetCategory(CATEGORY_TODECK)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_CONFIRM)
	e3:SetCondition(c9980452.atkcon)
	e3:SetOperation(c9980452.atkop)
	c:RegisterEffect(e3)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9bca))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9980452,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,9980452)
	e1:SetCondition(c9980452.condition)
	e1:SetTarget(c9980452.target)
	c:RegisterEffect(e1)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980452.sumsuc)
	c:RegisterEffect(e8)
end
function c9980452.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980452,0)) 
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980452,4)) 
end 
function c9980452.matfilter(c)
	return c:IsLinkRace(RACE_FAIRY) and c:IsLinkAttribute(ATTRIBUTE_LIGHT)
end
function c9980452.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc and bc:IsFaceup() and bc:IsRelateToBattle() and bc:GetBaseAttack()*2~=c:GetAttack()
end
function c9980452.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if c:IsFaceup() and c:IsRelateToBattle() and bc:IsFaceup() and bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(bc:GetBaseAttack()*2)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
	end
end
function c9980452.condition(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c9980452.thfilter1(c)
	return c:IsSetCard(0x9bca) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c9980452.thfilter2(c)
	return c:IsType(TYPE_SPELL) and c:IsType(TYPE_RITUAL) and c:IsAbleToHand()
end
function c9980452.desfilter(c,e,tp,g)
	return c:IsFaceup() and (c:IsRace(RACE_FAIRY) or c:IsRace(RACE_WARRIOR))and g:IsContains(c) and Duel.GetMZoneCount(tp,c)>0
		and Duel.IsExistingMatchingCard(c9980452.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c)
end
function c9980452.spfilter(c,e,tp,dc)
	return c:IsSetCard(0x9bca) and c:GetOriginalCode()~=dc:GetOriginalCode() and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9980452.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(c9980452.thfilter1,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c9980452.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,e,tp,e:GetHandler():GetLinkedGroup())
	if chk==0 then return b1 or b2 end
	local op=-1
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(9980452,1),aux.Stringid(9980452,2))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(9980452,1))
	else
		op=Duel.SelectOption(tp,aux.Stringid(9980452,2))+1
	end
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetOperation(c9980452.thop)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	elseif op==1 then
		e:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
		e:SetOperation(c9980452.desop)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_MZONE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c9980452.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c9980452.thfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local g2=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9980452.thfilter2),tp,LOCATION_GRAVE,0,nil)
		if g2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(9980452,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg2=g2:Select(tp,1,1,nil)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980452,5)) 
			Duel.SendtoHand(sg2,nil,REASON_EFFECT)
		end
	end
end
function c9980452.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dc=Duel.SelectMatchingCard(tp,c9980452.desfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp,lg):GetFirst()
	if dc and Duel.Destroy(dc,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c9980452.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp,dc):GetFirst()
		if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2,true)
			Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980452,5)) 
			Duel.SpecialSummonComplete()
		end
	end
end
