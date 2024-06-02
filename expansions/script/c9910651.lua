--拉尼亚凯亚之灾劫
function c9910651.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CONTINUOUS_TARGET)
	e1:SetTarget(c9910651.target)
	e1:SetOperation(c9910651.activate)
	c:RegisterEffect(e1)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(aux.chainreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c9910651.tgcon)
	e3:SetOperation(c9910651.tgop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910651,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c9910651.spcon)
	e4:SetTarget(c9910651.sptg)
	e4:SetOperation(c9910651.spop)
	c:RegisterEffect(e4)
end
function c9910651.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c9910651.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9910651.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9910651.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c9910651.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9910651.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		c:SetCardTarget(tc)
	end
end
function c9910651.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and tc:IsSetCard(0xa952) and re and re:IsActiveType(TYPE_MONSTER) and rp~=tp and e:GetHandler():GetFlagEffect(1)>0
end
function c9910651.tgop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSendtoGrave(1-tp) then return end
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	local tc=e:GetHandler():GetFirstCardTarget()
	local ct=g:GetCount()-tc:GetOverlayCount()
	if ct>0 then
		Duel.Hint(HINT_CARD,0,9910651)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TOGRAVE)
		local sg=g:FilterSelect(1-tp,Card.IsAbleToGrave,ct,ct,nil,1-tp,nil)
		Duel.SendtoGrave(sg,REASON_RULE)
	end
end
function c9910651.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c9910651.spfilter(c,e,tp)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c9910651.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910651.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsChainDisablable(0) then
		local tc=e:GetHandler():GetFirstCardTarget()
		local hg=Duel.GetMatchingGroup(Card.IsCanOverlay,1-tp,LOCATION_HAND,0,nil,tp)
		Duel.Hint(HINT_SELECTMSG,1-tp,aux.Stringid(9910651,1))
		if tc and not tc:IsImmuneToEffect(e) and #hg>0 then
			sel=Duel.SelectOption(1-tp,1213,1214)
		else
			sel=Duel.SelectOption(1-tp,1214)+1
		end
		if sel==0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			local sg=hg:Select(1-tp,1,1,nil)
			Duel.Overlay(tc,sg)
			Duel.NegateEffect(0)
			return
		end
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c9910651.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
