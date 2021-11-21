--last upd 2021-11-17
Seine_Quirk_Buddy={}
local qb=_G["Seine_Quirk_Buddy"]
qb.cardlist={31412001,31412002,31412003,31412004,31412005,31412006,31412007,31412008,31412009,31412010,31412011,31412012,31412013}
function qb.usual_form_enable(c,attr)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,qb.linkfilter(attr),2,2)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(qb.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(qb.efilter(attr))
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCountLimit(1,m)
	e3:SetCondition(qb.thcon)
	e3:SetTarget(qb.thtg(attr))
	e3:SetOperation(qb.thop(attr))
	c:RegisterEffect(e3)
end
function qb.splimit(e,c,sump,sumtype,sumpos,targetp)
	local g=e:GetHandler():GetLinkedGroup()
	local res=false
	local chkc=g:GetFirst()
	while chkc do
		if chkc:IsCode(table.unpack(qb.cardlist)) and chkc:IsSummonType(SUMMON_TYPE_LINK) and bit.band(c:GetAttribute(),chkc:GetAttribute())~=0 then
			res=true
		end
		chkc=g:GetNext()
	end
	return res
end
function qb.linkfilter(attr)
	return function (c)
		return c:IsAttribute(attr) and not c:IsSummonLocation(LOCATION_EXTRA)
	end
end
function qb.efilter(attr)
	return function (e,te)
		local tc=te:GetOwner()
		return tc:IsType(TYPE_MONSTER) and tc:IsAttribute(attr) and tc~=e:GetOwner()
	end
end
function qb.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp and c:IsPreviousControler(tp))) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function qb.thfilter(attr)
	return function (c)
		return c:IsAttackBelow(1500) and c:IsAttribute(attr) and c:IsAbleToHand()
	end
end
function qb.thtg(attr)
	return function (e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsExistingMatchingCard(qb.thfilter(attr),tp,LOCATION_DECK,0,1,nil) end
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function qb.thop(attr)
	return function (e,tp,eg,ep,ev,re,r,rp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,qb.thfilter(attr),tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function qb.quirk_form_enable(c,attr,cat,tg,op,code)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,3,99,qb.linkgfilter(attr))
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(qb.matcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetLabelObject(e0)
	e1:SetCondition(qb.cdspcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(qb.efilter(attr))
	e2:SetCondition(qb.immcon)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON+cat)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	--e3:SetCondition(qb.etcon)
	e3:SetTarget(tg)
	e3:SetOperation(qb.quirk_op(op,code))
	c:RegisterEffect(e3)
end
function qb.linkgfilter(attr)
	return function (g)
		return g:GetClassCount(Card.GetLinkAttribute)==g:GetCount() and g:FilterCount(Card.IsLinkAttribute,nil,attr)
	end
end
function qb.matcheck(e,c)
	e:SetLabel(e:GetHandler():GetMaterial():FilterCount(Card.IsCode,table.unpack(qb.cardlist)))
end
function qb.cdspcon(e)
	return e:GetLabelObject():GetLabel()>0 and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function qb.immcon(e)
	local mat=e:GetHandler():GetMaterial()
	return mat:GetCount()==mat:FilterCount(Card.IsLinkAbove,nil,2) and e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function qb.efilter(attr)
	return function (e,te)
		return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and not (te:IsActiveType(TYPE_MONSTER) and te:GetHandler():IsAttribute(attr) and te:IsActivated())
	end
end
function qb.etcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function qb.quirk_sp_filter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function qb.quirk_op(op,code)
	return function (e,tp,eg,ep,ev,re,r,rp)
		op(e,tp,eg,ep,ev,re,r,rp)
		if Duel.IsExistingMatchingCard(qb.quirk_sp_filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,code) and Duel.SelectYesNo(tp,aux.Stringid(31412000,0)) then
			local g=Duel.SelectMatchingCard(tp,qb.quirk_sp_filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,code)
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
		if e:GetHandler():IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SendtoDeck(e:GetHandler(),nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	end
end