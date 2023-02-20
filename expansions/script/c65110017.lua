--坎特伯雷 守护者
function c65110017.initial_effect(c)
	aux.AddCodeList(c,65110002)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,c65110017.mfilter)
	c:EnableReviveLimit()
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c65110017.descon)
	e1:SetCountLimit(1,65110017)
	e1:SetTarget(c65110017.tg)
	e1:SetOperation(c65110017.op)
	c:RegisterEffect(e1)
	--at limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)  
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c65110017.atlimit)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)   
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c65110017.atlimit)
	e3:SetValue(aux.tgoval)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c65110017.atlimit)
	e4:SetValue(1)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	c:RegisterEffect(e4)
end
function c65110017.mfilter(g,lc)
	return g:IsExists(Card.IsLinkCode,1,nil,65110008)
end
function c65110017.atlimit(e,c)
	return c:IsFaceup() and c:IsCode(65110002)
end
function c65110017.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c65110017.eqfilter(c,equip,tp)
	return c:IsCode(65110019)and (c:IsAbleToHand() or equip and c:CheckUniqueOnField(tp)and not c:IsForbidden())
end
function c65110017.filter(c)
	return c:IsCode(65110017) and c:IsFaceup()
end
function c65110017.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
			and Duel.IsExistingMatchingCard(c65110017.filter,tp,LOCATION_MZONE,0,1,nil)
		return Duel.IsExistingMatchingCard(c65110017.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,equip,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)

end
function c65110017.op(e,tp,eg,ep,ev,re,r,rp)
	local equip=Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c65110017.filter,tp,LOCATION_MZONE,0,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,c65110017.eqfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,equip,tp)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		if equip and not tc:IsForbidden() and (not tc:IsAbleToHand() or Duel.SelectOption(tp,1190,aux.Stringid(65110017,1))==1 and tc:CheckUniqueOnField(tp))  then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local sc=Duel.SelectMatchingCard(tp,c65110017.filter,tp,LOCATION_MZONE,0,1,1,nil)
			Duel.Equip(tp,tc,sc:GetFirst())
		else
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
