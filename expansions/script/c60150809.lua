--真正的虚无-爱莎
function c60150809.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x3b23),2)
	c:EnableReviveLimit()
	--除外1
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c60150809.drcon)
	e1:SetOperation(c60150809.drop)
	c:RegisterEffect(e1)
	--除外2
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c60150809.drcon2)
	e2:SetOperation(c60150809.drop2)
	c:RegisterEffect(e2)
	--除外3
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c60150809.drcon3)
	e3:SetOperation(c60150809.drop3)
	c:RegisterEffect(e3)
	--除外4
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c60150809.drcon4)
	e4:SetOperation(c60150809.drop4)
	c:RegisterEffect(e4)
	--indes
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e6)
end
function c60150809.efilter(e,te)
	return te:IsActiveType(TYPE_TRAP)
end
function c60150809.mfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_SPELLCASTER) and c:GetRank()==8
end
function c60150809.xyzfilter1(c,g)
	return g:IsExists(c60150809.xyzfilter2,1,c,c:GetRank())
end
function c60150809.xyzfilter2(c,rk)
	return c:GetRank()==8
end
function c60150809.xyzcon(e,c,og)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c60150809.mfilter,tp,LOCATION_MZONE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:IsExists(c60150809.xyzfilter1,1,nil,mg)
end
function c60150809.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
	local mg=Duel.GetMatchingGroup(c60150809.mfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=mg:FilterSelect(tp,c60150809.xyzfilter1,1,1,nil,mg)
	local tc1=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g2=mg:FilterSelect(tp,c60150809.xyzfilter2,1,1,tc1,tc1:GetRank())
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	local sg1=tc1:GetOverlayGroup()
	local sg2=tc2:GetOverlayGroup()
	sg1:Merge(sg2)
	Duel.SendtoGrave(sg1,REASON_RULE)
	c:SetMaterial(g1)
	Duel.Overlay(c,g1)
end
function c60150809.sfilter(c,sp)
	return c:GetSummonPlayer()==sp
end
function c60150809.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_HAND)
end
function c60150809.drop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c60150809.sfilter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_GRAVE)>0 then
		Duel.Hint(HINT_CARD,0,60150809)
		local tc=Duel.GetFieldCard(1-tp,LOCATION_GRAVE,Duel.GetFieldGroupCount(1-tp,LOCATION_GRAVE,0)-1)
		if tc then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c60150809.drcon2(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_GRAVE)
end
function c60150809.drop2(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c60150809.sfilter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 then
		Duel.Hint(HINT_CARD,0,60150809)
		local tc=Duel.GetFieldCard(1-tp,LOCATION_DECK,Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)-1)
		if tc then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c60150809.drcon3(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_DECK)
end
function c60150809.drop3(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c60150809.sfilter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 then
		Duel.Hint(HINT_CARD,0,60150809)
		local tc=Duel.GetFieldCard(1-tp,LOCATION_EXTRA,Duel.GetFieldGroupCount(1-tp,LOCATION_EXTRA,0)-1)
		if tc then
			Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
function c60150809.drcon4(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_EXTRA)
end
function c60150809.drop4(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c60150809.sfilter,1,nil,1-tp) and Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 then
		Duel.Hint(HINT_CARD,0,60150809)
		local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(tp,1)
		Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c60150809.filter(c)
	return (c:IsFaceup() or c:IsFacedown()) and c:IsAbleToChangeControler()
end
function c60150809.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(1-tp) and c60150809.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingTarget(c60150809.filter,tp,0,LOCATION_REMOVED,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c60150809.filter,tp,0,LOCATION_REMOVED,1,1,nil)
end
function c60150809.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(c,Group.FromCards(tc))
	end
end
function c60150809.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_EXTRA+LOCATION_ONFIELD):RandomSelect(tp,1)
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c60150809.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE) and c:CheckRemoveOverlayCard(tp,1,REASON_BATTLE) end
	if Duel.SelectYesNo(tp,aux.Stringid(60150809,2)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end
function c60150809.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and c:CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	if Duel.SelectYesNo(tp,aux.Stringid(60150809,2)) then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		return true
	else return false end
end