--破械使者 科阿罗
function c98920168.initial_effect(c)	
  --link summon
	aux.AddLinkProcedure(c,c98920168.mfilter,1,1)
	c:EnableReviveLimit()	
		--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98920168,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c98920168.poscon)
	e1:SetCountLimit(1,98920168)
	e1:SetTarget(c98920168.target)
	e1:SetOperation(c98920168.operation)
	c:RegisterEffect(e1)   
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c98920168.valcheck)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)   
	--link summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920168,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c98920168.poscon1)
	e2:SetCountLimit(1,98930168)
	e2:SetTarget(c98920168.target1)
	e2:SetOperation(c98920168.operation1)
	c:RegisterEffect(e2)	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(c98920168.valcheck1)
	e4:SetLabelObject(e2)
	c:RegisterEffect(e4)  
end
function c98920168.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end
function c98920168.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsSetCard,1,nil,0x130) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98920168.mfilter(c)
	return not c:IsLinkType(TYPE_LINK) and c:IsLinkRace(RACE_FIEND)
end
function c98920168.filter(c)
	return c:IsFaceup() and c:GetAttack()>0
end
function c98920168.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c98920168.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c98920168.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c98920168.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,1,0,0)
end
function c98920168.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()	
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e4)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetValue(RESET_TURN_SET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e3)
	end
end
function c98920168.tgfilter(c,tp,ec)
	local mg=Group.FromCards(c,ec)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c98920168.lfilter,tp,LOCATION_EXTRA,0,1,nil,mg)
end
function c98920168.lfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsLinkSummonable(mg,nil,2,2)
end
function c98920168.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)	  
	local c=e:GetHandler()
	local zone=c:GetLinkedZone(tp)
	local lg=c:GetLinkedGroup()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(c98920168.tgfilter,tp,0,LOCATION_MZONE,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c98920168.tgfilter,tp,0,LOCATION_MZONE,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c98920168.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and c:IsControler(tp)
		and tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) then
		local mg=Group.FromCards(c,tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920168.lfilter,tp,LOCATION_EXTRA,0,1,1,nil,mg)
		local lc=g:GetFirst()
		if lc then
			Duel.LinkSummon(tp,lc,mg,nil,2,2)
		end
	end
end
function c98920168.valcheck1(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsAttribute,1,nil,ATTRIBUTE_FIRE) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c98920168.poscon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetLabel()==1
end