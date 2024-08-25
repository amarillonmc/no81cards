--数码兽超进化-徽章
function c50218127.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c50218127.target)
	e1:SetOperation(c50218127.activate)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(c50218127.reptg)
	e2:SetValue(c50218127.repval)
	e2:SetOperation(c50218127.repop)
	c:RegisterEffect(e2)
end
function c50218127.tgfilter(c,e,tp)
	if not c:IsSetCard(0xcb1) or not c:IsAbleToGrave() or not c:IsFaceup() then return false end
	local code=c:GetOriginalCode()
	local class=_G["c"..code]
	if class==nil or class.lvup==nil then return false end
	return Duel.IsExistingMatchingCard(c50218127.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,class,e,tp)
end
function c50218127.spfilter(c,class,e,tp)
	local code=c:GetCode()
	return c:IsCode(table.unpack(class.lvup)) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c50218127.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c50218127.tgfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c50218127.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tgc=Duel.SelectMatchingCard(tp,c50218127.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	if not tgc then return end
	if Duel.SendtoGrave(tgc,REASON_EFFECT)>0 and tgc:IsLocation(LOCATION_GRAVE)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		e:SetLabel(tgc:GetOriginalCode())
		local code=e:GetLabel()
		local class=_G["c"..code]
		if class==nil or class.lvup==nil then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c50218127.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,class,e,tp)
		local tc=g:GetFirst()
		if tc then
			Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
			if tc:IsPreviousLocation(LOCATION_DECK) then Duel.ShuffleDeck(tp) end
		end
	end
end
function c50218127.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xcb1) and c:IsLocation(LOCATION_MZONE)
		and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function c50218127.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(c50218127.repfilter,1,nil,tp) end
	return Duel.SelectEffectYesNo(tp,e:GetHandler(),96)
end
function c50218127.repval(e,c)
	return c50218127.repfilter(c,e:GetHandlerPlayer())
end
function c50218127.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
